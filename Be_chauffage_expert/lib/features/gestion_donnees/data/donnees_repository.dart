import 'package:chauffage_expert/features/gestion_donnees/domain/models/donnees_model.dart';

abstract class DonneesRepository {
  Future<Map<String, dynamic>> chargerDonnees();
  Future<void> sauvegarderDonnees(Map<String, dynamic> donnees);
  Future<void> supprimerDonnees();
} 