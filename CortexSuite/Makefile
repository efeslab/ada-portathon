# Top level makefile for CortexSuite (BETA)
# UCSD
#
#

subdirs = lda liblinear motion-estimation pca rbm sphinx srr svd3

ifneq ($(riscv),)
        export CC=$(riscv)
	export cc=$(riscv)
	CFLAGS += -Driscv
endif

vision:
	make -C ${CURDIR}/vision/ c-run

run-all: run-small run-medium run-large

compile:
	for dir in $(subdirs); do\
		$(MAKE) -C cortex/$$dir compile riscv=$(riscv);\
		done
	
run-small:
	for dir in $(subdirs); do\
		$(MAKE) -C cortex/$$dir run-small submit="$(submit)";\
		done
run-medium:
	for dir in $(subdirs); do\
		$(MAKE) -C cortex/$$dir run-medium submit="$(submit)";\
		done
	
run-large:
	for dir in $(subdirs); do\
		$(MAKE) -C cortex/$$dir run-large submit="$(submit)";\
		done

cycles:
	@echo ---------------------
	@echo Small Datasets Cycle
	@echo ---------------------
	@echo
	-grep Cycles cortex/results/*.small
	@echo
	@echo
	
	@echo ---------------------
	@echo Medium  Datasets Cycle
	@echo ---------------------
	@echo
	-grep Cycles cortex/results/*.medium
	@echo
	@echo
	
	@echo ---------------------
	@echo Large Datasets Cycle
	@echo ---------------------
	@echo
	-grep Cycles cortex/results/*.large
	@echo
	@echo
	
clean:
	for dir in $(subdirs); do\
		$(MAKE) -C cortex/$$dir clean;\
		done
	
