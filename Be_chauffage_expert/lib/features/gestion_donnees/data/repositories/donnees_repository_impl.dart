// Be_chauffage_expert/lib/features/gestion_donnees/data/repositories/donnees_repository_impl.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/donnees_repository.dart';

class DonneesRepositoryImpl implements DonneesRepository {
  final SharedPreferences _preferences;
  static const String _donneesKey = 'donnees';
  static const String _historiqueKey = 'historique';

  DonneesRepositoryImpl(this._preferences);

  @override
  Future<Map<String, String>> getDonnees() async {
    final donnees = _preferences.getString(_donneesKey);
    if (donnees == null) return {};
    return Map<String, String>.from(await _decodeDonnees(donnees));
  }

  @override
  Future<bool> ajouterDonnee(String cle, String valeur) async {
    final donnees = await getDonnees();
    donnees[cle] = valeur;
    return _preferences.setString(_donneesKey, _encodeDonnees(donnees));
  }

  @override
  Future<bool> modifierDonnee(String cle, String valeur) async {
    return ajouterDonnee(cle, valeur);
  }

  @override
  Future<bool> supprimerDonnee(String cle) async {
    final donnees = await getDonnees();
    donnees.remove(cle);
    return _preferences.setString(_donneesKey, _encodeDonnees(donnees));
  }

  @override
  Future<bool> sauvegarderDonnees(Map<String, dynamic> donnees) async {
    final historique = await obtenirHistorique();
    historique.add(donnees);
    return _preferences.setString(_historiqueKey, _encodeDonnees(historique));
  }

  @override
  Future<Map<String, dynamic>> chargerDonnees() async {
    final historique = await obtenirHistorique();
    return historique.isNotEmpty ? historique.last : {};
  }

  @override
  Future<bool> supprimerDonnees(String id) async {
    final historique = await obtenirHistorique();
    historique.removeWhere((donnee) => donnee['id'] == id);
    return _preferences.setString(_historiqueKey, _encodeDonnees(historique));
  }

  @override
  Future<List<Map<String, dynamic>>> obtenirHistorique() async {
    final historique = _preferences.getString(_historiqueKey);
    if (historique == null) return [];
    return List<Map<String, dynamic>>.from(await _decodeDonnees(historique));
  }

  String _encodeDonnees(dynamic donnees) {
    return donnees.toString();
  }

  Future<dynamic> _decodeDonnees(String donnees) async {
    return donnees;
  }
}
