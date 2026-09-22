# 🏗️ project-setup

Dispatcher qui crée en une commande la structure de base d'un nouveau projet (dossiers, fichiers, code de démarrage) selon le langage choisi, puis dépose l'utilisateur directement dedans.

## Langages supportés

| Langage | Alias acceptés | Structure générée |
|---|---|---|
| C | `c` | `bin/`, `src/`, `include/`, `Makefile`, `.gitignore` |
| C++ | `cpp`, `c++`, `cxx` | `bin/`, `src/`, `include/`, `Makefile` (C++17), `.gitignore` |
| Python | `python` | `src/<nom>/`, `tests/`, `requirements.txt`, `.gitignore` |

## Installation

```bash
git clone <url-du-depot> ~/dev-tools/project-setup
echo 'source ~/dev-tools/project-setup/bashrc-functions.sh' >> ~/.bashrc
source ~/.bashrc
```

## Utilisation

```bash
newproject C calculatrice        # crée le projet et déplace le shell dedans
newproject c++ moteur_jeu        # alias c++ / cxx reconnus
newproject python api_client
```

## Pourquoi deux couches (`setup.sh` et `newproject`) ?

`setup.sh` fait tout le travail de création et se termine par `exit` en cas d'erreur — le sourcer directement fermerait la session shell au moindre problème. Il reste donc un script exécuté normalement, qui affiche le chemin créé sur sa dernière ligne de sortie standard. `newproject` est une fonction légère, sourcée dans `.bashrc`, dont le seul rôle est de récupérer ce chemin et de faire le `cd` — la seule opération qui a réellement besoin de s'exécuter dans le shell courant.

## Ajouter un langage

Créer `langs/<nom>.sh` définissant une fonction `create_project(dir, name)` qui construit la structure voulue. Aucune autre modification n'est nécessaire : `setup.sh` détecte automatiquement le nouveau module.

## Structure du dépôt

```
project-setup/
├── setup.sh
├── bashrc-functions.sh
└── langs/
    ├── c.sh
    ├── cpp.sh
    └── python.sh
```

## Prérequis

Bash 4+ (tableaux). `gcc`/`g++` pour compiler les projets C/C++ générés.
