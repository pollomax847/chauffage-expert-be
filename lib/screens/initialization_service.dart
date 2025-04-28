import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import '../services/client_db.dart';
import '../services/be_pdf_service.dart';
import '../services/be_logic.dart';
import '../services/configuration_service.dart';
import '../services/be_security_service.dart';

/// Service d'initialisation qui configure toutes les dépendances
/// de l'application au démarrage
class InitializationService {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> initialize() async {
    try {
      // Initialiser les préférences partagées
      final prefs = await SharedPreferences.getInstance();
      
      // Enregistrer les services dans GetIt pour l'injection de dépendances
      if (!_getIt.isRegistered<SharedPreferences>()) {
        _getIt.registerSingleton<SharedPreferences>(prefs);
      }
      
      if (!_getIt.isRegistered<ConfigurationService>()) {
        _getIt.registerSingleton<ConfigurationService>(ConfigurationService(prefs));
      }
      
      if (!_getIt.isRegistered<ClientDbService>()) {
        _getIt.registerSingleton<ClientDbService>(ClientDbService());
      }
      
      if (!_getIt.isRegistered<BEPdfService>()) {
        _getIt.registerSingleton<BEPdfService>(BEPdfService());
      }
      
      if (!_getIt.isRegistered<BELogic>()) {
        _getIt.registerSingleton<BELogic>(BELogic());
      }

      // Enregistrer les événements de démarrage
      await BESecurityService.logSecurityEvent(
          'initialisation', 'Application initialisée avec succès');
      print('Application initialisée avec succès');

      // Initialisation des autres composants
      await _initializeProviders();
      await _initializeTheme();
      await _prepareLocalStorage();
    } catch (e) {
      print('Erreur lors de l\'initialisation: $e');
    }
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
