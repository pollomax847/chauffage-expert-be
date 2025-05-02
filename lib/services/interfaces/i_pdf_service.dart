// services/interfaces/i_pdf_service.dart
import 'dart:io';
import '../../models/rapport.dart';

/// Interface définissant le contrat pour les services de génération de PDF.
/// Cette interface permet de générer, stocker et récupérer des rapports PDF.
abstract class IPdfService {
  /// Génère un rapport PDF pour une étude technique.
  ///
  /// [clientName] : Nom du client pour lequel le rapport est généré.
  /// [entrepriseName] : Nom de l'entreprise effectuant l'étude.
  /// [moduleName] : Nom du module d'étude (ex: Chauffage, ECS, VMC).
  /// [results] : Résultats de l'étude sous forme de Map.
  ///
  /// Retourne un [Rapport] contenant les informations du rapport généré.
  ///
  /// Lance une [Exception] si la génération échoue.
  Future<Rapport> generateBEStudyPDF({
    required String clientName,
    required String entrepriseName,
    required String moduleName,
    required Map<String, dynamic> results,
  });

  /// Récupère la liste des rapports générés.
  ///
  /// Retourne une liste non modifiable de [Rapport].
  List<Rapport> getReports();

  /// Récupère le fichier PDF d'un rapport spécifique.
  ///
  /// [reportId] : Identifiant unique du rapport.
  ///
  /// Retourne le [File] du rapport ou null si non trouvé.
  ///
  /// Lance une [Exception] si le rapport n'existe pas.
  Future<File?> getReportFile(String reportId);

  /// Initialise le service.
  ///
  /// Cette méthode doit être appelée avant toute utilisation du service.
  /// Elle s'occupe de la configuration initiale et du chargement des rapports existants.
  ///
  /// Lance une [Exception] si l'initialisation échoue.
  Future<void> initialize();
}
