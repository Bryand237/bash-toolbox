#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LANGS_DIR="$SCRIPT_DIR/langs"

usage() {
    echo "Usage: $(basename "$0") <langage> <nom_projet>" >&2
    echo "Langages disponibles :" >&2
    for f in "$LANGS_DIR"/*.sh; do
        echo " - $(basename "$f" .sh)" >&2
    done
    exit 1
}

[ $# -eq 2 ] || usage
lang_input="$1"
project_name="$2"

# Normalisation : majuscule -> minuscules, alias => nom canonique
lang="$(echo "$lang_input" | tr '[:upper:]' '[:lower:]')"
case "$lang" in 
    c++|cxx) lang="cpp" ;;
esac

module="$LANGS_DIR/$lang.sh"
if [ ! -f "$module" ]; then
    echo "Erreur : langage '$lang_input' non supporté." >&2
    usage
fi

project_dir="$(pwd)/$project_name"
if [ -e "$project_dir" ]; then
    echo "Erreur : '$project_dir' existe déjà." >&2
    exit 1
fi

mkdir -p "$project_dir"

# Charge le module du langage : il doit definir create_project()
source "$module"
if ! declare -f create_project > /dev/null; then
    echo "Erreur interne : le module '$lang' ne définit pas create_project()." >&2
    exit 1
fi

create_project "$project_dir" "$project_name"

echo "$project_dir"