find-dir-with = $(shell /usr/bin/perl -e 'chomp($$_ = `pwd`); while ($$_ ne "" && ! -e "$$_/$(1)") { m:(.*)/[^/]+/??:; $$_ = $$1; } print;')

# define canonical directories in starsearch
ifndef TOP_DIR
  export TOP_DIR := $(call find-dir-with,.SD-VBS)
endif

export MAKEFILE_COMMON_DIR=$(TOP_DIR)/common/makefiles


BMARK=disparity
INPUT=qcif
include $(MAKEFILE_COMMON_DIR)/Makefile.common


