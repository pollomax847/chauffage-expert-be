// di/app_module.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/gestion_donnees/di/donnees_module.dart';

class AppModule {
  static Future<void> init() async {
    final getIt = GetIt.instance;

    // Services de base
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);

    // Modules
    DonneesModule.init();
  }
} 