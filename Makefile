EMACS ?= emacs
EASK ?= eask
wget ?= wget

BATCH := $(EMACS) -Q -batch
EL = $(filter-out %-autoloads.el, $(wildcard *.el))

.PHONY: clean distclean
all:

README.md: el2markdown.el $(EL)
	$(BATCH) -l $< $(EL) -f el2markdown-write-readme
	$(RM) $@~

.INTERMEDIATE: el2markdown.el
el2markdown.el:
	$(wget) \
  -q -O $@ "https://github.com/Lindydancer/el2markdown/raw/master/el2markdown.el"

distclean: clean
	$(RM) *.elc *autoloads.el *loaddefs.el TAGS


.PHONY: clean checkdoc lint package install compile test

ci: clean package install compile

package:
	@echo "Packaging..."
	$(EASK) package

install:
	@echo "Installing..."
	$(EASK) install

compile:
	@echo "Compiling..."
	$(EASK) compile

test:
	@echo "Testing..."
	$(EASK) test ert ./test/*.el

checkdoc:
	@echo "Run checkdoc..."
	$(EASK) lint checkdoc

lint:
	@echo "Run package-lint..."
	$(EASK) lint package

clean:
	$(EASK) clean-all
