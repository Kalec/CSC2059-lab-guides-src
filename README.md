# CSC2059 Practical Publishing Pipeline

This folder contains the LaTeX source files, shared template, assets, temporary build files, and generated PDFs for the CSC2059 practical guides.

The root `Makefile` provides a consistent publishing workflow for all practicals. It discovers the relevant `.tex` files, compiles them with LuaLaTeX through `latexmk`, keeps temporary files out of the source folders, and copies the final PDFs into the dedicated `pdf/` directory.

## Folder Structure

```text
.
├── Makefile
├── README.md
├── assets/
│   ├── figures/
│   │   ├── practical01/
│   │   ├── practical03/
│   │   └── ...
│   └── qub-logo.pdf
├── build/
├── pdf/
├── src/
│   └── labs/
│       ├── Lab01/
│       ├── Lab02/
│       ├── Lab03/
│       └── ...
└── template/
    └── csc2059practical.cls
```

### `src/labs/`

Contains the LaTeX source files for the practical guides.

Each practical should be stored in its corresponding lab folder:

```text
src/labs/Lab01/
src/labs/Lab02/
src/labs/Lab03/
...
```

The publishing pipeline discovers `.tex` files located directly inside folders matching:

```text
src/labs/Lab*/*.tex
```

### `assets/`

Contains shared images and practical-specific figures.

### `template/`

Contains the reusable CSC2059 LaTeX document class:

```text
template/csc2059practical.cls
```

### `build/`

Contains temporary LaTeX build files, including:

- `.aux`
- `.log`
- `.toc`
- `.out`
- `.fls`
- `.fdb_latexmk`
- `minted` cache files
- intermediate PDFs

Build files are separated by lab and document name.

For example:

```text
build/Lab03/practical03/
```

This directory may be deleted safely. It will be recreated automatically during the next build.

### `pdf/`

Contains the final published PDF files.

For example:

```text
pdf/Lab03/practical03.pdf
```

Only successfully compiled PDFs are copied into this directory.

---

# Requirements

The publishing pipeline expects the following tools to be installed and available from the terminal:

- GNU Make
- `latexmk`
- LuaLaTeX
- TeX Live
- Python and `latexminted`, as required by `minted`
- Pygments

The LaTeX documents use shell escape for syntax highlighting through `minted`.

You can confirm that the main tools are available with:

```bash
make --version
latexmk --version
lualatex --version
```

---

# Recommended Compilation Workflow

The following workflow is recommended whenever source files are added, renamed, moved, or substantially edited.

## 1. Confirm which source files will be compiled

Run:

```bash
make list
```

This prints every `.tex` file currently recognised by the publishing pipeline.

Check that:

- every intended practical is listed;
- the files appear under the correct `LabXX` folder;
- no obsolete, backup, or experimental `.tex` files are included;
- file names are correct.

Example output:

```text
CSC2059 LaTeX sources
=====================

.../src/labs/Lab01/practical01.tex
.../src/labs/Lab02/practical02.tex
.../src/labs/Lab03/practical03.tex
```

Running `make list` before a full build is particularly useful after reorganising files or adding a new practical.

## 2. Build one practical first

Before compiling the complete collection, build the practical currently being edited:

```bash
make one LAB=Lab03
```

Replace `Lab03` with the appropriate folder name.

This compiles every `.tex` file located directly inside:

```text
src/labs/Lab03/
```

A successful quiet build should produce output similar to:

```text
CSC2059 Publishing Pipeline
===========================

Building Lab03        practical03... OK

Build complete
--------------
Documents:  1
Warnings:   0
Time:       3s
PDF output: .../pdf
```

The final PDF will be written to:

```text
pdf/Lab03/
```

## 3. Review the generated PDF

Open the PDF and check:

- title and practical number;
- table of contents;
- headers and footers;
- figures and image paths;
- code blocks;
- page breaks;
- internal references;
- hyperlinks;
- warning boxes and other callouts;
- final page count.

The Makefile confirms that compilation succeeded, but it cannot detect visual or editorial problems.

## 4. Inspect any reported warnings

A build may succeed while reporting warnings:

```text
Building Lab03        practical03... OK (2 warnings)
```

Warnings may include:

- unresolved references;
- overfull boxes;
- underfull boxes;
- package warnings;
- layout problems.

The full captured output is stored in:

```text
build/Lab03/<document-name>/build.log
```

For example:

```text
build/Lab03/practical03/build.log
```

## 5. Build all practicals

Once the individual practical compiles correctly, run:

```bash
make
```

or equivalently:

```bash
make all
```

This compiles every recognised practical in lab order and copies the successful PDFs into their corresponding folders under `pdf/`.

## 6. Check the final PDF collection

Review the contents of:

```text
pdf/
```

Confirm that each expected lab has a current PDF and that no obsolete documents remain.

---

# Available Commands

## `make`

Build every recognised practical quietly.

```bash
make
```

This is the default command and is equivalent to:

```bash
make all
```

During a normal successful build, most LaTeX output is hidden. A short status line is shown for each document.

---

## `make all`

Build every recognised practical quietly.

```bash
make all
```

Source files are discovered under:

```text
src/labs/Lab*/*.tex
```

Temporary files are written under:

```text
build/LabXX/<document-name>/
```

Final PDFs are copied to:

```text
pdf/LabXX/
```

---

## `make list`

Show every LaTeX source file that the publishing pipeline will compile.

