// features/gestion_donnees/domain/repositories/donnees_repository.dart
abstract class DonneesRepository {
  Future<Map<String, dynamic>> getDonnees();
  Future<bool> ajouterDonnee(String cle, dynamic valeur);
  Future<bool> modifierDonnee(String cle, dynamic valeur);
  Future<bool> supprimerDonnee(String cle);

  // Gestion du logo
  Future<String?> getLogoPath();
  Future<bool> setLogoPath(String path);
  Future<bool> removeLogo();

  Future<bool> sauvegarderDonnees(Map<String, dynamic> donnees);
  Future<Map<String, dynamic>> chargerDonnees();
  Future<bool> supprimerDonnees(String id);
  Future<List<Map<String, dynamic>>> obtenirHistorique();
}
