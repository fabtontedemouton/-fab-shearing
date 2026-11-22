# FAB SHEARING — Cadre de production réaliste

## Direction validée
- Android prioritaire.
- Caméra hybride : troisième personne pour se déplacer, vue rapprochée/première personne au poste.
- Difficulté HARD.
- Direction artistique réaliste.
- Monde de carrière : France d'abord, puis Nouvelle-Zélande, Australie et Royaume-Uni.
- Classement international sur 52 semaines, inspiré du tennis.

## Ce que contient cette base
Une architecture séparée (joueur, mouton, interface, scène principale), un hangar de greybox, contrôles clavier et premières commandes tactiles, mode de travail et interface de score provisoire.

**Ce n'est pas un jeu réaliste terminé.** Les meshes du mouton et du personnage sont des placeholders géométriques. Les panneaux de laine ne représentent pas une toison anatomique ni la méthode Bowen. Le score ne prétend pas noter une vraie tonte.

## Pipeline d'assets requis pour le réalisme
1. Référence photographique sous plusieurs angles pour chaque race.
2. Modélisation du corps, tête, membres, sabots et morphologie propre à la race.
3. Sculpt de la toison en volume, densité et longueur adaptées à la race et à l'état de laine.
4. Retopologie, UV, textures PBR et niveaux de détail mobiles.
5. Rig du mouton et animations de posture/réaction, conçus avec une validation professionnelle.
6. Modèle de tondeuse, peigne, main, câble et animation de prise en main.
7. Système de coupe : volume/masque de tonte piloté par la trajectoire réelle de l'outil, gestion des bandes, chevauchements, laine oubliée, secondes coupes et défauts.
8. Optimisation Android : LOD, occlusion, textures compressées, budget de triangles et tests sur appareils réels.

## Système de score final — à spécifier et valider
- Couverture complète et régularité.
- Secondes coupes.
- Marques et blessures (pénalités distinctes, jamais réduites à un simple compteur).
- Laine oubliée.
- Temps et fluidité du travail.
- Respect de la séquence technique choisie.
Les coefficients et pénalités ne seront pas inventés : ils devront être validés avec le règlement de compétition retenu et des tondeurs expérimentés.

## Carrière et classement
- Points par compétition, avec catégorie et niveau.
- Classement glissant sur 52 semaines.
- Résultats historisés, points qui expirent à la fin de leur fenêtre.
- Classements séparés par discipline/catégorie si les règles le demandent.
- Prévoir anti-doublons et vérification des résultats avant validation.

## Contrôles qualité avant APK
- Import et lancement headless Godot.
- Vérification des scripts et scènes.
- Export Android.
- Vérification APK avec apksigner.
- Vérification package avec aapt.
- Installation et test sur téléphone réel.
- Rapport d'erreurs joint à chaque build.
