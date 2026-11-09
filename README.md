# Plantilla LaTeX con devcontainer

Repositorio para escribir **varios documentos** LaTeX en español compartiendo
estilo, con un contenedor que trae todo lo necesario para compilarlos. No hace
falta instalar nada de LaTeX en el equipo.

```sh
./doc nuevo       # pregunta plantilla, título y autor, y genera el documento
./doc compila     # compila todos los documentos a out/
```

## Empezar un repositorio de documentos

Este repo es una *template repository* de GitHub, así que hay dos caminos:

```sh
./doc repo apuntes-2027 --private    # crea el repo en GitHub y lo clona
```

o el botón **Use this template** en GitHub. En ambos casos se abre en VS Code,
se acepta *Reopen in Container* y ya se puede escribir.

## Estructura

```
comun/plantilla.sty     Preámbulo compartido por todos los documentos
plantillas/<tipo>/      Plantillas a partir de las que se crean documentos
documentos/<nombre>/    Un documento: <nombre>.tex, referencias.bib, imagenes/
out/                    PDFs y auxiliares (no se versiona)
doc                     La CLI
```

Cada documento se compila desde su propia carpeta, así que dentro del `.tex`
las rutas son relativas a él: `\includegraphics{imagenes/foto.png}`.

## La CLI

| Comando | Qué hace |
| ------- | -------- |
| `./doc nuevo` | Crea un documento. Sin argumentos pregunta; también acepta `--plantilla`, `--nombre`, `--titulo` y `--autor` |
| `./doc compila [nombre...]` | Compila los indicados, o todos |
| `./doc limpia [nombre...]` | Borra auxiliares y PDF |
| `./doc lista` | Documentos y plantillas disponibles |
| `./doc repo <nombre>` | Crea un repositorio nuevo en GitHub desde esta plantilla |

`make pdf`, `make clean`, `make lista` y `make nuevo` son atajos equivalentes.

## Escribir un documento

El preámbulo está en `comun/plantilla.sty`, así que un documento empieza así:

```latex
\documentclass[a4paper,12pt]{article}
\usepackage[bibliografia]{plantilla}

\titulo{Memoria del proyecto}
\autor{Nombre Apellido}

\begin{document}
\portada
\indice

\section{Introducción}
...
\printbibliography
\end{document}
```

Lo que aporta `plantilla.sty`:

| | |
| --- | --- |
| `\titulo{}` `\autor{}` `\fecha{}` `\subtitulo{}` | Datos del documento; alimentan portada y encabezados |
| `\imagenportada{imagenes/x.png}` | Imagen opcional en la portada |
| `\portada` | Portada con la línea naranja |
| `\indice` | Índice, y numeración romana antes del cuerpo |
| `\begin{nota}` `\begin{aviso}` | Cajas destacadas (admiten título: `\begin{nota}[Definición]`) |
| opción `bibliografia` | Carga biblatex con el `referencias.bib` del documento |

Los documentos sin citas se declaran con `\usepackage{plantilla}` a secas, y así
no se arrastra biber.

## Crear tus propias plantillas

Una plantilla es una carpeta en `plantillas/`:

```
plantillas/memoria-tfg/
├── plantilla.conf     DESCRIPCION="..."
├── documento.tex      admite {{TITULO}}, {{AUTOR}}, {{NOMBRE}}, {{FECHA}}
└── referencias.bib    opcional, se copia tal cual
```

En cuanto existe la carpeta, `./doc nuevo` la ofrece en el menú. Cualquier otro
fichero de la carpeta se copia al documento nuevo sin tocar.

## Añadir paquetes de LaTeX

Se declaran en [`.devcontainer/tex-packages.txt`](.devcontainer/tex-packages.txt),
uno por línea, y se instalan al construir la imagen. Después hay que reconstruir
el contenedor (*Dev Containers: Rebuild Container*).

`tlmgr` resuelve las dependencias, así que basta con el paquete que se usa. Para
saber cuál trae un fichero que falta:

```sh
tlmgr search --global --file nombre-que-falta.sty
```

`tlmgr install <paquete>` dentro del contenedor sirve para probar, pero se
pierde al recrearlo: lo que se quiera conservar va al fichero.

## Cómo está montado el contenedor

- **Alpine + TeX Live oficial** instalado con `scheme-infraonly` (solo `tlmgr`) y
  después únicamente los paquetes declarados, sin documentación ni fuentes. La
  imagen queda en ~270 MB en vez de los ~700 MB de una instalación al uso.
- **`tlmgr` sigue disponible**, con la firma del repositorio verificada por GnuPG.
- Se instala desde el espejo CTAN de la **Universidad de Zaragoza**. Para cambiarlo:
  `--build-arg TLMIRROR=https://<espejo>/systems/texlive/tlnet`
  ([lista de espejos](https://ctan.org/mirrors)).
- `TEXINPUTS` incluye `comun/`, por eso `plantilla.sty` se encuentra desde
  cualquier documento.
- La compilación la define [`.latexmkrc`](.latexmkrc), que usan por igual la
  CLI, VS Code y la CI.

## CI

[`.github/workflows/build.yml`](.github/workflows/build.yml) construye la misma
imagen del devcontainer, compila **todos** los documentos y los sube como
artefacto, de modo que la CI no puede desviarse del entorno local.

## Créditos

Configuración de devcontainer inspirada en la de
[@qdm12](https://github.com/qdm12/latexdevcontainer) y plantilla original de
@mariol03.
