CC=gcc
CFLAGS=-I.
SOURCES= main.c mnist_parse.c vector.c Preferences.c NeuralNetwork.c MNistDoc.c
DEPS= mnist_parse.h
OBJECTS=main.o mnist_parse.o
EXECUTABLE=main
all:
	$(CC) -o $(EXECUTABLE) $(SOURCES) -lm -w -g
run:
	./main
clean:
	rm $(EXECUTABLE)
