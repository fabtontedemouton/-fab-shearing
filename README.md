# FAB SHEARING — The Real Life | Pack 1.1

## Ce pack corrige la structure GitHub
Le projet est maintenant complet côté fichiers de base : `project.godot`, `scenes/`, `scripts/`, `data/`, `docs/`, `android/`, `export_presets.cfg` et `.github/workflows/android.yml` sont tous à la racine du dépôt.

## Contenu
- Prototype Godot 4.3 jouable : bergerie 3D simple, personnage, troupeau et tonte progressive simplifiée.
- Base de score pédagogique et données de cinq races.
- Documentation de direction artistique et de progression technique.
- Workflow GitHub Actions pour exporter un APK Android debug.

## Installation GitHub — important
1. Téléverse **le contenu** de ce ZIP dans la racine du dépôt `fab-shearing` (pas le dossier parent `FAB_SHEARING_1_1`).
2. Vérifie que le chemin affiché est exactement `.github/workflows/android.yml`.
3. Le dépôt doit utiliser la branche `main` ou `master`.
4. Ouvre l'onglet **Actions** : le workflow `FAB SHEARING - Android APK` doit apparaître. Le push sur `main`/`master` le déclenche automatiquement. Tu peux aussi le lancer avec **Run workflow**.
5. Quand l'exécution est verte, ouvre-la, puis télécharge l'artefact `FAB-SHEARING-Android-APK` dans la section Artifacts.

## Ouvrir dans Godot
Ouvre le fichier `project.godot` avec Godot 4.3. La scène principale est `scenes/main.tscn`.

## Limites honnêtes
Ceci est une base jouable de développement, pas un jeu 3D commercial terminé. Les modèles et animations sont provisoires. La tonte et le score sont simplifiés. La méthode Bowen et les critères de concours doivent être validés par des références pédagogiques fiables et un formateur qualifié avant d'en faire un outil d'entraînement technique.
