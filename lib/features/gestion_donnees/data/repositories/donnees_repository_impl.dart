// features/gestion_donnees/data/repositories/donnees_repository_impl.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/donnees_repository.dart';

class DonneesRepositoryImpl implements DonneesRepository {
  final SharedPreferences _prefs;
  static const String _keyDonnees = 'donnees';
  static const String _keyHistorique = 'historique';

  DonneesRepositoryImpl(this._prefs);

  @override
  Future<void> sauvegarderDonnees(Map<String, dynamic> donnees) async {
    await _prefs.setString(_keyDonnees, donnees.toString());
    await _ajouterAHistorique(donnees);
  }

  @override
  Future<Map<String, dynamic>> chargerDonnees() async {
    final donneesString = _prefs.getString(_keyDonnees);
    if (donneesString == null) return {};
    return Map<String, dynamic>.from(donneesString as Map);
  }

  @override
  Future<void> supprimerDonnees(String id) async {
    final historique = await obtenirHistorique();
    historique.removeWhere((element) => element['id'] == id);
    await _prefs.setString(_keyHistorique, historique.toString());
  }

  @override
  Future<List<Map<String, dynamic>>> obtenirHistorique() async {
    final historiqueString = _prefs.getString(_keyHistorique);
    if (historiqueString == null) return [];
    return List<Map<String, dynamic>>.from(historiqueString as List);
  }

  Future<void> _ajouterAHistorique(Map<String, dynamic> donnees) async {
    final historique = await obtenirHistorique();
    historique.add(donnees);
    await _prefs.setString(_keyHistorique, historique.toString());
  }
}
