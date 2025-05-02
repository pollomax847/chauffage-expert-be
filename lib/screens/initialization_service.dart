import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import '../services/client_db.dart';
import '../services/be_pdf_service.dart';
import '../services/be_logic.dart';
import '../services/configuration_service.dart';
import '../services/be_security_service.dart';
import '../services/interfaces/i_pdf_service.dart';

/// Service d'initialisation qui configure toutes les dépendances
/// de l'application au démarrage
class InitializationService {
  static final GetIt _getIt = GetIt.instance;

  /// Vérifie si les dépendances requises sont disponibles
  static bool _checkDependencies() {
    try {
      _getIt<SharedPreferences>();
      _getIt<ConfigurationService>();
      _getIt<IPdfService>();
      _getIt<ClientDbService>();
      _getIt<BELogic>();
      return true;
    } catch (e) {
      print('Dépendances manquantes: $e');
      return false;
    }
  }

  static Future<void> initialize() async {
    try {
      // Initialiser les préférences partagées
      final prefs = await SharedPreferences.getInstance();

      // Enregistrer les services dans GetIt pour l'injection de dépendances
      if (!_getIt.isRegistered<SharedPreferences>()) {
        _getIt.registerSingleton<SharedPreferences>(prefs);
      }

      if (!_getIt.isRegistered<ConfigurationService>()) {
        final configService = ConfigurationService(prefs);
        await configService
            .init(); // S'assurer que la configuration est chargée
        _getIt.registerSingleton<ConfigurationService>(configService);
      }

      if (!_getIt.isRegistered<ClientDbService>()) {
        final clientDb = ClientDbService();
        await clientDb
            .initialize(); // S'assurer que la base de données est prête
        _getIt.registerSingleton<ClientDbService>(clientDb);
      }

      if (!_getIt.isRegistered<IPdfService>()) {
        final configService = _getIt<ConfigurationService>();
        _getIt.registerSingleton<IPdfService>(BEPdfService(configService));
      }

      if (!_getIt.isRegistered<BELogic>()) {
        _getIt.registerSingleton<BELogic>(BELogic());
      }

      // Vérifier que tout est bien initialisé
      if (!_checkDependencies()) {
        throw Exception('Échec de l\'initialisation des dépendances');
      }

      // Enregistrer les événements de démarrage
      await BESecurityService.logSecurityEvent(
        'initialisation',
        'Application initialisée avec succès',
      );
      print('Application initialisée avec succès');

      // Initialisation des autres composants
      await _initializeProviders();
      await _initializeTheme();
      await _prepareLocalStorage();
    } catch (e) {
      print('Erreur critique lors de l\'initialisation: $e');
      await BESecurityService.logSecurityEvent(
        'erreur_initialisation',
        'Échec de l\'initialisation: $e',
      );
      rethrow; // Propager l'erreur pour une gestion appropriée au niveau supérieur
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
