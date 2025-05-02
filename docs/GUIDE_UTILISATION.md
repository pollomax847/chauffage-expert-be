<!-- TODO: Vérifier la redondance avec user-guide.md et envisager une fusion ou une clarification des objectifs de chaque document. -->
<!-- Ce fichier est désigné comme le guide principal. user-guide.md et utilisation.md devraient être fusionnés ici et supprimés. -->
# Guide d'Utilisation - Chauffage Expert BE

## Introduction

Bienvenue dans l'application Chauffage Expert BE. Ce guide vous aidera à utiliser efficacement l'application pour vos calculs de chauffage, ECS et VMC.

## Installation

<!-- Instructions unifiées basées sur README et autres docs -->
1.  **Cloner le dépôt** (pour les développeurs) :
    ```bash
    git clone https://github.com/votre-username/chauffage_expert.git
    cd chauffage_expert
    ```
2.  **Installer les dépendances** (pour les développeurs) :
    ```bash
    flutter pub get
    ```
3.  **Lancer l'application** (pour les développeurs) :
    ```bash
    flutter run
    ```
4.  **(Pour les utilisateurs finaux)** : Téléchargez l'application depuis le store approprié (Play Store/App Store) et lancez-la.

## Premiers Pas

### Interface Principale
L'interface se compose de :
- Barre de navigation supérieure (actions rapides)
- Menu latéral (accès aux sections principales)
- Zone de travail principale
- Barre d'outils contextuelle

### Navigation
- Utilisez le menu latéral pour naviguer entre les modules (Clients, Études, Paramètres, etc.).
- Les onglets peuvent être utilisés dans certaines sections pour basculer entre les vues.

## Gestion des Clients

### Création d'un Client
1. Depuis l'écran principal ou le menu latéral, accédez à la section "Clients".
2. Cliquez sur le bouton "+" (souvent en bas à droite).
3. Remplissez les informations requises (Nom, Adresse, Contact, etc.).
4. Validez pour enregistrer le nouveau client.

### Modification d'un Client
1. Sélectionnez un client dans la liste.
2. Cliquez sur l'option "Modifier" ou une icône similaire.
3. Modifiez les informations souhaitées.
4. Validez pour sauvegarder les changements.

## Études Thermiques (Chauffage, ECS, VMC)

### Création d'une Étude
1. Sélectionnez un client pour lequel réaliser l'étude.
2. Dans la fiche client, cliquez sur "Nouvelle étude".
3. Choisissez le type d'étude (Chauffage, ECS, VMC).
4. Remplissez les informations générales de l'étude (Nom, Description, Date, etc.).
5. Validez pour créer l'étude.

### Réalisation des Calculs
1. Ouvrez l'étude créée.
2. Saisissez les paramètres requis pour le type d'étude (ex: détails des pièces, appareils, besoins).
3. Les calculs sont généralement effectués automatiquement à mesure que vous saisissez les données.
4. Vérifiez les résultats affichés en temps réel.

## Export des Rapports

### Génération du Rapport
1. Depuis une étude terminée, cliquez sur "Générer Rapport".
2. Vérifiez les informations à inclure et les options de mise en page.
3. Cliquez sur "Exporter" ou "Aperçu".

### Formats Disponibles
- PDF (principal)
- Potentiellement Excel (vérifier implémentation)
- Partage direct (Email, etc.)

## Préférences

Accédez aux "Préférences" ou "Paramètres" depuis le menu principal ou la barre d'outils.

### Unités de mesure
- Température (°C/°F)
- Puissance (kW/HP/W)
- Débit (m³/h/L/s/CFM)
- Pression (bar/Pa/psi)
- *Assurez-vous que toutes les unités configurables sont listées.*

### Marges de calcul (Coefficients de sécurité)
- Chauffage : (ex: 1.2 par défaut)
- ECS : (ex: 1.3 par défaut)
- VMC : (ex: 1.1 par défaut)
- *Vérifiez les valeurs par défaut et la possibilité de les modifier.*

### Apparence
- Thème (clair/sombre/système)
- Taille de police
- Langue

## Dépannage

### Problèmes Courants
- **Calculs incorrects** : Vérifiez toutes les données saisies, les unités et les marges configurées.
- **Données manquantes** : Assurez-vous que tous les champs obligatoires sont remplis.
- **Erreurs d'export** : Vérifiez les permissions de stockage et l'espace disponible. Essayez un format différent si possible.
- **Application lente ou bloquée** : Redémarrez l'application. Si le problème persiste, vérifiez les mises à jour ou contactez le support.

### Solutions
1. Vérifiez attentivement les données saisies.
2. Assurez-vous que l'application est à jour.
3. Redémarrez l'application.
4. Consultez les logs (si accessibles).
5. Contactez le support technique.

## Support Technique

<!-- Informations de support unifiées -->
Pour toute assistance supplémentaire :
- **Documentation en ligne** : [Lien vers la documentation si elle est hébergée]
- **Email** : support@chauffage-expert.com (ou .fr selon la cible)
- **Téléphone** : 01 23 45 67 89 (si applicable)
- **Forum/GitHub Issues** : [Lien si applicable]
- **Horaires** : 9h-18h du lundi au vendredi (si applicable)