```bash
make list
```

Use this before a full build to confirm that the correct files have been discovered.

This command does not compile anything.

---

## `make one LAB=LabXX`

Build every `.tex` file in one lab folder.

```bash
make one LAB=Lab03
```

The `LAB` value must match an existing folder under `src/labs/`.

For example:

```bash
make one LAB=Lab01
make one LAB=Lab07
make one LAB=Lab10
```

If the lab folder does not exist, or contains no `.tex` files, the build will stop with an error.

---

## `make VERBOSE=1`

Build every practical and display the complete output from `latexmk` and LuaLaTeX.

```bash
make VERBOSE=1
```

Use verbose mode when:

- diagnosing a compilation failure;
- investigating package behaviour;
- checking the full sequence of LaTeX runs;
- debugging `minted`;
- examining warnings that are difficult to locate in the captured log.

Verbose mode also saves the output into each document's `build.log`.

---

## `make one LAB=LabXX VERBOSE=1`

Build one lab and display the complete LaTeX output.

```bash
make one LAB=Lab03 VERBOSE=1
```

This is normally the most useful diagnostic command because it limits the output to the practical currently being investigated.

---

## `make clean`

Remove all temporary build files while preserving the published PDFs.

```bash
make clean
```

This deletes:

```text
build/
```

It does not delete:

```text
pdf/
```

Use this when:

- build artefacts appear stale;
- `latexmk` behaves unexpectedly;
- cached `minted` output needs to be regenerated;
- you want to verify a genuinely clean compilation.

After cleaning, rebuild with:

```bash
make
```

or:

```bash
make one LAB=Lab03
```

---

## `make distclean`

Remove both temporary build files and generated PDFs.

```bash
make distclean
```

This deletes:

```text
build/
pdf/
```

Use this when a completely clean publishing state is required.

Both directories will be recreated automatically during the next build.

---

## `make help`

Display a summary of the supported commands.

```bash
make help
```

---

## `NO_COLOR=1 make`

Disable coloured terminal output.

```bash
NO_COLOR=1 make
```

This can be useful when:

- redirecting output to a text file;
- running the build in an environment without colour support;
- capturing logs in a continuous integration system.

The option can be combined with other targets:

```bash
NO_COLOR=1 make one LAB=Lab03
```

---

# Build Failures

When a quiet build fails, the pipeline:

1. marks the document as `FAILED`;
2. prints the final 30 lines of the captured build output;
3. reports the location of the complete build log;
4. stops the build;
5. does not copy a failed or incomplete PDF into the final `pdf/` directory.

Example:

```text
Building Lab03        practical03... FAILED

Last 30 lines of the build log:

...

Full log:
.../build/Lab03/practical03/build.log
```

To investigate further, run:

```bash
make one LAB=Lab03 VERBOSE=1
```

After correcting the source, run the normal quiet build again:

```bash
make one LAB=Lab03
```

---

# Adding a New Practical

To add a new practical:

1. Create the appropriate lab folder:

   ```bash
   mkdir -p src/labs/Lab11
   ```

2. Add the `.tex` source file:

   ```text
   src/labs/Lab11/practical11.tex
   ```

3. Add any figures under a suitable asset folder:

   ```text
   assets/figures/practical11/
   ```

4. Confirm that the source is recognised:

   ```bash
   make list
   ```

5. Build the new practical:

   ```bash
   make one LAB=Lab11
   ```

6. Review the generated PDF:

   ```text
   pdf/Lab11/practical11.pdf
   ```

7. Build the full collection:

   ```bash
   make
   ```

---

# File-Naming Guidance

For predictable output, use simple file names without spaces.

Recommended:

```text
practical01.tex
practical02.tex
practical03.tex
```

Avoid:

```text
Practical 03 Final Version.tex
practical03-new-new-final.tex
```

The output PDF uses the same base name as the source file.

For example:

```text
src/labs/Lab03/practical03.tex
```

produces:

```text
pdf/Lab03/practical03.pdf
```

---

# Notes on VS Code

The Makefile controls builds started from the terminal, but the LaTeX Workshop extension in VS Code may use its own build recipe when a `.tex` file is saved.

If LaTeX Workshop is configured to build automatically, it may place `.aux`, `.log`, `.toc`, and related files directly beside the source file.

The recommended long-term configuration is either:

- disable LaTeX Workshop's automatic build-on-save behaviour and run `make` manually; or
- configure LaTeX Workshop to invoke the root Makefile as its default recipe.

Until that configuration is changed, the terminal workflow remains the authoritative publishing method:

```bash
make list
make one LAB=Lab03
make
```

---

# Quick Reference

```bash
# Show the source files that will be compiled
make list

# Build one practical
make one LAB=Lab03

# Build all practicals
make

# Build one practical with complete LaTeX output
make one LAB=Lab03 VERBOSE=1

# Build everything with complete LaTeX output
make VERBOSE=1

# Remove temporary build files
make clean

# Remove temporary files and generated PDFs
make distclean

# Show command help
make help
```

---

# Suggested Day-to-Day Workflow

For normal editing:

```bash
make list
make one LAB=Lab03
```

Review the generated PDF, make corrections, and rebuild the individual lab as needed.

Before publishing or distributing the complete set:

```bash
make clean
make list
make
```

Then review the final PDFs under:

```text
pdf/
```

This provides a clean, repeatable build while keeping the source folders free from LaTeX build artefacts.
