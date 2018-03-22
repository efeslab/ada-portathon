subdirs = adpcm_decode dijkstra bitcount fft stringsearch aes blowfish patricia basicmath susan rsa sha adpcm_encode crc qsort


all:
	for dir in $(subdirs); do\
		$(MAKE) -C $$dir;\
		done

run:
	for dir in $(subdirs); do\
		$(MAKE) -C $$dir run;\
		done

clean:
	for dir in $(subdirs); do\
		$(MAKE) -C $$dir clean;\
		done






