# Compila dentro del devcontainer (o en cualquier sitio con latexmk y biber).
DOC ?= index

.PHONY: pdf watch clean help

pdf: ## Compila el PDF en out/
	latexmk -pdf $(DOC).tex

watch: ## Recompila al guardar
	latexmk -pdf -pvc $(DOC).tex

clean: ## Borra los auxiliares y el PDF
	latexmk -C $(DOC).tex

help: ## Muestra esta ayuda
	@grep -hE '^[a-z]+:.*##' $(MAKEFILE_LIST) | sed 's/:.*##/\t/'
