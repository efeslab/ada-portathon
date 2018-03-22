TARGET=adpcm_decode
OBJS = rawdaudio.o adpcm.o

include ../Makefile.config

%.o: %.c
	$(CC) ${FLAGS} $(INCLIB) -c -o $@ $<

$(TARGET): $(OBJS) 
	$(CC) $(FLAGS) $(OBJS) -o $(TARGET) $(LIBS)

run:
	$(submit) ./$(TARGET)

clean: 
	rm -rf $(TARGET) *.o *.elf output* *.lst *.bin *~
