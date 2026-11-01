#!/usr/bin/env bash

# Autor: PFPE20
#
# Script para buscar comando en index.yaml

# Agradecimientos: 
# https://github.com/mikefarah/yq/releases
# https://github.com/mikefarah/yq/releases/download/v4.54.1/yq_darwin_amd64

# Comprobación de paquetes

if [[ -t 1 && -z "${NO_COLOR:-}" && "${TERM:-dumb}" != "dumb" ]]; then
    BOLD=$'\e[1m'
    RED_BOLD=$'\e[1;31m'
    YELLOW_BOLD=$'\e[1;33m'
    ITALIC=$'\e[3m'
    RESET=$'\e[0m'
else
    BOLD="" RED_BOLD="" YELLOW_BOLD="" ITALIC="" RESET=""
fi

# ../column

if ! command -v column &>/dev/null; then
    echo -e "No tienes el paquete ${BOLD}column${RESET} instalado por favor instala: ${ITALIC}bsdextrautils${RESET}: sudo apt install bsdextrautils"
    exit 1
fi

# ../yq

if ! command -v yq &>/dev/null; then
  echo -e "\n No tienes el paquete ${BOLD}yq${RESET} instalado por favor ve a ${ITALIC}https://github.com/mikefarah/yq/releases${RESET} y descarga el binario correspondiente a tu arquitectura" 
  exit 1
fi

if ! yq --version | grep -iq "mikefarah"; then
    echo -e "\n El ${BOLD}yq${RESET} instalado no es el de ${ITALIC}mikefarah${RESET}. Descarga el binario correcto desde ${ITALIC}https://github.com/mikefarah/yq/releases${RESET}"
    exit 1
fi

# Path & Global variables
THIS_PATH=$( dirname $( realpath "$0" ) )
IDX_FILE="$THIS_PATH/index.yaml"

LIST_TOOLS=$(yq '.[].tool' $IDX_FILE | sort -u) # Package index
declare -i TTY_SIZE=$(stty size | cut -d ' ' -f1) # Filas de la terminal para usar "less" o no

# Busca si el paquete existe en el IDX y lo muestra
function search_pkg() {
  local PKG="${1,,}"
  [[ -z "$PKG" ]] && { usage; exit 1; }

  local out; out=$(PKG="$PKG" yq -r '.[] | select(.tool == env(PKG))' "$IDX_FILE")
  [[ -z "$out" ]] && { echo -e "\n ${YELLOW_BOLD}[!]${RESET} paquete/servicio/protocolo no encontrado"; exit 1; }

  pkg_desc=$(PKG="$PKG" yq -r '.[] | select(.tool == env(PKG)) | "\(.description)"' "$IDX_FILE")
  pkg_comm=$(PKG="$PKG" yq -r '.[] | select(.tool == env(PKG)) | "\(.command)"' "$IDX_FILE")
  local out_full

  out_full=$(echo -e "\n ${ITALIC}$pkg_desc${RESET}\n"; echo "$pkg_comm" | \
    sed 's/$/\n#/' | \
    column --separator "#" \
            --table \
            --output-width $(tput cols) \
            --table-noheadings \
            --table-columns ATTR,DESCR \
            --table-wrap DESCR )

  if (( $(echo "$out_full" | wc -l) > "$TTY_SIZE" )); then
    echo "$out_full" | less -R; exit
  fi

  echo "$out_full"
  exit
}

# Busca coincidencias de una palabra clave en todo el documento
function search_cmd() {
  local KEYWORD="${1,,}"

  [[ -z "$KEYWORD" ]] && { echo -e "\n\t${RED_BOLD}[!]${RESET} Palabra clave no encontrada"; exit 1; }

  FIND_KW=$(KW="$KEYWORD" yq -r \
    '.[] | select(.tool == env(KW) 
      or (.description | test(env(KW))) 
      or (.command | test(env(KW)))) | 
      "\tHerramienta: \(.tool)\tCategoría: \(.category)"' \
    "$IDX_FILE" 2>/dev/null)

  if ! echo "$FIND_KW" | grep -qi "$KEYWORD" 2>/dev/null ; then
    echo -e "\n\t${RED_BOLD}[!]${RESET} Palabra clave no encontrada"
    exit 1
  fi

  if (( $(echo "$FIND_KW" | wc -l) > "$TTY_SIZE" )); then
    echo "$FIND_KW" | less -R; exit
  fi

  echo "$FIND_KW"
  exit
}

# Busca paquetes/servicios por CATEGORÍA
declare -a CATS
mapfile -t CATS < <(yq -r '.[].category' "$IDX_FILE" | sort -u)
function find_by_label() {
  local KEYWORD="$1"
  [[ -z "$KEYWORD" ]] && { echo -e "\n\t${RED_BOLD}[!]${RESET} Palabra clave no encontrada\n"; exit 1; }

  FIND_CAT=$(KW="$KEYWORD" yq -r '.[] | select(.category == env(KW)) | "Herramienta: \(.tool)\t\tCategoría: \(.category)"' "$IDX_FILE" | sort -u)

  if ! echo "$FIND_CAT" | grep -qi "$KEYWORD"; then
    echo -e "\n\t${RED_BOLD}[!]${RESET} Categoría no encontrada\n"
    exit 1
  fi

  if (( $(echo "$FIND_CAT" | wc -l) > "$TTY_SIZE" )); then
    echo "$FIND_CAT" | sort | less -R; exit
  fi

  echo "$FIND_CAT"
  exit
}


function usage() {
  echo -e "\n Uso:\n ${BOLD}./find_command.sh <ARG> [KEYWORD]${RESET}\n"
  echo -e "
 ${BOLD}-h${RESET} # Muestra esta ayuda
 ${BOLD}-l${RESET} # Lista todos los paquetes y servicios
 ${BOLD}-c ${ITALIC}<command>${RESET} # Encuentra las apariciones en el documento
 ${BOLD}-k ${ITALIC}<command>${RESET} # Busca paquetes/programas por su título
 ${BOLD}-a ${ITALIC}<label>${RESET} # Busca paquetes/programas por categorías
" | column -t -s "#" -o $'\t\t'

  echo -ne "\n\tCategorías disponibles:\t"
  for tag in "${CATS[@]}"; do
    echo -ne "${BOLD}$tag${RESET} "
  done
	exit
}

if [[ -z "$1" ]]; then
	usage; exit 1
fi

while getopts ":k:c:a:lh" opt; do
	case $opt in
		k)
    		    search_pkg "$OPTARG";;
    		c)
    		    search_cmd "$OPTARG";;
    		a)
    		    find_by_label "$OPTARG";;
    		l)
    		    echo "$LIST_TOOLS" | less -R; exit;;
    	        h)
    		    usage; exit;;
    		:)
    		    usage; exit 1;;
    		?) 
    		    usage; exit 1;;
	esac
done



