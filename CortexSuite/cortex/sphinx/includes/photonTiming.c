/********************************
Author: Sravanthi Kota Venkata
********************************/

/** C File **/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#include "timingUtils.h"

unsigned int* photonStartTiming()
{
	unsigned int *array;

    array = (unsigned int*)malloc(sizeof(unsigned int)*2);
	magic_timing_begin(array[0], array[1]);
    return array;
}

unsigned int * photonReportTiming(unsigned int* startCycles,unsigned int* endCycles)
{

    unsigned int *elapsed;
    elapsed = (unsigned int*)malloc(sizeof(unsigned int)*2);
	unsigned long long start = (((unsigned long long)0x0) | startCycles[0]) << 32 | startCycles[1];
	unsigned long long end = (((unsigned long long)0x0) | endCycles[0]) << 32 | endCycles[1];
	unsigned long long diff = end - start;
	elapsed[0] = (unsigned int)(diff >> 32);
	elapsed[1] = (unsigned int)(diff & 0xffffffff);
    return elapsed;

}

void photonPrintTiming(unsigned int * elapsed)
{
    if(elapsed[1] == 0)
	    printf("Cycles elapsed\t\t- %u\n\n", elapsed[0]);
    else
	    printf("Cycles elapsed\t\t- %u%u\n\n", elapsed[1], elapsed[0]);
}

unsigned int * photonEndTiming()
{
	unsigned int *array;
    array = (unsigned int*)malloc(sizeof(unsigned int)*2);

	magic_timing_begin(array[0], array[1]);
	return array;
}



/** End of C Code **/
