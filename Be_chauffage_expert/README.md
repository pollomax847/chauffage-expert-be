# Chauffage Expert

Application de calcul et de gestion pour les installations de chauffage.

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

3. Générer les fichiers de code :
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Lancer l'application :
```bash
flutter run
```

## Structure du projet

```
lib/
  ├── models/           # Modèles de données
  ├── providers/        # Providers Riverpod
  ├── screens/          # Écrans de l'application
  ├── services/         # Services (base de données, PDF, etc.)
  ├── theme/            # Thème de l'application
  ├── utils/            # Utilitaires
  ├── widgets/          # Widgets réutilisables
  ├── app_routes.dart   # Routes de l'application
  └── main.dart         # Point d'entrée de l'application
```

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