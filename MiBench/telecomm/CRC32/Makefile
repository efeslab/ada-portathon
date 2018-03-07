CC=${TARGET_CC}

crc: crc_32.c Makefile
	$(CC) -static crc_32.c -O3 -o crc 

clean:
	rm -rf crc output*
