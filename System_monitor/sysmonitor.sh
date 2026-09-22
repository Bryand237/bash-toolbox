#!/bin/bash
set -euo pipefail

# Fonction d'usage
usage() {
    echo "Usage : $(basename $0) [-i|--interval N] [-d|--disk-threshold N] [-h|--help] " >&2
    exit 1
}

# Recuperation des arguments et extraction des valeurs
interval=2
disk_threshold=90

if ! PARSED=$(getopt --options=i:d:h --longoptions=interval:,disk-threshold:,help --name "$(basename "$0")" -- "$@"); then
    usage
fi
eval set -- "$PARSED"

while true; do
    case "$1" in
        -i|--interval) interval="$2"; shift 2 ;;
        -d|--disk-threshold) disk_threshold="$2"; shift 2 ;;
        -h|--help) usage ;;
        --) shift; break ;;
        *) echo "Erreur interne" >&2; exit 1 ;;
    esac
done

# Fonction de lecture metriques

# Disque
disk_usage() {
    df -P / | awk 'NR==2 {gsub("%","",$5); print $5}'
}

# RAM
ram_usage() {
    free | awk '/^Mem:/ {printf "%.0f", $3/$2*100}'
}

# CPU
cpu_usage() {
    local idle
    idle=$(top -bn1 | grep -oE '[0-9]+\.[0-9]+ id' | grep -oE '^[0-9]+\.[0-9]+')
    awk -v idle="$idle" 'BEGIN { printf "%.1f", 100 - idle }'
}

# CRTL+C avec arret controle
trap 'echo; echo "Arret du moniteur."; exit 0' INT

# Boucle infinie
while true; do
    cpu="$(cpu_usage)"
    ram="$(ram_usage)"
    disk="$(disk_usage)"

    #echo "["$(date +%H:%M:%S)"] CPU: $cpu% RAM: $ram% Disque(/): $disk% "$("$disk"=="$disk_threshold"?"ALERT Disque":"")""
    echo "["$(date +%H:%M:%S)"] CPU: $cpu% RAM: $ram% Disque(/): $disk%" >&2
    [ "$disk" -eq "$disk_threshold" ] && echo  $'\u26A0 ALERTE Disque'

    sleep "$interval"
done