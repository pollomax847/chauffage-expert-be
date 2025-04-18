#!/bin/bash

# Vérifier que Flutter est installé
if ! command -v flutter &> /dev/null; then
    echo "Flutter n'est pas installé. Veuillez installer Flutter d'abord."
    exit 1
fi

# Vérifier les variables d'environnement
if [ ! -f .env ]; then
    echo "Le fichier .env n'existe pas. Création à partir de .env.example..."
    cp .env.example .env
    echo "Veuillez configurer les variables d'environnement dans le fichier .env"
    exit 1
fi

# Charger les variables d'environnement
source .env

# Nettoyer le projet
echo "Nettoyage du projet..."
flutter clean

# Récupérer les dépendances
echo "Récupération des dépendances..."
flutter pub get

# Construire pour le web avec les variables d'environnement
echo "Construction pour le web..."
flutter build web --release \
    --dart-define=APP_NAME="$APP_NAME" \
    --dart-define=APP_ENV="$APP_ENV" \
    --dart-define=API_URL="$API_URL" \
    --dart-define=API_KEY="$API_KEY" \
    --dart-define=STORAGE_BUCKET="$STORAGE_BUCKET" \
    --dart-define=STORAGE_REGION="$STORAGE_REGION" \
    --dart-define=PDF_SERVICE_URL="$PDF_SERVICE_URL" \
    --dart-define=CALCUL_SERVICE_URL="$CALCUL_SERVICE_URL"

# Vérifier que le build a réussi
if [ $? -ne 0 ]; then
    echo "La construction a échoué."
    exit 1
fi

echo "Build terminé avec succès !"
echo "Vous pouvez maintenant déployer sur Vercel en utilisant :"
echo "1. vercel"
echo "ou"
echo "2. vercel --prod" 