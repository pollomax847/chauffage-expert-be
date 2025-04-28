
# Mémoire Technique : Dimensionnement Solaire Thermique

## 🎯 Objectif

Ce module permet de dimensionner un système solaire thermique pour :
- La production d’eau chaude sanitaire (ECS)
- L’appoint pour le chauffage

Systèmes concernés :
- CESI : Chauffe-eau solaire individuel
- SSC : Système solaire combiné (ECS + chauffage)

---

## 📋 Données à relever sur le terrain

| Élément | Utilité |
|--------|---------|
| Nombre d’habitants | Base de calcul ECS |
| Nombre de points d’eau (douches, éviers…) | Débit estimé |
| Volume habitable (SSC) | Puissance de chauffe nécessaire |
| Température intérieure et extérieure | Calcul ΔT chauffage |
| Température souhaitée ECS | Calcul ΔT ballon |
| Volume ballon existant | Vérification si remplacement |
| Présence d’appoint (chaudière, PAC) | Sécurité et relais |
| Localisation (géolocalisation ou code postal) | Irradiation estimée |
| Surface de toiture disponible | Nombre de capteurs |
| Orientation toiture (Sud/Est/Ouest) | Rendement attendu |
| Inclinaison des capteurs | Optimisation selon saison |
| Présence d’ombres | Correction de rendement |

---

## 🧮 Calculs recommandés

- **Volume ballon recommandé (ECS)** : `50 L / personne`
- **Surface capteur recommandée (ECS)** : `1 à 1.5 m² / personne`
- **Surface capteur recommandée (SSC)** : `1.5 à 3 m²` selon zone et usage
- **ΔT ballon** : `T consigne – T eau froide (~50°C – 10°C)`
- **Énergie solaire utile (kWh/an)** : `irradiation x surface x rendement`
- **% Couverture solaire** : `énergie solaire utile / besoin annuel total`

---

## 🧾 Export PDF

Le rapport PDF inclura :
- Relevé complet des données saisies
- Résultat calculé : volume ballon, surface capteurs, % couverture
- Schéma de principe suggéré (ballon + capteurs + appoint)
- Photos toiture et local ballon
- Remarques technicien (option annotation)

---

## 📍 À intégrer dans l’app Flutter

- Module : `solaire_thermique.dart`
- Accès via : Relevé > Modules > Solaire
- Sauvegarde dans l’historique PDF client
- PDF spécifique ou inclus dans RT Équipement

---

## 🧠 Suggestions futures

- Intégration base météo automatique (irradiation)
- Simulation économique (kWh économisés / an)
- Module aide au choix du type de régulation (V3V, sonde ballon, etc.)

