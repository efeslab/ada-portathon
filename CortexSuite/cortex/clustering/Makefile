# Top level makefile for CortexSuite (BETA)
# UCSD
#
#

subdirs = kmeans spectral

run-all: run-small run-medium run-large

compile:
	for dir in $(subdirs); do\
		$(MAKE) -C $$dir compile;\
		done
	
run-small:
	for dir in $(subdirs); do\
		$(MAKE) -C $$dir run-small;\
		done
run-medium:
	for dir in $(subdirs); do\
		$(MAKE) -C $$dir run-medium;\
		done
	
run-large:
	for dir in $(subdirs); do\
		$(MAKE) -C $$dir run-large;\
		done
	
clean:
	for dir in $(subdirs); do\
		$(MAKE) -C $$dir clean;\
		done
	
