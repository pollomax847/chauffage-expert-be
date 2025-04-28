#!/bin/bash

# Ajouter Flutter au PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Activer le support web
flutter config --enable-web

# Nettoyer le projet
flutter clean

# Récupérer les dépendances
flutter pub get

# Construire l'application web
flutter build web --release

# Vérifier que les fichiers nécessaires sont présents
if [ ! -f "build/web/flutter.js" ]; then
    echo "Error: flutter.js not found in build/web directory"
    exit 1
fi

if [ ! -f "build/web/main.dart.js" ]; then
    echo "Error: main.dart.js not found in build/web directory"
    exit 1
fi 