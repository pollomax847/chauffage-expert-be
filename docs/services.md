# Services

## client_service.dart

Gestion des clients :
- CRUD des clients
- Recherche et filtrage
- Sauvegarde locale
- Synchronisation

## etude_service.dart

Gestion des études :
- Création d'études
- Calculs techniques
- Génération de rapports
- Export PDF

## calcul_service.dart

Calculs techniques :
- Dimensionnement des tuyauteries
- Calcul des débits
- Coefficients de simultanéité
- Normes et standards

## pdf_service.dart

Génération de PDF :
- Templates de documents
- Mise en page
- Insertion de données
- Export et partage

## be_logic.dart

Service principal contenant toute la logique métier pour les calculs techniques :
- Calculs ECS (Eau Chaude Sanitaire)
- Calculs de chauffage
- Calculs de ventilation
- Calculs de pertes thermiques

## client_db.dart

Gestion de la base de données clients utilisant SharedPreferences :
- Stockage des données clients
- Historique des interventions
- Sauvegarde des études
- Synchronisation des données

## be_pdf_service.dart

Génération des rapports PDF :
- Création des rapports d'études
- Mise en page des documents
- Intégration des calculs
- Export des graphiques

## be_pdf_preview.dart

Aperçu des PDF avant export :
- Visualisation des rapports
- Vérification de la mise en page
- Contrôle des données
- Options d'export 