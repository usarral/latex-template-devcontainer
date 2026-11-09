# Plantilla LaTeX con devcontainer

Documento base en español (portada, índice, encabezados, listados de código y
bibliografía con biblatex) junto a un contenedor de desarrollo que trae todo lo
necesario para compilarlo. No hace falta instalar nada de LaTeX en el equipo.

## Uso

### Con VS Code

1. Abrir la carpeta y aceptar *Reopen in Container*.
2. Compilar con LaTeX Workshop (se abre el PDF en una pestaña) o con `make pdf`.

### Sin VS Code

```sh
podman build -t latex-template .devcontainer          # o docker build
podman run --rm -v "$PWD:/workspace:z" -w /workspace latex-template make pdf
```

El PDF sale en `out/`.

### Objetivos de make

| Comando      | Qué hace                           |
| ------------ | ---------------------------------- |
| `make pdf`   | Compila `index.tex` en `out/`      |
| `make watch` | Recompila al guardar               |
| `make clean` | Borra auxiliares y PDF             |

Para un documento con otro nombre: `make pdf DOC=memoria`.

## Añadir paquetes de LaTeX

Los paquetes se declaran en [`.devcontainer/tex-packages.txt`](.devcontainer/tex-packages.txt),
uno por línea, y se instalan al construir la imagen. Tras editarlo hay que
reconstruir el contenedor (*Dev Containers: Rebuild Container*).

`tlmgr` resuelve las dependencias, así que basta con el paquete que se usa. Para
saber qué paquete trae un fichero que falta:

```sh
tlmgr search --global --file nombre-que-falta.sty
```

Para probar algo sin reconstruir, `tlmgr install <paquete>` dentro del
contenedor funciona, pero se pierde al recrearlo: lo que se quiera conservar va
al fichero.

## Cómo está montado el contenedor

- **Alpine + TeX Live oficial** instalado con `scheme-infraonly` (solo `tlmgr`) y
  después únicamente los paquetes declarados, sin documentación ni fuentes. La
  imagen queda en ~270 MB en vez de los ~700 MB de una instalación al uso.
- **`tlmgr` sigue disponible** dentro del contenedor, con la firma del
  repositorio verificada por GnuPG.
- El espejo de CTAN se puede cambiar si va lento:
  `--build-arg TLMIRROR=https://<espejo>/systems/texlive/tlnet`
  ([lista de espejos](https://ctan.org/mirrors)).
- La compilación la define [`.latexmkrc`](.latexmkrc), que usan por igual la
  CLI, VS Code y la CI, para que los tres produzcan el mismo PDF.

## CI

[`.github/workflows/build.yml`](.github/workflows/build.yml) construye la misma
imagen del devcontainer, compila el documento y sube el PDF como artefacto, de
modo que la CI no puede desviarse del entorno local.

## Créditos

Configuración de devcontainer inspirada en la de
[@qdm12](https://github.com/qdm12/latexdevcontainer) y plantilla original de
@mariol03.
