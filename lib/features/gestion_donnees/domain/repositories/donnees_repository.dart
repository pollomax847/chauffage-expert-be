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
}
