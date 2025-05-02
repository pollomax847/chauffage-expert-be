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

<!-- TODO: Vérifier et documenter le mécanisme de stockage réel (Hive, Sqflite, ou SharedPreferences ?) basé sur l'implémentation et pubspec.yaml. -->
<!-- Mise à jour basée sur pubspec.yaml : Utilise probablement Hive ou Sqflite pour les données structurées, SharedPreferences peut être utilisé pour des paramètres simples. -->
Gestion de la base de données locale (probablement Hive ou Sqflite) :
- Stockage des données clients (détails, projets associés)
- Historique des interventions/calculs
- Sauvegarde des études/projets
- Potentiellement synchronisation des données (si implémentée)

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