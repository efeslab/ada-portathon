PREFIX=${PARSECDIR}/pkgs/apps/fluidanimate/inst/${PARSECPLAT}
TARGET=fluidanimate

all:
	$(MAKE) -f Makefile.${version} all CXX=$(COMPILER)

clean:
	$(MAKE) -f Makefile.${version} clean CXX=$(COMPILER)

install:
	mkdir -p $(PREFIX)/bin
	cp -f $(TARGET) $(PREFIX)/bin/$(TARGET)

run:
	$(RUN_BINARY) $(TARGET) 1 1 ../inputs/in_5K.fluid ./out_5K.fluid
