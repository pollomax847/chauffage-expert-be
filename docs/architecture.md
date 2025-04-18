# Architecture du Projet

## Vue d'ensemble
L'application suit une architecture MVVM (Model-View-ViewModel) avec une séparation claire des responsabilités.

## Structure des Dossiers
```
lib/
├── models/         # Modèles de données
├── services/       # Services métier
├── viewmodels/     # ViewModels
├── views/          # Vues
├── widgets/        # Widgets réutilisables
└── utils/          # Utilitaires
```

## Composants Principaux

### Models
- `Client` : Informations sur les clients
- `Etude` : Données d'une étude thermique
- `Radiateur` : Caractéristiques des radiateurs
- `Calcul` : Résultats des calculs

### Services
- `ClientService` : Gestion des clients
- `EtudeService` : Gestion des études
- `CalculService` : Calculs thermiques
- `StorageService` : Persistance des données

### ViewModels
- `ClientViewModel` : Logique des clients
- `EtudeViewModel` : Logique des études
- `CalculViewModel` : Logique des calculs

### Views
- `ClientView` : Interface clients
- `EtudeView` : Interface études
- `CalculView` : Interface calculs

## Flux de Données
1. L'utilisateur interagit avec la View
2. La View notifie le ViewModel
3. Le ViewModel utilise les Services
4. Les Services manipulent les Models
5. Les Models sont persistés via StorageService

## Sécurité
- Validation des entrées
- Chiffrement des données sensibles
- Gestion des permissions
- Journalisation des actions

## Performance
- Mise en cache des données
- Calculs asynchrones
- Optimisation des requêtes
- Gestion de la mémoire

## Tests
- Tests unitaires (Models, Services)
- Tests de widget (Views)
- Tests d'intégration
- Tests de performance 