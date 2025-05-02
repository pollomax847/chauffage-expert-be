#!/bin/bash

# Kill any existing Chrome processes
pkill -f chrome

# Clean and rebuild
flutter clean
flutter pub get
flutter build web --release

# Run Flutter web with Chrome flags and debug mode
flutter run -d chrome --dart-define=FLUTTER_WEB_USE_SKIA=true --web-browser-flag="--enable-unsafe-swiftshader" --verbose 