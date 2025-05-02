# Gestion des Données

Ce document décrit comment les données sont gérées dans l'application Chauffage Expert BE.

## Stockage Local

L'application utilise une base de données locale pour stocker les informations des projets, clients, et calculs.

- **Nom de la base de données** : `chauffage_expert.db` (si Sqflite est utilisé) ou nom des "boxes" Hive.
- **Technologie(s) probable(s)** :
    - **Hive** : Pour le stockage d'objets Dart structurés (rapide, NoSQL-like).
    - **Sqflite** : Pour le stockage relationnel SQL (utilisant `path_provider` pour trouver le chemin).
    - **SharedPreferences** : Pour les préférences utilisateur simples (clé-valeur).
- *Il est crucial de vérifier le code source (ex: `client_db.dart`, services de stockage) pour confirmer la technologie principale utilisée.*

## Structure

(Décrire ici la structure des tables principales, par exemple : Projets, Clients, Calculs, Parametres, etc.)

## Sauvegarde et Restauration

(Décrire ici le mécanisme de sauvegarde et de restauration, s'il existe.)