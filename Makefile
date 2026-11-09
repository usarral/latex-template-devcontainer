# Atajos sobre ./doc, que es donde está la lógica.
DOC ?=

.PHONY: pdf clean lista nuevo help

pdf: ## Compila todos los documentos (o uno: make pdf DOC=informe)
	@./doc compila $(DOC)

clean: ## Borra auxiliares y PDF
	@./doc limpia $(DOC)

lista: ## Lista documentos y plantillas
	@./doc lista

nuevo: ## Crea un documento (interactivo)
	@./doc nuevo

help: ## Muestra esta ayuda
	@grep -hE '^[a-z]+:.*##' $(MAKEFILE_LIST) | sed 's/:.*##/\t/'
