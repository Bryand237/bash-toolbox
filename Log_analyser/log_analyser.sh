#!/bin/bash
set -euo pipefail

# Fonction d'usage
usage() {
    echo "Usage : $(basename "$0") <fichier_de_log>" >&2
    exit 1
}

# Vérification du nombre de paramètres
[ $# -eq 1 ] || usage
file="$1"
filename="$(basename "$file")"


# Vérifier que le fichier existe et est lisible
if [ ! -e "$file" ]; then
    echo "Le fichier "$file" n'existe pas." >&2
    usage
    exit 1
fi

# Fonction compter_echecs()
compter_echecs() {
    echo "$(grep -c -i "failed password" "${file}")"
}

# Fonction top_ip()
top_ip() {
    grep -i "failed password" "${file}" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort | uniq -c | sort -rn  | head -3 > tmp.txt
    i=1
    while read -r count ip; do
        echo "${i}) "$ip" ("$count" tentatives)" >&2
        i=$((i + 1))
    done < tmp.txt
    rm -f tmp.txt
}

# Affichage du rapport formaté
affichage_rapport() {
    nbr_echec="$(compter_echecs)"
    echo "=== Rapport pour "$filename" ===" >&2
    echo "Tentatives échouées : "$nbr_echec"" >&2
    echo "Top 3 IP en échec : " >&2
    top_ip
}

affichage_rapport
