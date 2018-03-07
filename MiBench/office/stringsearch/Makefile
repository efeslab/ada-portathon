FILE1 = bmhasrch.c  bmhisrch.c  bmhsrch.c  pbmsrch_small.c 
FILE2 = bmhasrch.c  bmhisrch.c  bmhsrch.c  pbmsrch_large.c 
CC=${TARGET_CC}

all: search_small search_large

search_small: ${FILE1} Makefile
	$(CC) -static ${FILE1} -O3 -o search_small

search_large: ${FILE2} Makefile
	$(CC) -static ${FILE2} -O3 -o search_large

clean:
	rm -rf search_small search_large output*
