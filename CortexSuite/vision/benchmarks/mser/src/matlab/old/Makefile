# file:        Makefile
# author:      Andrea Vedaldi
# description: Build mex files

# --------------------------------------------------------------------
# 
# --------------------------------------------------------------------

# Determine on the flight the system we are running on
Darwin_ARCH := mac
Linux_ARCH  := glx
ARCH := $($(shell uname)_ARCH)

mac_CFLAGS       := -I. -pedantic -Wall -Wno-long-long
mac_MEX_CFLAGS   := -g -O CFLAGS='$$CFLAGS $(mac_CFLAGS)'
mac_MEX_SUFFIX   := mexmac

glx_CFLAGS       := -I. -pedantic -Wall -Wno-long-long
glx_MEX_CFLAGS   := -g -O CFLAGS='$$CFLAGS $(glx_CFLAGS)'
glx_MEX_SUFFIX   := mexglx

MEX_SUFFIX       := $($(ARCH)_MEX_SUFFIX)
MEX_CFLAGS       := $($(ARCH)_MEX_CFLAGS)

VER              := 0.4
DIST             := mser-$(VER)
BINDIST          := $(DIST)-$(ARCH)

# --------------------------------------------------------------------
#
# --------------------------------------------------------------------

vpath %.mex.c .

src  := $(wildcard *.mex.c)
msrc := $(wildcard *.m)
stem := $(notdir $(basename $(basename $(src))))
tgt  := $(addprefix ./, $(addsuffix .$(MEX_SUFFIX),$(stem)))

%.$(MEX_SUFFIX) : %.mex.c
	mex -I. $(MEX_CFLAGS) $< -output $*

.PHONY: all
all: $(tgt)

.PHONY: info
info :
	@echo src  = $(src)
	@echo stem = $(stem)
	@echo tgt  = $(tgt)

# PDF documentation
.PHONY: doc
doc: mser.html doc/mser.pdf

mser.html : $(msrc)
	mdoc --output=mser.html . \
	     --exclude='.*(_demo|_compile).*.m'

.PHONY: clean
clean:
	rm -f $(tgt)
	find . -name '.DS_Store' -exec rm -f \{\} \;
	find . -name '.gdb_history' -exec rm -f \{\} \;
	find . -name '*~' -exec rm -f \{\} \;
	find . -name '*.bak' -exec rm -f \{\} \;
	make -C doc/figures clean

.PHONY: distclean
distclean: clean
	rm -f *.mexmac *.mexglx
	rm -f mser.html
	rm -f mser-*.tar.gz
	rm -f doc/*.log
	rm -f doc/*.aux
	rm -f doc/*.toc
	rm -f doc/*.bbl
	rm -f doc/*.blg
	rm -f doc/*.out
	rm -f $(DIST).tar.gz
	rm -f $(BINDIST).tar.gz
	rm -rf $(BINDIST)

.PHONY: dist
dist: distclean
	echo Version $(VER) >TIMESTAMP
	echo Archive created on `date` >>TIMESTAMP
	d=$(notdir $(CURDIR)) ; \
	tar chzvf $(DIST).tar.gz \
	  --exclude mser_demo4.m \
	  --exclude data/seq.avi \
	  --exclude results \
	  ../$${d}

.PHONY: bindist
bindist: all
	test -e $(BINDIST) || mkdir $(BINDIST)
	cp *.$(MEX_SUFFIX) $(BINDIST)
	cd $(BINDIST) ; strip -S *.$(MEX_SUFFIX)
	tar chzvf $(BINDIST).tar.gz $(BINDIST)

.PHONY: autorights
autorights:
	autorights . \
	  --verbose \
	  --recursive \
	  --template cal \
	  --years 2006 \
	  --authors "Andrea Vedaldi (UCLA VisionLab)" \
	  --program "Video Extremal Regions"

doc/mser.pdf : doc/*.tex doc/*.bib doc/figures/*.fig
	make -C doc/figures all
	cd doc ; \
	for k in 1 2 3 ; \
	do \
	  pdflatex -file-line-error-style -interaction batchmode \
	    mser.tex ; \
	  if test "$$k" = '1' ; \
	  then \
	    bibtex mser.aux ; \
	  fi ; \
	done
