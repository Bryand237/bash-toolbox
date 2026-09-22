#!/bin/bash
set -euo pipefail

# Fonction d'usage
usage() {
    echo "Usage: $(basename "$0") <repertory to archive> <destination folder> <amount to save>" >&2
    exit 1
}

# Récupération et validation des arguments ou affichage de l'usage
[ $# -eq 3 ] || usage
source="$1"
destination="$2"
amount="$3"

# Vérification de l'existance de la source
if [ ! -e "$source" ]
then
    echo "Error : The repertory to archive '$source' doen't exist." >&2
    usage
fi

# Vérification de l'existance de la destination
if [ ! -e "$destination" ]
then
    mkdir -p "$destination"
fi

prefix="$(basename "$source")"

# Définition du nom de l'archive
archive_name="${prefix}_$(date +%Y-%m-%d_%H%M%S).tar.gz"

# Création de l'archive
tar czf "$destination/$archive_name" -C "$(dirname "$source")" "$(basename "$source")" >&2

# Vérification et suppression du surplus d'archives dans le dossier de destination
mapfile -d '' -t archives < <(
    find "$destination" -maxdepth 1 -type f -name "${prefix}_*.tar.gz" -print0 | sort -zr
)
count="${#archives[@]}"

if [ "$count" -gt "$amount" ]; then
    surplus=$((count - amount))
    for ((i = count - surplus; i < count; i++)); do
        rm "${archives[$i]}"
    done
fi


