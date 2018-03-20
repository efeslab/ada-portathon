#
#  CS348C  Radiosity     Device independent graphics package GLIB.
#                        SUN/Xview version makefile
#
#

TARGET = glibps.a
OBJS   = glibps.o

include ../../../Makefile.config

C_FILES = $(wildcard *.c)

$(OBJS): $(C_FILES)
	$(CC) $(C_FILES) -c -o $(OBJS)

$(TARGET): $(OBJS)
	$(AR) crv $(TARGET) $(OBJS)

clean:
	rm -rf *.o $(TARGET)

