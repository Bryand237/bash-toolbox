#!/bin/bash
set -euo pipefail

# Fichier de conservation des taches
TASKS_FILE="taches.txt"
prochain_id=0
description=""

# Fonction d'usage
usage() {
    echo "" >&2
    exit 1
}

[ "$#" -ge 2 ] || usage

# Fonction d'ajout
add() {
    echo "[ ] $prochain_id $description" >> "$TASKS_FILE";
}

# Fonction de lecture
list() {
    # Lire le fichier ligne par ligne, afficher avec printf
    while IFS= read -r ligne ;do
        echo "$ligne" >&2
    done > "$TASKS_FILE" 
}

# Fonction de validation
mark_done() {
    # sed -i pour remplacer "[ ] N" par "[x] N" sur la bonne ligne
}

# Fonction d'elevement
remove() {
    # sed -i "${id}d" "$TASKS_FILE"
}

case "$1" in
    add) shift; add "$@" ;;
    list) list ;;
    done) mark_done "$2" ;;
    rm) remove "$2" ;;
    *) usage ;;
esac
