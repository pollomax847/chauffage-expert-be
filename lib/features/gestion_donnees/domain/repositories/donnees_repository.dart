// features/gestion_donnees/domain/repositories/donnees_repository.dart
abstract class DonneesRepository {
  Future<void> sauvegarderDonnees(Map<String, dynamic> donnees);
  Future<Map<String, dynamic>> chargerDonnees();
  Future<void> supprimerDonnees(String id);
  Future<List<Map<String, dynamic>>> obtenirHistorique();
}
