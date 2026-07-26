# ============================================================
# CSC2059 Practical Publishing Pipeline
# ============================================================
#
# Source files:
#   src/labs/LabXX/*.tex
#
# Temporary build files:
#   build/LabXX/<document>/
#
# Final PDFs:
#   pdf/LabXX/<document>.pdf
#
# Commands:
#   make
#   make one LAB=Lab03
#   make VERBOSE=1
#   make one LAB=Lab03 VERBOSE=1
#   make list
#   make clean
#   make distclean
#
# ============================================================

SHELL := /bin/bash
.DEFAULT_GOAL := all

ROOT_DIR   := $(CURDIR)
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


# ------------------------------------------------------------
# Shared build procedure
#
# Parameter:
#   $(1) = optional lab name, such as Lab03
# ------------------------------------------------------------

define BUILD_DOCUMENTS
	@set -uo pipefail; \
	\
	LAB_FILTER="$(1)"; \
	START_TIME=$$SECONDS; \
	BUILT=0; \
	FAILED=0; \
	TOTAL_WARNINGS=0; \
	\
	if [ -t 1 ] && [ -z "$${NO_COLOR:-}" ]; then \
		BOLD=$$'\033[1m'; \
		DIM=$$'\033[2m'; \
		RED=$$'\033[31m'; \
		GREEN=$$'\033[32m'; \
		YELLOW=$$'\033[33m'; \
		BLUE=$$'\033[34m'; \
		CYAN=$$'\033[36m'; \
		RESET=$$'\033[0m'; \
	else \
		BOLD=""; DIM=""; RED=""; GREEN=""; \
		YELLOW=""; BLUE=""; CYAN=""; RESET=""; \
	fi; \
	\
	printf "\n"; \
	printf "%sCSC2059 Publishing Pipeline%s\n" "$$BOLD" "$$RESET"; \
	printf "%s===========================%s\n\n" "$$DIM" "$$RESET"; \
	\
	if [ -n "$$LAB_FILTER" ]; then \
		SEARCH_ROOT="$(SOURCE_DIR)/$$LAB_FILTER"; \
		if [ ! -d "$$SEARCH_ROOT" ]; then \
			printf "%sError:%s lab directory does not exist:\n" \
				"$$RED" "$$RESET"; \
			printf "  %s\n\n" "$$SEARCH_ROOT"; \
			exit 1; \
		fi; \
	else \
		SEARCH_ROOT="$(SOURCE_DIR)"; \
	fi; \
	\
	while IFS= read -r tex; do \
		lab="$$(basename "$$(dirname "$$tex")")"; \
		name="$$(basename "$$tex" .tex)"; \
		build_dir="$(BUILD_DIR)/$$lab/$$name"; \
		pdf_dir="$(PDF_DIR)/$$lab"; \
		log_file="$$build_dir/build.log"; \
		\
		mkdir -p "$$build_dir" "$$pdf_dir"; \
		\
		printf "%sBuilding%s %-12s %s...%s " \
			"$$CYAN" "$$RESET" "$$lab" "$$name" "$$RESET"; \
		\
		if [ "$(VERBOSE)" = "1" ]; then \
			printf "\n\n"; \
			TEXMF_OUTPUT_DIRECTORY="$$build_dir" \
				$(LATEXMK) \
				$(LATEX_FLAGS) \
				-cd \
				-outdir="$$build_dir" \
				"$$tex" 2>&1 | tee "$$log_file"; \
			status=$${PIPESTATUS[0]}; \
		else \
			TEXMF_OUTPUT_DIRECTORY="$$build_dir" \
				$(LATEXMK) \
				-silent \
				$(LATEX_FLAGS) \
				-cd \
				-outdir="$$build_dir" \
				"$$tex" >"$$log_file" 2>&1; \
			status=$$?; \
		fi; \
		\
		if [ "$$status" -ne 0 ]; then \
			FAILED=$$((FAILED + 1)); \
			printf "%sFAILED%s\n" "$$RED" "$$RESET"; \
			printf "\n%sLast 30 lines of the build log:%s\n\n" \
				"$$BOLD" "$$RESET"; \
			tail -n 30 "$$log_file"; \
			printf "\n%sFull log:%s %s\n\n" \
				"$$YELLOW" "$$RESET" "$$log_file"; \
			break; \
		fi; \
		\
		generated_pdf="$$build_dir/$$name.pdf"; \
		\
		if [ ! -f "$$generated_pdf" ]; then \
			FAILED=$$((FAILED + 1)); \
			printf "%sFAILED%s\n" "$$RED" "$$RESET"; \
			printf "Expected PDF was not generated:\n"; \
			printf "  %s\n\n" "$$generated_pdf"; \
			break; \
		fi; \
		\
		cp "$$generated_pdf" "$$pdf_dir/$$name.pdf"; \
		BUILT=$$((BUILT + 1)); \
		\
		warnings=$$( \
			grep -Eic \
				'LaTeX Warning|Package .* Warning|Overfull|Underfull' \
				"$$log_file" 2>/dev/null || true \
		); \
		\
		TOTAL_WARNINGS=$$((TOTAL_WARNINGS + warnings)); \
		\
		if [ "$$warnings" -gt 0 ]; then \
			printf "%sOK%s %s(%s warning%s)%s\n" \
				"$$GREEN" "$$RESET" \
				"$$YELLOW" "$$warnings" \
				"$$( [ "$$warnings" -eq 1 ] || printf "s" )" \
				"$$RESET"; \
		else \
			printf "%sOK%s\n" "$$GREEN" "$$RESET"; \
		fi; \
		\
		if [ "$(VERBOSE)" = "1" ]; then \
			printf "\n"; \
		fi; \
	\
	done < <( \
		if [ -n "$$LAB_FILTER" ]; then \
			find "$$SEARCH_ROOT" \
				-maxdepth 1 \
				-type f \
				-name '*.tex' \
				-print | sort; \
		else \
			find "$$SEARCH_ROOT" \
				-mindepth 2 \
				-maxdepth 2 \
				-type f \
				-name '*.tex' \
				-path '*/Lab*/*' \
				-print | sort; \
		fi \
	); \
	\
	ELAPSED=$$((SECONDS - START_TIME)); \
	\
	printf "\n"; \
	\
	if [ "$$FAILED" -gt 0 ]; then \
		printf "%sBuild stopped after a failure.%s\n" \
			"$$RED" "$$RESET"; \
		printf "%sSuccessful documents:%s %s\n\n" \
			"$$DIM" "$$RESET" "$$BUILT"; \
		exit 1; \
	fi; \
	\
	if [ "$$BUILT" -eq 0 ]; then \
		printf "%sNo LaTeX source files were found.%s\n\n" \
			"$$YELLOW" "$$RESET"; \
		exit 1; \
	fi; \
	\
	printf "%sBuild complete%s\n" "$$GREEN$$BOLD" "$$RESET"; \
	printf "%s--------------%s\n" "$$DIM" "$$RESET"; \
	printf "Documents:  %s\n" "$$BUILT"; \
	printf "Warnings:   %s\n" "$$TOTAL_WARNINGS"; \
	printf "Time:       %ss\n" "$$ELAPSED"; \
	printf "PDF output: %s\n\n" "$(PDF_DIR)"
