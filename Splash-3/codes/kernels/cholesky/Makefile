TARGET = CHOLESKY
OBJS = amal.o assign.o bfac.o bksolve.o block2.o fo.o malloc.o \
       mf.o numLL.o parts.o seg.o solve.o tree.o util.o

include ../../Makefile.config

run:
	$(submit) ./$(TARGET) -p$(threads) < inputs/tk15.O


amal.c: matrix.h
block2.c: matrix.h
numLL.c: matrix.h
tree.c: matrix.h
assign.c: matrix.h
fo.c: matrix.h
parts.c: matrix.h
util.c: matrix.h
bfac.c: matrix.h
malloc.c: matrix.h
seg.c: matrix.h
bksolve.c: matrix.h
mf.c: matrix.h
solve.c: matrix.h

