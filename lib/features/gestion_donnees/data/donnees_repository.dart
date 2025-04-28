// Be_chauffage_expert/lib/features/gestion_donnees/data/donnees_repository.dart
abstract class DonneesRepository {
  Future<Map<String, dynamic>> chargerDonnees();
  Future<void> sauvegarderDonnees(Map<String, dynamic> donnees);
  Future<void> supprimerDonnees();
}
