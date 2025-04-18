// features/gestion_donnees/data/repositories/donnees_repository_impl.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/donnees_repository.dart';

class DonneesRepositoryImpl implements DonneesRepository {
  final SharedPreferences prefs;

  DonneesRepositoryImpl({required this.prefs});

  @override
  Future<Map<String, dynamic>> getDonnees() async {
    final keys = prefs.getKeys();
    final result = <String, dynamic>{};
    for (final key in keys) {
      result[key] = prefs.get(key);
    }
    return result;
  }

  @override
  Future<bool> ajouterDonnee(String cle, dynamic valeur) async {
    if (valeur is String) {
      return prefs.setString(cle, valeur);
    } else if (valeur is int) {
      return prefs.setInt(cle, valeur);
    } else if (valeur is double) {
      return prefs.setDouble(cle, valeur);
    } else if (valeur is bool) {
      return prefs.setBool(cle, valeur);
    }
    return false;
  }

  @override
  Future<bool> modifierDonnee(String cle, dynamic valeur) async {
    return ajouterDonnee(cle, valeur);
  }

  @override
  Future<bool> supprimerDonnee(String cle) async {
    return prefs.remove(cle);
  }

  // Gestion du logo
  @override
  Future<String?> getLogoPath() async {
    return prefs.getString('logo_path');
  }

  @override
  Future<bool> setLogoPath(String path) async {
    return prefs.setString('logo_path', path);
  }

  @override
  Future<bool> removeLogo() async {
    return prefs.remove('logo_path');
  }
}