endef


# ------------------------------------------------------------
# Build targets
# ------------------------------------------------------------

all:
	$(call BUILD_DOCUMENTS,)


# Build every .tex file in one lab:
#
#   make one LAB=Lab03

one:
	@if [ -z "$(LAB)" ]; then \
		echo "Usage: make one LAB=Lab03"; \
		exit 1; \
	fi
	$(call BUILD_DOCUMENTS,$(LAB))


# ------------------------------------------------------------
# Utility targets
# ------------------------------------------------------------

list:
	@printf "\nCSC2059 LaTeX sources\n"
	@printf "=====================\n\n"
	@find "$(SOURCE_DIR)" \
		-mindepth 2 \
		-maxdepth 2 \
		-type f \
		-name '*.tex' \
		-path '*/Lab*/*' \
		-print | sort
	@printf "\n"


# Remove temporary build files but preserve final PDFs.

clean:
	@printf "Removing temporary build files...\n"
	@rm -rf "$(BUILD_DIR)"
	@printf "Build directory removed.\n"


# Remove both build files and generated PDFs.

distclean:
	@printf "Removing build files and generated PDFs...\n"
	@rm -rf "$(BUILD_DIR)" "$(PDF_DIR)"
	@printf "Build and PDF directories removed.\n"


help:
	@printf "\nCSC2059 Publishing Pipeline\n"
	@printf "===========================\n\n"
	@printf "  make\n"
	@printf "      Build every practical quietly.\n\n"
	@printf "  make one LAB=Lab03\n"
	@printf "      Build every .tex file in one lab folder.\n\n"
	@printf "  make VERBOSE=1\n"
	@printf "      Build everything and show complete LaTeX output.\n\n"
	@printf "  make one LAB=Lab03 VERBOSE=1\n"
	@printf "      Build one lab and show complete LaTeX output.\n\n"
	@printf "  make list\n"
	@printf "      List all discovered LaTeX source files.\n\n"
	@printf "  make clean\n"
	@printf "      Remove temporary build files but retain PDFs.\n\n"
	@printf "  make distclean\n"
	@printf "      Remove temporary build files and generated PDFs.\n\n"
	@printf "  NO_COLOR=1 make\n"
	@printf "      Disable coloured terminal output.\n\n"