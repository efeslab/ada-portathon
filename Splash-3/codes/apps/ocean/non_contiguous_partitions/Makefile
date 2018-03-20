TARGET = OCEAN
OBJS = jacobcalc.o laplacalc.o main.o multi.o slave1.o slave2.o

include ../../../Makefile.config

run:
	$(submit) ./$(TARGET) -p$(threads) -n258


decs.h: decs.h.in
jacobcalc.c: decs.h
main.c: decs.h
slave1.c: decs.h
laplacalc.c: decs.h
multi.c : decs.h
slave2.c: decs.h

