# Chauffage Expert BE

Application professionnelle pour les techniciens chauffagistes et bureaux d'études.

## Fonctionnalités

- Calcul de puissance de chaudière
- Dimensionnement des radiateurs
- Équilibrage des radiateurs
- Calcul de débit d'eau chaude sanitaire
- Calcul de pression de vase d'expansion
- Gestion des clients
- Gestion des équipements
- Gestion des interventions
- Export PDF des rapports
- Gestion des photos avec annotations
- Interface responsive
- Thème clair/sombre

## Prérequis

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Android SDK / Xcode (pour le développement mobile)

## Installation

1. Cloner le dépôt :
   ```bash
   git clone https://github.com/votre-username/chauffage_expert.git
   cd chauffage_expert
   ```

2. Installer les dépendances :
   ```bash
   flutter pub get
   ```

3. Générer les fichiers de code (si nécessaire) :
   <!-- TODO: Clarifier quand cette étape est nécessaire (ex: après modification des modèles annotés). -->
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Lancer l'application :
   ```bash
   flutter run
   ```

## Structure du projet

```
.
├── assets/           # Ressources statiques (images, fonts, etc.)
├── core/             # Code core de l'application
├── docs/             # Documentation
│   ├── installation.md
│   ├── tutorial.md
│   ├── GUIDE_UTILISATION.md # Guide utilisateur principal
│   └── technical-docs.md
├── features/         # Fonctionnalités de l'application
├── lib/              # Code source principal
├── logs/             # Fichiers de logs
├── scripts/          # Scripts utilitaires
│   ├── monitor.sh
│   ├── load_test.sh
│   ├── build_web.sh  # (Exemple, si existant)
│   ├── deploy.sh     # (Exemple, si existant)
│   └── rotate_logs.sh # (Exemple, si existant)
├── tests/            # Tests et fichiers de test
└── web/              # Configuration web
```

## Documentation

La documentation complète est disponible dans le dossier `docs/` :
- Guide d'installation : `docs/installation.md`
- Tutoriel : `docs/tutorial.md`
- Guide utilisateur : `docs/user-guide.md`
- Documentation technique : `docs/technical-docs.md`

## Déploiement

Le déploiement est géré par deux scripts principaux :
- `scripts/build_web.sh` : Construction de l'application web
- `scripts/deploy.sh` : Déploiement sur Vercel

## Gestion des logs

Les logs sont automatiquement gérés par le script `scripts/rotate_logs.sh` qui :
- Compresse les logs lorsqu'ils dépassent 10MB
- Conserve les 5 dernières versions compressées
- Supprime automatiquement les anciennes versions

## Contribution

1. Fork le projet
2. Créer une branche pour votre fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## Contact

Votre Nom - [@votre_twitter](https://twitter.com/votre_twitter) - email@example.com

Lien du projet : [https://github.com/votre-username/chauffage_expert](https://github.com/votre-username/chauffage_expert)