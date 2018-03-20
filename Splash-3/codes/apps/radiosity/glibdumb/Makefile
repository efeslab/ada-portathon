#
#  Device independent graphics package GLIB.
#  NULL graphic device version
#

OBJS   = glib.o
TARGET = glib.a

include ../../../Makefile.config

C_FILES = $(wildcard *.c)

$(OBJS): $(C_FILES)
	$(CC) $(C_FILES) -c -o $(OBJS)

$(TARGET): $(OBJS)
	$(AR) crv $(TARGET) $(OBJS)

clean:
	rm -rf $(OBJS) $(TARGET)
