// features/gestion_donnees/presentation/controllers/donnees_controller.dart
import '../../domain/repositories/donnees_repository.dart';

class DonneesController {
  final DonneesRepository _repository;

  DonneesController(this._repository);

  Future<Map<String, dynamic>> getDonnees() async {
    return await _repository.getDonnees();
  }

  Future<bool> ajouterDonnee(String cle, dynamic valeur) async {
    return await _repository.ajouterDonnee(cle, valeur);
  }

  Future<bool> modifierDonnee(String cle, dynamic valeur) async {
    return await _repository.modifierDonnee(cle, valeur);
  }

  Future<bool> supprimerDonnee(String cle) async {
    return await _repository.supprimerDonnee(cle);
  }

  Future<bool> sauvegarderDonnees(Map<String, dynamic> donnees) async {
    return await _repository.sauvegarderDonnees(donnees);
  }

  Future<Map<String, dynamic>> chargerDonnees() async {
    return await _repository.chargerDonnees();
  }

  Future<bool> supprimerDonnees(String id) async {
    return await _repository.supprimerDonnees(id);
  }

  Future<List<Map<String, dynamic>>> obtenirHistorique() async {
    return await _repository.obtenirHistorique();
  }
}
