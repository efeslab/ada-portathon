#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#include "rbm.h"

// Input/output data
#define TRAIN_FILE "data.txt"
#define TEST_FILE "data.txt"
#define OUTPUT_FILE "out.txt"

// Free parameters
#define DEBUG 0
#define K 5
#define LEARN_RATE 0.1
#define NUM_HIDDEN (3*MOVIES)
#define RAND rand_twister()

// Fixed constants
#define NUM_VISIBLE (MOVIES * K)



double edges[NUM_VISIBLE + 1][NUM_HIDDEN + 1]; // edges[v][h] = the edge between visible unit v and hidden unit h
int trainingData[USERS][NUM_VISIBLE];

int testActuals[TEST_USERS][MOVIES];
int testPredictions[TEST_USERS][MOVIES];



void activateHiddenUnits(int visible[], int stochastic, int hidden[])
{
	// Calculate activation energy for hidden units
	double hiddenEnergies[NUM_HIDDEN];
	int h;
	for (h = 0; h < NUM_HIDDEN; h++)
	{
		// Get the sum of energies
		double sum = 0;
		int v;
		for (v = 0; v < NUM_VISIBLE + 1; v++) // remove the +1 if you want to skip the bias
		{
			if (visible[v] != -1)
				sum += (double) visible[v] * edges[v][h];
		}
		hiddenEnergies[h] = sum;
	}

	// Activate hidden units
	for (h = 0; h < NUM_HIDDEN; h++)
	{
		double prob = 1.0 / (1.0 + exp(-hiddenEnergies[h]));
		if (stochastic)
		{
			if (RAND < prob)
				hidden[h] = 1;
			else
				hidden[h] = 0;
		}
		else
		{
			if (prob > 0.5)
				hidden[h] = 1;
			else
				hidden[h] = 0;
		}
	}

	hidden[NUM_HIDDEN] = 1; // turn on bias
}


void activateVisibleUnits(int hidden[], int stochastic, int visible[])
{
	// Calculate activation energy for visible units
	double visibleEnergies[NUM_VISIBLE];
	int v;
	for (v = 0; v < NUM_VISIBLE; v++)
	{
		// Get the sum of energies
		double sum = 0;
		int h;
		for (h = 0; h < NUM_HIDDEN + 1; h++) // remove the +1 if you want to skip the bias
			sum += (double) hidden[h] * edges[v][h];
		visibleEnergies[v] = sum;
	}

	// Activate visible units, handles K visible units at a time
	for (v = 0; v < NUM_VISIBLE; v += K)
	{
		double exps[K]; // this is the numerator
		double sumOfExps = 0.0; // this is the denominator

		int j;
		for (j = 0; j < K; j++)
		{
			exps[j] = exp(visibleEnergies[v + j]);
			sumOfExps += exps[j];
		}

		// Getting the probabilities

		double probs[K];

		for (j = 0; j < K; j++)
			probs[j] = exps[j] / sumOfExps;

		// Activate units

		if (stochastic) // used for training
		{
			for (j = 0; j < K; j++)
			{
				if (RAND < probs[j])
					visible[v + j] = 1;
				else
					visible[v + j] = 0;
			}
		}
		else // used for prediction: uses expectation
		{

			double expectation = 0.0;
			for (j = 0; j < K; j++)
				expectation += j * probs[j]; // we will predict rating between 0 to K-1, not between 1 to K

			long prediction = round(expectation);

			for (j = 0; j < K; j++)
			{
				if (j == prediction)
					visible[v + j] = 1;
				else
					visible[v + j] = 0;
			}
		}
	}

	visible[NUM_VISIBLE] = 1; // turn on bias
}

