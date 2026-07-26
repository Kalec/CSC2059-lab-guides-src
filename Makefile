# CSC2059 practical publishing pipeline
#
# Source:
#   src/labs/LabXX/*.tex
#
# Temporary build files:
#   build/LabXX/<document-name>/
#
# Final PDFs:
#   pdf/LabXX/<document-name>.pdf

SHELL := /bin/bash

ROOT_DIR  := $(CURDIR)
SOURCE_DIR := $(ROOT_DIR)/src/labs
BUILD_DIR  := $(ROOT_DIR)/build
PDF_DIR    := $(ROOT_DIR)/pdf

LATEXMK := latexmk
LATEX_FLAGS := \
	-lualatex \
	-shell-escape \
	-interaction=nonstopmode \
	-halt-on-error \
	-file-line-error

.PHONY: all one list clean distclean help

# Build every .tex file found directly inside LabXX folders.
all:
	@set -e; \
	found=0; \
	for tex in "$(SOURCE_DIR)"/Lab*/*.tex; do \
		[ -f "$$tex" ] || continue; \
		found=1; \
		lab="$$(basename "$$(dirname "$$tex")")"; \
		name="$$(basename "$$tex" .tex)"; \
		build_dir="$(BUILD_DIR)/$$lab/$$name"; \
		pdf_dir="$(PDF_DIR)/$$lab"; \
		echo ""; \
		echo "========================================"; \
		echo "Building $$lab/$$name.tex"; \
		echo "========================================"; \
		mkdir -p "$$build_dir" "$$pdf_dir"; \
		TEXMF_OUTPUT_DIRECTORY="$$build_dir" \
			$(LATEXMK) \
			$(LATEX_FLAGS) \
			-cd \
			-outdir="$$build_dir" \
			"$$tex"; \
		cp "$$build_dir/$$name.pdf" "$$pdf_dir/$$name.pdf"; \
		echo "Created pdf/$$lab/$$name.pdf"; \
	done; \
	if [ "$$found" -eq 0 ]; then \
		echo "No .tex files found under src/labs/Lab*/"; \
		exit 1; \
	fi

# Build one lab:
#
#   make one LAB=Lab01
#
# This builds every .tex file directly inside that lab folder.
one:
	@if [ -z "$(LAB)" ]; then \
		echo "Usage: make one LAB=Lab01"; \
		exit 1; \
	fi
	@set -e; \
	found=0; \
	for tex in "$(SOURCE_DIR)/$(LAB)"/*.tex; do \
		[ -f "$$tex" ] || continue; \
		found=1; \
		lab="$(LAB)"; \
		name="$$(basename "$$tex" .tex)"; \
		build_dir="$(BUILD_DIR)/$$lab/$$name"; \
		pdf_dir="$(PDF_DIR)/$$lab"; \
		echo ""; \
		echo "========================================"; \
		echo "Building $$lab/$$name.tex"; \
		echo "========================================"; \
		mkdir -p "$$build_dir" "$$pdf_dir"; \
		TEXMF_OUTPUT_DIRECTORY="$$build_dir" \
			$(LATEXMK) \
			$(LATEX_FLAGS) \
			-cd \
			-outdir="$$build_dir" \
			"$$tex"; \
		cp "$$build_dir/$$name.pdf" "$$pdf_dir/$$name.pdf"; \
		echo "Created pdf/$$lab/$$name.pdf"; \
	done; \
	if [ "$$found" -eq 0 ]; then \
		echo "No .tex files found in src/labs/$(LAB)/"; \
		exit 1; \
	fi

# Show the source files that will be built.
list:
	@find "$(SOURCE_DIR)" \
		-mindepth 2 \
		-maxdepth 2 \
		-type f \
		-name '*.tex' \
		-path '*/Lab*/*' \
		-print | sort

# Remove temporary build artefacts but retain final PDFs.
clean:
	rm -rf "$(BUILD_DIR)"

# Remove temporary build artefacts and final PDFs.
distclean:
	rm -rf "$(BUILD_DIR)" "$(PDF_DIR)"

help:
	@echo "CSC2059 publishing targets"
	@echo ""
	@echo "  make                 Build every practical"
	@echo "  make all             Build every practical"
	@echo "  make one LAB=Lab01   Build one lab folder"
	@echo "  make list            Show discovered .tex files"
	@echo "  make clean           Remove temporary build files"
	@echo "  make distclean       Remove build files and PDFs"