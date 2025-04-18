# Guide d'Installation et Configuration

## Prérequis

- Flutter SDK (version 3.0.0 ou supérieure)
- Dart SDK (version 2.17.0 ou supérieure)
- Android Studio / Visual Studio Code
- Git

## Installation

1. Cloner le dépôt :
```bash
git clone https://github.com/pollomax847/chauffage-expert-be.git
cd chauffage-expert-be
```

2. Installer les dépendances :
```bash
flutter pub get
```

3. Configurer les variables d'environnement :
```bash
cp .env.example .env
# Éditer le fichier .env avec vos configurations
```

## Configuration Initiale

### 1. Configuration de l'Application

1. Lancer l'application :
```bash
flutter run
```

2. Accéder aux préférences :
   - Cliquer sur l'icône des paramètres dans la barre d'outils
   - Configurer les marges de calcul
   - Définir les unités de mesure
   - Personnaliser l'apparence

### 2. Configuration des Marges

- **Chauffage** : 1.2 (recommandé)
- **ECS** : 1.3 (recommandé)
- **VMC** : 1.1 (recommandé)

### 3. Configuration des Unités

- **Température** : °C (par défaut)
- **Puissance** : kW (par défaut)
- **Débit** : m³/h (par défaut)

## Mise à Jour

1. Mettre à jour le code :
```bash
git pull origin main
```

2. Mettre à jour les dépendances :
```bash
flutter pub upgrade
```

3. Reconstruire l'application :
```bash
flutter clean
flutter pub get
```

## Dépannage

### Problèmes Courants

1. **Erreur de dépendances**
   - Solution : Exécuter `flutter pub get`
   - Vérifier la version de Flutter

2. **Problèmes de compilation**
   - Solution : Exécuter `flutter clean`
   - Reconstruire l'application

3. **Erreurs de configuration**
   - Vérifier le fichier .env
   - Redémarrer l'application

### Support

Pour toute assistance :
- Consulter la documentation
- Ouvrir une issue sur GitHub
- Contacter le support technique

## Sécurité

### Bonnes Pratiques

1. **Mise à jour régulière**
   - Maintenir Flutter à jour
   - Mettre à jour les dépendances
   - Appliquer les correctifs de sécurité

2. **Configuration sécurisée**
   - Utiliser des mots de passe forts
   - Limiter les accès
   - Sauvegarder régulièrement

3. **Protection des données**
   - Chiffrement des données sensibles
   - Sauvegarde automatique
   - Journalisation des actions 