void train()
{
	int user;
	for (user = 0; user < USERS; user++)
	{
		// ==> Phase 1: Activate hidden units

		int data[NUM_VISIBLE + 1];
		memcpy(data, trainingData[user], NUM_VISIBLE * sizeof(int)); // copy entire array
		data[NUM_VISIBLE] = 1; // turn on bias

		// Activate hidden units
		int hidden[NUM_HIDDEN + 1];
		activateHiddenUnits(data, 1, hidden);

		// Get positive association
		int pos[NUM_VISIBLE + 1][NUM_HIDDEN + 1];
		int v;
		for (v = 0; v < NUM_VISIBLE + 1; v++)
		{
			if (data[v] != -1)
			{
				int h;
				for (h = 0; h < NUM_HIDDEN + 1; h++)
					pos[v][h] = data[v] * hidden[h];
			}
		}

		// ==> Phase 2: Reconstruction (activate visible units)

		// Activate visible units
		int visible[NUM_VISIBLE + 1];
		activateVisibleUnits(hidden, 1, visible);

		// Get negative association
		int neg[NUM_VISIBLE + 1][NUM_HIDDEN + 1];
		for (v = 0; v < NUM_VISIBLE + 1; v++)
		{
			if (data[v] != -1)
			{
				int h;
				for (h = 0; h < NUM_HIDDEN + 1; h++)
					neg[v][h] = hidden[h] * visible[v];
			}
		}

		// ==> Phase 3: Update the weights
		for (v = 0; v < NUM_VISIBLE + 1; v++)
		{
			int h;
			for (h = 0; h < NUM_HIDDEN + 1; h++)
				edges[v][h] = edges[v][h] + LEARN_RATE * (pos[v][h] - neg[v][h]);
		}
	}
}

void processLine(int target[], FILE * stream, int optActual[])
{
	int j;
	for (j = 0; j < NUM_VISIBLE; j += K)
	{
		int rating = 0;
		if(fscanf(stream, "%d", &rating) != 1 ) {
      printf("ERROR: Failed to read stream");
    }
		if (optActual != NULL)
			optActual[j / K] = rating;

		int k;
		for (k = 0; k < K; k++)
		{
			if (rating <= 0)
				target[j + k] = -1; // missing rating
			else if (rating == k + 1)
				target[j + k] = 1;
			else
				target[j + k] = 0;
		}
	}
}

int main(int argc, char *argv[])
{
  //**Timing**/
  unsigned int* start, *stop, *elapsed;
	// -------- Preparing training data ---------

	FILE *trainingFile = fopen(TRAIN_FILE, "r");
	int i, j, k;
	for (i = 0; i < USERS; i++)
	{
		processLine(trainingData[i], trainingFile, NULL);
	}

	fclose(trainingFile);


	// -------- Training ---------

    
	int loop;
	for (loop = 0; loop < LOOPS; loop++)
	{
		if (DEBUG)
		    printf("Loop: %d\n", loop);
		train();
	}


	if (DEBUG)
	{
		// Print weights

		for (i = 0; i < NUM_VISIBLE + 1; i++)
		{
			for (j = 0; j < NUM_HIDDEN + 1; j++)
				printf("%5.2f ", edges[i][j]);

			printf("\n");
		}
	}

	// -------- Testing ---------


	FILE *testFile = fopen(TEST_FILE, "r");
	FILE *outputFile = fopen(OUTPUT_FILE, "w");


	int user;
	for (user = 0; user < TEST_USERS; user++)
	{
		int data[NUM_VISIBLE + 1];
		processLine(data, testFile, testActuals[user]);
		data[NUM_VISIBLE] = 1; // turn on bias

		int tmp[NUM_HIDDEN + 1];
		activateHiddenUnits(data, 0, tmp);
		int result[NUM_VISIBLE + 1];
		activateVisibleUnits(tmp, 0, result);


		// Go through K visible units at a time
		for (i = 0; i < NUM_VISIBLE; i += K)
		{
			int prediction = 0;

			for (j = 0; j < K; j++)
			{
				if (result[i + j] == 1)
				{
					if (prediction == 0)
						prediction = j+1;
					else
					{
						printf("ERROR! Found more than one 1s in the same movie\n");
						exit(1);
					}
				}
			}

			if (prediction == 0)
			{
				printf("ERROR! No prediction was made for this movie!\n");
				exit(1);
			}
			testPredictions[user][i / K] = prediction;
		}
	}

	fclose(testFile);
	// -------- Writing result ---------


	for (i = 0; i < TEST_USERS; i++)
	{
		for (j = 0; j < MOVIES; j++)
			fprintf(outputFile, "%d ", testPredictions[i][j]);
		fprintf(outputFile, "\n");
	}

	fclose(outputFile);

	return 0;

}
