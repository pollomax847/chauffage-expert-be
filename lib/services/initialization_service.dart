// services/initialization_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'client_db.dart';
import 'be_pdf_service.dart';
import 'be_logic.dart';
import 'configuration_service.dart';
import 'be_security_service.dart';
import 'interfaces/i_pdf_service.dart';

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
      // Vérifier les dépendances
      if (!_checkDependencies()) {
        throw Exception('Dépendances manquantes');
      }

      // Initialiser les préférences partagées
      final prefs = await SharedPreferences.getInstance();

      // Enregistrer les services dans GetIt
      if (!_getIt.isRegistered<SharedPreferences>()) {
        _getIt.registerSingleton<SharedPreferences>(prefs);
      }

      // Configuration service doit être initialisé en premier
      if (!_getIt.isRegistered<ConfigurationService>()) {
        final configService = ConfigurationService(prefs);
        _getIt.registerSingleton<ConfigurationService>(configService);
      }

      // Initialiser la base de données client
      if (!_getIt.isRegistered<ClientDbService>()) {
        final clientDb = ClientDbService();
        _getIt.registerSingleton<ClientDbService>(clientDb);
      }

      // Initialiser le service PDF
      if (!_getIt.isRegistered<IPdfService>()) {
        final pdfService = BEPdfService(prefs);
        await pdfService.initialize();
        _getIt.registerSingleton<IPdfService>(pdfService);
      }

      // Initialiser le service de logique métier
      if (!_getIt.isRegistered<BELogic>()) {
        final logicService = BELogic();
        _getIt.registerSingleton<BELogic>(logicService);
      }

      // Enregistrer les événements de démarrage
      await BESecurityService.logSecurityEvent(
        'initialisation',
        'Application initialisée avec succès',
      );

      // Initialisation des autres composants
      await _initializeProviders();
      await _initializeTheme();
      await _prepareLocalStorage();
    } catch (e, stackTrace) {
      print('Erreur lors de l\'initialisation: $e\n$stackTrace');
      rethrow;
    }
  }

  /// Initialise les providers Riverpod
  static Future<void> _initializeProviders() async {
    // TODO: Initialiser les providers
  }

  /// Configure le thème de l'application selon les préférences
  static Future<void> _initializeTheme() async {
    // TODO: Initialiser le thème
  }

  /// Prépare le stockage local
  static Future<void> _prepareLocalStorage() async {
    // TODO: Préparer le stockage local
  }
}
