$pdf_mode = 4;

$out_dir = 'build';

$clean_ext .= ' %R.run.xml';
$clean_ext .= ' %R.bcf';
$clean_ext .= ' %R.blg';
$clean_ext .= ' %R.synctex.gz';

$pdflatex = 'lualatex -shell-escape %O %S';
