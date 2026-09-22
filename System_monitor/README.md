# 🖥️ sysmonitor

Surveille en continu l'utilisation CPU, RAM et disque, avec un intervalle et un seuil disque configurables.

## Utilisation

```bash
./sysmonitor.sh [-i|--interval N] [-d|--disk-threshold N] [-h|--help]
```

Valeurs par défaut : intervalle de 2 secondes, seuil disque de 90 %.

### Exemple

```bash
./sysmonitor.sh --interval 5 --disk-threshold 80
```
Écrit dans `result.txt`, une ligne par relevé :
```
[14:32:05] CPU: 23.1% RAM: 61% Disque(/): 47%
```
Arrêt propre avec `Ctrl+C` (message de confirmation avant de quitter).

## Fonctionnement interne

- Les options longues (`--interval`) et courtes (`-i`) sont supportées via `getopt` (util-linux), avec `eval set -- "$PARSED"` pour reconstituer proprement les arguments après analyse.
- Le CPU ne peut pas se lire en un seul relevé instantané fiable : le script utilise `top -bn1` et en extrait le taux d'inactivité par motif (plutôt que par position de colonne), pour rester robuste face aux décalages de mise en forme de `top` sur certaines valeurs.

## Prérequis

`getopt` version util-linux — support des options longues, vérifiable avec `getopt -T` (doit renvoyer `4`) — ainsi que `top`, `free`, `df`.

## Limites connues / à compléter

- Les seuils (`--disk-threshold`) sont acceptés en argument, mais la comparaison et l'affichage d'une alerte ne sont pas encore branchés dans la boucle principale.
- Pas de seuil CPU/RAM pour l'instant, uniquement disque.
