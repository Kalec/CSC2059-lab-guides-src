TEXFILES :=$(wildcard src/labs/*.tex)
PDFS :=$(patsubst src/labs/%.tex,pdf/%.pdf,$(TEXFILES))

LATEXMK := latexmk
LATEXOPTS := -lualatex -shell-escape -interaction=nonstopmode -halt-on-error

.PHONY: all clean distclean list

all:  $(PDFS)

pdf/%.pdf: src/labs/%.tex
	@mkdir -p build/$* pdf
	$(LATEXMK) $(LATEXOPTS) -outdir=build/$* $<
	cp build/$*/$*.pdf pdf/$*.pdf

list:
	@echo $(TEXFILES)

clean:
	rm -rf build

distclean:
	rm -rf build pdf


