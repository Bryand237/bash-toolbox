# 📁 directory-bookmarks

Système de marque-pages en ligne de commande pour naviguer instantanément entre les répertoires utilisés souvent, sans retaper de chemins à rallonge.

## Pourquoi un script à sourcer, pas un exécutable classique ?

Un script lancé normalement (`./script.sh`) tourne dans un sous-processus : un `cd` à l'intérieur ne change jamais le répertoire du terminal appelant. Ces fonctions doivent donc être **sourcées** dans la session shell courante pour pouvoir réellement déplacer l'utilisateur.

## Installation

```bash
git clone <url-du-depot>
echo 'source /chemin/vers/bash_navigation.sh' >> ~/.bashrc
source ~/.bashrc
```

## Utilisation

| Commande | Effet |
|---|---|
| `mark nom` | Sauvegarde le répertoire courant sous `nom` |
| `goto nom` | Saute directement dans le répertoire sauvegardé |
| `marks` | Liste tous les marque-pages enregistrés |
| `unmark nom` | Supprime un marque-page |

### Exemple

```bash
cd ~/projets/mon-app
mark app
cd /var/log
goto app        # revient directement dans ~/projets/mon-app
```

## Stockage

Les marque-pages sont enregistrés dans `~/.bash_bookmarks` (texte brut, une ligne par entrée au format `nom=chemin`).

## Prérequis

Bash (testé en 5.x). Aucune dépendance externe.
