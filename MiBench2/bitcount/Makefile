TARGET=bitcount
OBJS = bitcnt_1.c bitcnt_2.c bitcnt_3.c bitcnt_4.c bitcnts.c bitfiles.c bitstrng.c bstr_i.c 

include ../Makefile.config

%.o: %.c
	$(CC) ${FLAGS} $(INCLIB) -c -o $@ $<

$(TARGET): $(OBJS) 
	$(CC) $(FLAGS) $(OBJS) -o $(TARGET) $(LIBS)

run:
	$(submit) ./$(TARGET)

clean: 
	rm -rf $(TARGET) *.o *.elf output* *.lst *.bin *~

