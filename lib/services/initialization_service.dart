import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'client_db.dart';
import 'be_pdf_service.dart';
import 'be_logic.dart';
import 'configuration_service.dart';
import 'be_security_service.dart';
import 'interfaces/i_pdf_service.dart';

class InitializationService {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> initialize() async {
    try {
      // Initialiser les préférences partagées
      final prefs = await SharedPreferences.getInstance();

      // Enregistrer les services dans GetIt
      _getIt.registerSingleton<SharedPreferences>(prefs);

      // Configuration service doit être initialisé en premier
      final configService = ConfigurationService(prefs);
      await configService.init();
      _getIt.registerSingleton<ConfigurationService>(configService);

      // Initialiser la base de données client
      final clientDb = ClientDbService();
      await clientDb.initialize();
      _getIt.registerSingleton<ClientDbService>(clientDb);

      // Initialiser le service PDF
      final pdfService = BEPdfService(prefs);
      await pdfService.initialize();
      _getIt.registerSingleton<IPdfService>(pdfService);

      // Initialiser le service de logique métier
      final logicService = BELogic();
      _getIt.registerSingleton<BELogic>(logicService);

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
      await BESecurityService.logSecurityEvent(
        'erreur_initialisation',
        'Erreur lors de l\'initialisation: $e\n$stackTrace',
      );
      rethrow;
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
