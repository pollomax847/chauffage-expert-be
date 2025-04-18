# Chauffage Expert BE

Application professionnelle pour les techniciens chauffagistes et bureaux d'études.

## Fonctionnalités

- Dimensionnement des installations
- Bureau d'études techniques
- Réglementation gaz
- Exportation PDF
- Gestion des données techniques

## Prérequis

- Flutter SDK (version >= 3.3.0)
- Dart SDK (version >= 3.0.0)
- Android Studio / VS Code
- Un émulateur ou un appareil physique

## Installation

1. Clonez le dépôt :
```bash
git clone https://github.com/pollomax847/chauffage-expert-be.git
```

2. Installez les dépendances :
```bash
flutter pub get
```

3. Lancez l'application :
```bash
flutter run
```

## Structure du projet

```
lib/
├── di/                    # Injection de dépendances
├── features/              # Fonctionnalités de l'application
│   └── gestion_donnees/   # Module de gestion des données
├── pages/                 # Pages de l'application
├── services/              # Services de l'application
├── theme/                 # Thème de l'application
└── widgets/               # Widgets réutilisables
```

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
1. Fork le projet
2. Créer une branche pour votre fonctionnalité
3. Commiter vos changements
4. Pousser vers la branche
5. Ouvrir une Pull Request

## Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

# Application Chauffage Expert

## Architecture du Projet

### Structure des Dossiers

```
lib/
├── client.dart               # Modèle client avec historiques
├── services/                 # Services métier et utilitaires
├── screens/                  # Écrans de l'application
├── widgets/                  # Composants réutilisables
└── models/                   # Modèles de données
```

### Services Principaux

- `be_logic.dart` : Logique métier pour les calculs techniques
- `client_db.dart` : Gestion de la base de données clients
- `be_pdf_service.dart` : Génération des rapports PDF
- `be_pdf_preview.dart` : Aperçu des PDF avant export

### Modules Techniques

- Calculs ECS
- Dimensionnement des vases d'expansion
- Calculs de radiateurs
- Plancher chauffant
- Mesures de sondes ohmiques

### Gestion Entreprise

- Module patron
- Contrôle qualité
- Gestion des techniciens

## Documentation des Modules

Pour plus de détails sur chaque module, consultez les fichiers Markdown correspondants dans le dossier `docs/`.

# Déploiement sur Vercel

Ce guide explique comment déployer l'application Flutter Web sur Vercel.

## Prérequis

- Flutter SDK installé
- Compte Vercel
- Vercel CLI installé (`npm install -g vercel`)

## Configuration

1. Assurez-vous que tous les fichiers de configuration sont présents :
   - `vercel.json`
   - `build.sh`

2. Rendez le script de build exécutable :
   ```bash
   chmod +x build.sh
   ```

## Déploiement

### Méthode 1 : Via l'interface Vercel

1. Construisez l'application :
   ```bash
   ./build.sh
   ```

2. Connectez-vous à [Vercel](https://vercel.com)
3. Créez un nouveau projet
4. Importez votre dépôt Git
5. Sélectionnez le framework "Other"
6. Configurez les paramètres de build :
   - Build Command: `./build.sh`
   - Output Directory: `build/web`

### Méthode 2 : Via Vercel CLI

1. Installez Vercel CLI :
   ```bash
   npm install -g vercel
   ```

2. Construisez l'application :
   ```bash
   ./build.sh
   ```

3. Déployez :
   ```bash
   vercel
   ```
   Pour un déploiement en production :
   ```bash
   vercel --prod
   ```

## Configuration avancée

### Variables d'environnement

Si votre application nécessite des variables d'environnement, configurez-les dans les paramètres du projet Vercel.

### Domaine personnalisé

1. Allez dans les paramètres du projet sur Vercel
2. Ajoutez votre domaine personnalisé
3. Suivez les instructions pour configurer les DNS

## Dépannage

### Problèmes courants

1. **Erreur de build** :
   - Vérifiez que toutes les dépendances sont compatibles web
   - Assurez-vous que Flutter est à jour

2. **Problèmes de routage** :
   - Vérifiez la configuration dans `vercel.json`
   - Assurez-vous que toutes les routes sont correctement configurées

3. **Problèmes de performance** :
   - Optimisez les assets
   - Utilisez le lazy loading
   - Minimisez les dépendances

## Support

Pour toute question ou problème, consultez :
- [Documentation Flutter Web](https://flutter.dev/web)
- [Documentation Vercel](https://vercel.com/docs) 