// Be_chauffage_expert/lib/features/gestion_donnees/domain/repositories/donnees_repository.dart
import 'package:shared_preferences/shared_preferences.dart';

abstract class DonneesRepository {
  Future<Map<String, String>> getDonnees();
  Future<bool> ajouterDonnee(String cle, String valeur);
  Future<bool> modifierDonnee(String cle, String valeur);
  Future<bool> supprimerDonnee(String cle);
  Future<bool> sauvegarderDonnees(Map<String, dynamic> donnees);
  Future<Map<String, dynamic>> chargerDonnees();
  Future<bool> supprimerDonnees(String id);
  Future<List<Map<String, dynamic>>> obtenirHistorique();
}
