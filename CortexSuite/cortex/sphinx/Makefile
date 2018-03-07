CC = gcc
ifneq ($(riscv),)
        CFLAGS += -Driscv
endif


compile:
	$(CC) $(CFLAGS) main.c ../../includes/*.c pocketsphinx/*.c sphinxbase/fe/*.c sphinxbase/feat/*.c sphinxbase/lm/*.c sphinxbase/util/*.c -o sphinx -O2 -lm

run-all: run-small run-medium run-large

run-small:
	-./sphinx small/audio.raw language_model/turtle/ 2> /dev/null 2>&1 | tee ../results/sphinx.small

run-medium:
	-./sphinx medium/audio.raw language_model/HUB4/ 2> /dev/null 2>&1 | tee ../results/sphinx.medium

run-large:
	-./sphinx large/audio.raw language_model/HUB4/ 2> /dev/null 2>&1 | tee ../results/sphinx.large

clean:
	-rm out.txt sphinx
