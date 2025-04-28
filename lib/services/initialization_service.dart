import 'package:shared_preferences/shared_preferences.dart';

class InitializationService {
  static Future<void> initialize() async {
    // Initialiser les préférences partagées
    final prefs = await SharedPreferences.getInstance();

    // Initialiser les services
    // Exemple: BEChauffageService.init();
    // Exemple: BEPDFService.init();

    // Initialisation des fournisseurs d'état
    await _initializeProviders();
  }

  static Future<void> _initializeProviders() async {
    // Initialisation des providers Riverpod
  }
}
