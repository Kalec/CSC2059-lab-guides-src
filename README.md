# CSC2059 LaTeX Practical Template

This starter kit contains:

- `csc2059practical.cls` — reusable LaTeX class for CSC2059 practical guides.
- `example_practical.tex` — example practical showing the title page, table of contents, learning outcomes, workflow reminder, exercises, callouts, code blocks, reflection, wrap-up, and appendices.

## Recommended build

Use XeLaTeX with `minted`. The class now falls back to Latin Modern fonts if the preferred TeX Gyre/Inconsolata fonts are unavailable:

```bash
latexmk -outdir=build -lualatex -shell-escape example_practical.tex
```

`minted` requires Python and Pygments. Install Pygments with:

```bash
python -m pip install pygments
```

## Alternative

If `minted` becomes inconvenient on managed lab machines, replace it with `listings`. The visual output is usually less polished, but the build is simpler because it does not require `-shell-escape`.


## Font troubleshooting

The preferred fonts are:

- TeX Gyre Pagella
- TeX Gyre Heros
- Inconsolata

If these are not installed, version 0.2 of the class automatically falls back to:

- Latin Modern Roman
- Latin Modern Sans
- Latin Modern Mono

So a missing TeX Gyre font should no longer stop the build.
