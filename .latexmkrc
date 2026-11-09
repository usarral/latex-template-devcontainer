# Configuración compartida por la CLI, VS Code y la CI, para que los tres
# compilen exactamente igual.
$pdf_mode = 1;                 # pdflatex
$out_dir  = 'out';
$bibtex_use = 2;               # usa biber y limpia los .bbl al hacer clean
$biber = 'biber %O --output_safechars %B';
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# Borra también lo que deja biblatex al hacer `latexmk -C`.
$clean_ext = 'bbl run.xml synctex.gz';
