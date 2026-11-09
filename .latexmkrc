# Configuración compartida por la CLI, VS Code y la CI, para que los tres
# compilen exactamente igual. El directorio de salida lo pasa quien invoca
# (-outdir), porque se compila desde la carpeta de cada documento.
$pdf_mode = 1;                 # pdflatex
$bibtex_use = 2;               # usa biber y limpia los .bbl al hacer clean
$biber = 'biber %O --output_safechars %B';
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# Borra también lo que deja biblatex al hacer `latexmk -C`.
$clean_ext = 'bbl run.xml synctex.gz';
