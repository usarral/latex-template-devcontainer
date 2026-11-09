FROM docker.io/library/alpine:3.24

# Espejo CTAN desde el que se instala TeX Live. Si va lento o está caído:
#   --build-arg TLMIRROR=https://<espejo>/systems/texlive/tlnet
# Lista de espejos: https://ctan.org/mirrors
ARG TLMIRROR=https://ftp.fau.de/ctan/systems/texlive/tlnet
ARG TLDIR=/usr/local/texlive
ARG TLPLATFORM=x86_64-linuxmusl

ENV PATH="${TLDIR}/bin/${TLPLATFORM}:${PATH}" \
    LANG=C.UTF-8

# perl            -> latexmk y latexindent son scripts perl
# perl-yaml-tiny y
# siguientes      -> módulos que latexindent necesita para arrancar
# wget            -> lo usa tlmgr para instalar paquetes nuevos en caliente
RUN apk add --no-cache \
      bash git make openssh-client ca-certificates less wget tar xz gnupg \
      perl perl-yaml-tiny perl-file-homedir perl-log-log4perl perl-unicode-linebreak

COPY tex-packages.txt /tmp/tex-packages.txt

# Instalación en dos pasos: el instalador oficial con scheme-infraonly deja solo
# tlmgr (~80 MB) y después se añaden únicamente los paquetes de tex-packages.txt.
# Sin documentación ni fuentes, que son la mayor parte del peso de TeX Live.
RUN set -eux; \
    mkdir -p /tmp/itl; cd /tmp/itl; \
    wget -qO- "${TLMIRROR}/install-tl-unx.tar.gz" | tar xz --strip-components=1; \
    printf '%s\n' \
      'selected_scheme scheme-infraonly' \
      "TEXDIR ${TLDIR}" \
      "TEXMFLOCAL ${TLDIR}/texmf-local" \
      "TEXMFSYSVAR ${TLDIR}/texmf-var" \
      "TEXMFSYSCONFIG ${TLDIR}/texmf-config" \
      'TEXMFHOME ~/texmf' \
      'tlpdbopt_install_docfiles 0' \
      'tlpdbopt_install_srcfiles 0' \
      'tlpdbopt_autobackup 0' \
      > tl.profile; \
    ./install-tl -profile tl.profile -repository "${TLMIRROR}"; \
    tlmgr option repository "${TLMIRROR}"; \
    sed -e 's/#.*//' -e '/^[[:space:]]*$/d' /tmp/tex-packages.txt | xargs tlmgr install; \
    cd /; rm -rf /tmp/itl /tmp/tex-packages.txt

WORKDIR /workspace
