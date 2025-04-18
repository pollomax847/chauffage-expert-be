// features/gestion_donnees/di/donnees_module.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repositories/donnees_repository_impl.dart';
import '../domain/repositories/donnees_repository.dart';

class DonneesModule {
  static void init() {
    final getIt = GetIt.instance;

    // Repository
    getIt.registerLazySingleton<DonneesRepository>(
      () => DonneesRepositoryImpl(getIt<SharedPreferences>()),
    );
  }
} 