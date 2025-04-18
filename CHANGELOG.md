# Changelog

## [1.0.0] - 2024-03-21

### Ajouté
- **Service de Configuration**
  - Gestion des marges de calcul
    - Marge chauffage (1.0 - 2.0)
    - Marge ECS (1.0 - 2.0)
    - Marge VMC (1.0 - 2.0)
  - Configuration des unités de mesure
    - Température (°C, °F, K)
    - Puissance (W, kW, BTU/h)
    - Débit (m³/h, L/s, CFM)
  - Paramètres d'apparence
    - Thème (système, clair, sombre)
    - Taille de police (0.8x - 1.2x)
    - Langue (français, anglais)
  - Options de calcul
    - Précision (0-4 décimales)
    - Format des nombres (point, virgule)
    - Arrondi automatique

- **Interface Utilisateur**
  - Page des préférences
    - Accès via le menu principal
    - Organisation en sections thématiques
    - Sauvegarde automatique des modifications
  - Widget de configuration
    - Sliders pour les marges
    - Menus déroulants pour les unités
    - Switch pour les options booléennes
  - Gestion du logo
    - Import depuis la galerie
    - Aperçu en temps réel
    - Suppression possible

- **Intégration**
  - Mise à jour des services existants
    - Utilisation des marges configurées
    - Conversion automatique des unités
    - Application des préférences de formatage
  - Tests unitaires
    - Couverture des nouvelles fonctionnalités
    - Validation des conversions d'unités
    - Tests d'intégration des préférences

### Modifié
- Services de calcul
  - Intégration des marges configurées
  - Support des différentes unités de mesure
  - Formatage des résultats selon les préférences

- Interface utilisateur
  - Amélioration de la cohérence visuelle
  - Adaptation aux préférences de thème
  - Support multilingue

### Corrigé
- Validation des entrées utilisateur
- Gestion des erreurs de conversion d'unités
- Sauvegarde des préférences

### Documentation
- Mise à jour du guide utilisateur
- Ajout des nouvelles fonctionnalités
- Documentation des API de configuration

### Notes de migration
- Les préférences existantes seront migrées automatiquement
- Les calculs existants utiliseront les nouvelles marges par défaut
- Les unités seront converties selon les nouvelles préférences 