# Guide de Contribution

## Environnement de Développement

### Prérequis
- Flutter SDK (dernière version stable)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation
1. Forker le repository
2. Cloner votre fork
3. Installer les dépendances :
```bash
flutter pub get
```

## Standards de Code

### Style
- Suivre les conventions de nommage Dart
- Utiliser 2 espaces pour l'indentation
- Limiter la longueur des lignes à 80 caractères

### Documentation
- Documenter les fonctions publiques
- Ajouter des commentaires pour le code complexe
- Maintenir la documentation à jour

## Processus de Contribution

1. Créer une branche pour votre fonctionnalité
2. Développer et tester localement
3. Soumettre une Pull Request
4. Attendre la revue de code

## Tests

### Tests Unitaires
- Couvrir les services et modèles
- Utiliser des tests descriptifs
- Maintenir un taux de couverture élevé

### Tests d'Interface
- Tester les interactions utilisateur
- Vérifier la réactivité
- Tester sur différentes tailles d'écran

## Déploiement

### Versioning
- Suivre le Semantic Versioning
- Mettre à jour le CHANGELOG
- Taguer les releases

### CI/CD
- Les tests doivent passer
- La documentation doit être à jour
- Le code doit être revu 