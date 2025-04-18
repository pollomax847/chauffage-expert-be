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
flutter build web --release --base-href / 