FILE1 = qsort_small.c
FILE2 = qsort_large.c
CC=${TARGET_CC}

all: qsort_small qsort_large

qsort_small: qsort_small.c Makefile
	$(CC) -static qsort_small.c -O3 -o qsort_small -lm
qsort_large: qsort_large.c Makefile
	$(CC) -static qsort_large.c -O3 -o qsort_large -lm

clean:
	rm -rf qsort_small qsort_large output*
