#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void USAGE()
{
	printf("USAGE: \n");
	printf("./kmeans data_file n m k \n");
	printf("data_file = dataset text file in the format specified below \n");
	printf("n = total number of data points \n");
	printf("m = dimensionality of data \n");
	printf("k = number of desired clusters\n");
	printf("\n");
	printf("**** data_file format ****\n");
	printf("data_file should be in the form nxm\n");
	printf("n = number of rows (total number of data points)\n");
	printf("m = number of columns (data point dimensions)\n");
}

void get_data(const char* data_file, int n, int m, double **data)
{
	int i, j;
	FILE *fp = fopen(data_file,"r");

	for(i=0; i<n; i++)
	{
		for(j=0; j<m; j++)
			fscanf(fp, "%lf", &data[i][j]);
	}
}

int main(int argc, char *argv[])
{

	char data_file[1000] = "./datasets/spiral";
	int n = 312, m = 2, k=3;
	int i, j;

	unsigned int *start, *stop, *elapsed;
	start = photonStartTiming();

	if(argc != 5) {
		USAGE();
		return 0;
	}
	else{
		strcpy(data_file, (const char*)argv[1]);
		n = atoi(argv[2]);
		m = atoi(argv[3]);
		k = atoi(argv[4]);
	}

	//alloc data
	double **data = calloc(n, sizeof(double *));
	for(i=0; i<n; i++)
	{
		data[i] = calloc(m, sizeof(double));
	}

	get_data(data_file, n, m, data);

	int *c = k_means(data, n, m, k, 1e-8, 0);

	for (i = 0; i < n; i++) {
		printf("data point %d is in cluster %d\n", i, c[i]);
	}

	stop = photonEndTiming();
	elapsed = photonReportTiming(start,stop);
	photonPrintTiming(elapsed);

	//free memory
	if(!c) free(c);
	for(i=0; i<n; i++) {
		free(data[i]);
	}
	if(!data) free(data);

	return 0;
}
