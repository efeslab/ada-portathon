include ../../../../common/makefiles/Makefile.include

BMARK=sphinx
INPUT=test

AUDIO_FILE = audio.raw
LANGUAGE_MODEL = ../language_model/turtle/

include $(MAKEFILE_COMMON_DIR)/Makefile.common

# Overriding C_SRC variable
C_SRC=../../src/c/main.c \
../../src/c/pocketsphinx/*.c \
../../src/c/sphinxbase/fe/*.c \
../../src/c/sphinxbase/feat/*.c \
../../src/c/sphinxbase/lm/*.c \
../../src/c/sphinxbase/util/*.c

# Overriding c-run command
c-run: compile
	@echo -e "Data set\t\t- $(INPUT)" 
	@./$(BMARK)$(EXE) $(DATA_DIR)/$(AUDIO_FILE) $(DATA_DIR)/$(LANGUAGE_MODEL) 2> /dev/null | tee $(TIMING_DIR)/C_$(INPUT).txt

# Overriding debug command
debug: compile
	@echo -e "Data set\t\t- $(INPUT)" 
	@./$(BMARK)$(EXE) $(DATA_DIR)/$(AUDIO_FILE) $(DATA_DIR)/$(LANGUAGE_MODEL)