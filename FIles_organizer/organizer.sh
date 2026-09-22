#!/bin/bash
set -euo pipefail

# Fonction d'usage
usage() {
    echo "Usage: "$(basename $0)" <chemin_du_dossier> [--dry-run]"
    exit 1
}

# Vérification et récupération des arguments
simulation=false
position=()
for arg in "$@"; do
    case "$arg" in
        --dry-run)
            simulation=true
            ;;
        -*)
            echo "Option inconnue : $arg" >&2
            usage
            ;;
        *)
            position+=("$arg")
            ;;
    esac
done

[ "${#position[@]}" -eq 1 ] || usage
folder="${position[0]}"

# Récupération des fichiers dans le tableau files[]
mapfile -d '' -t files < <(
    find "$folder" -maxdepth 1 -type f -print0
)

# Déclaration des extention et des dossiers correspondants
declare -A extensions=(
    # Images
    [jpg]="Images" [jpeg]="Images" [png]="Images" [webp]="Images" 
    # Documents
    [pdf]="Documents" [docx]="Documents" [txt]="Documents"
    # Archives
    [zip]="Archives" [rar]="Archives" [tar]="Archives" [gz]="Archives"
)

# Repartition par fichier
for f in "${files[@]}"; do
    # Récupérer le nom du fichier
    filename="$(basename "$f")"

    # Récupérer les extensions
    ext="${filename##*.}"
    ext="${ext,,}"

    # Définir la destination
    dest="${extensions[$ext]:-Autres}"

    # Gestion de la simulation ou de l'application des modifications
    if $simulation; then
        echo "$folder/$dest/$filename" >&2
    else
        mkdir -p "$folder/$dest"
        mv -t "$folder/$dest" "$f"
    fi
done

