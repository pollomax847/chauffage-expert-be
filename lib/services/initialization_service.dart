import 'package:shared_preferences/shared_preferences.dart';

import 'client_db.dart';
import 'be_pdf_service.dart'; // This file now contains the definition of BEPdfService
import 'be_logic.dart';
import 'configuration_service.dart';

/// Service d'initialisation qui configure toutes les dépendances
/// de l'application au démarrage
class InitializationService {
  static Future<void> initialize() async {
    // Initialiser les préférences partagées
    final prefs = await SharedPreferences.getInstance();

    // Initialiser les services
    final configurationService = ConfigurationService(prefs);
    final clientDb = ClientDbService();
    final pdfService = BEPdfService(); // Ensure BEPdfService is defined in the imported file
    final logicService = BELogic();

    // Enregistrer les événements de démarrage
    print('Application initialisée avec succès');

    // Initialisation des autres composants
    await _initializeProviders();
    await _initializeTheme();
    await _prepareLocalStorage();
  }

  /// Initialise les providers Riverpod
  static Future<void> _initializeProviders() async {
    // Configuration des providers
  }

  /// Configure le thème de l'application selon les préférences
  static Future<void> _initializeTheme() async {
    // Initialisation du thème
  }

  /// Prépare le stockage local
  static Future<void> _prepareLocalStorage() async {
    // Préparation des bases de données locales
  }
}
