# 🗄️ backup-rotate

Sauvegarde un dossier dans une archive compressée horodatée, et ne conserve que les N sauvegardes les plus récentes — pensé pour tourner via une tâche cron sans surveillance.

## Utilisation

```bash
./backup.sh <dossier_source> <dossier_destination> <nombre_a_garder>
```

### Exemple

```bash
./backup.sh ~/documents ~/backups 5
```
Crée `~/backups/documents_2026-09-02_143000.tar.gz`. Dès que plus de 5 archives portant ce préfixe existent dans `~/backups`, les plus anciennes sont supprimées automatiquement.

## Automatiser avec cron

```bash
crontab -e
# Sauvegarde quotidienne à 2h du matin, garde les 7 dernières
0 2 * * * /chemin/vers/backup.sh ~/documents ~/backups 7
```

## Fonctionnement interne

Le nom de l'archive suit le format `<nom_dossier>_<date>_<heure>.tar.gz` : le tri lexicographique du nom correspond ainsi exactement à l'ordre chronologique, ce qui simplifie le repérage des archives les plus anciennes lors de la rotation.

## Prérequis

`tar`, `find`, bash 4+ (tableaux). Mode strict actif (`set -euo pipefail`).

## Limites connues

- Un seul dossier source par appel.
- Pas de chiffrement de l'archive.

## Pistes d'amélioration

- Exclusion de sous-dossiers (`tar --exclude`)
- Chiffrement de l'archive (`gpg`)
- Notification par mail en cas d'échec
