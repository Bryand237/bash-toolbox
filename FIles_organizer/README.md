# 🧹 file-organizer

Range automatiquement les fichiers d'un dossier fourre-tout (typiquement `~/Téléchargements`) dans des sous-dossiers par catégorie, d'après leur extension.

## Utilisation

```bash
./organize.sh <dossier> [--dry-run]
```

- `--dry-run` : simule le rangement sans rien déplacer, pour prévisualiser le résultat.

### Exemple

```bash
./organize.sh ~/Téléchargements --dry-run   # prévisualisation
./organize.sh ~/Téléchargements             # application réelle
```

Avant :
```
Téléchargements/rapport.pdf
Téléchargements/photo.jpg
Téléchargements/archive.zip
```
Après :
```
Téléchargements/Documents/rapport.pdf
Téléchargements/Images/photo.jpg
Téléchargements/Archives/archive.zip
```

## Catégories par défaut

| Extensions | Dossier |
|---|---|
| jpg, jpeg, png, webp | Images |
| pdf, docx | Documents |
| zip, tar, gz, rar | Archives |
| (tout le reste) | Autres |

Les extensions sont reconnues indépendamment de la casse (`.JPG` et `.jpg` sont traités pareil). Modifiable directement dans le tableau associatif `extensions` en tête de script.

## Prérequis

Bash 4+ (tableaux associatifs).

## Limites connues

Les fichiers cachés (commençant par un point) ne sont pas exclus explicitement : un fichier comme `.bashrc` sera classé dans "Autres" plutôt qu'ignoré.
