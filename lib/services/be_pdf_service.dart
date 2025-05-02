// services/be_pdf_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:get_it/get_it.dart';
import '../models/rapport.dart';
import '../features/gestion_donnees/domain/repositories/donnees_repository.dart';
import '../models/radiateur.dart';
import './interfaces/i_pdf_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import './analyse_thermique_service.dart';
import './calcul_service.dart';
import '../models/appareil.dart';

/// Service de génération de PDF pour les études techniques.
///
/// Ce service permet de :
/// - Générer des rapports PDF pour les études techniques
/// - Stocker les rapports générés
/// - Gérer l'historique des rapports
/// - Sauvegarder les rapports dans le stockage local
class BEPdfService implements IPdfService {
  final List<Rapport> _reports = [];
  late final String _basePath;
  static const _reportsKey = 'pdf_reports';
  final SharedPreferences _prefs;
  final _logger = Logger();

  /// Crée une nouvelle instance de [BEPdfService].
  ///
  /// [prefs] : Instance de [SharedPreferences] pour le stockage persistant.
  BEPdfService(this._prefs);

  @override
  Future<void> initialize() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      _basePath = '${appDir.path}/rapports';
      await Directory(_basePath).create(recursive: true);
      _loadSavedReports();
      _logger.i('BEPdfService initialisé avec succès');
    } catch (e, stackTrace) {
      _logger.e('Erreur lors de l\'initialisation de BEPdfService',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  void _loadSavedReports() {
    try {
      final savedReports = _prefs.getStringList(_reportsKey) ?? [];
      _reports.clear();
      for (final reportJson in savedReports) {
        try {
          final reportMap =
              Map<String, dynamic>.from(Map.from(reportJson as Map));
          _reports.add(Rapport.fromJson(reportMap));
        } catch (e) {
          _logger.w('Erreur lors du chargement d\'un rapport: $e');
        }
      }
      _logger.i('${_reports.length} rapports chargés');
    } catch (e) {
      _logger.e('Erreur lors du chargement des rapports', error: e);
      _reports.clear();
    }
  }

  void _saveReports() {
    try {
      final reportsJson = _reports.map((r) => r.toJson()).toList();
      _prefs.setStringList(
          _reportsKey, reportsJson.map((r) => r.toString()).toList());
      _logger.i('Rapports sauvegardés avec succès');
    } catch (e) {
      _logger.e('Erreur lors de la sauvegarde des rapports', error: e);
    }
  }

  @override
  Future<Rapport> generateBEStudyPDF({
    required String clientName,
    required String entrepriseName,
    required String moduleName,
    required Map<String, dynamic> results,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Rapport Technique', style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text('Client: $clientName'),
              pw.Text('Entreprise: $entrepriseName'),
              pw.Text('Module: $moduleName'),
              pw.SizedBox(height: 20),
              pw.Text('Résultats:', style: const pw.TextStyle(fontSize: 18)),
              ...results.entries.map((e) => pw.Text('${e.key}: ${e.value}')),
            ],
          ),
        ),
      );

      final rapport = Rapport(
        clientName: clientName,
        entrepriseName: entrepriseName,
        moduleName: moduleName,
        results: results,
      );

      final file = File('$_basePath/${rapport.id}.pdf');
      await file.writeAsBytes(await pdf.save());

      final rapportWithPath = Rapport(
        id: rapport.id,
        clientName: rapport.clientName,
        entrepriseName: rapport.entrepriseName,
        moduleName: rapport.moduleName,
        results: rapport.results,
        createdAt: rapport.createdAt,
        filePath: file.path,
      );

      _reports.add(rapportWithPath);
      _saveReports();

      _logger.i('Rapport généré avec succès: ${rapportWithPath.id}');
      return rapportWithPath;
    } catch (e, stackTrace) {
      _logger.e('Erreur lors de la génération du rapport',
          error: e, stackTrace: stackTrace);
      throw Exception('Erreur lors de la génération du rapport: $e');
    }
  }

  /// Génère un PDF de dimensionnement avec en-tête et pied de page personnalisés
  Future<File> generateDimensionnementPDF({
    required Map<String, dynamic> resultats,
    required String typeCalcul,
    Map<String, String>? entete,
    Map<String, String>? piedPage,
    bool showPreview = false,
  }) async {
    try {
      final pdf = pw.Document();
      final repository = GetIt.instance<DonneesRepository>();
      final logoPath = await repository.getLogoPath();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildHeader({
                  ...?entete,
                  if (logoPath != null) 'logoPath': logoPath,
                }),
                pw.SizedBox(height: 20),
                _buildTitle(typeCalcul),
                pw.SizedBox(height: 20),
                _buildResultats(resultats),
                if (piedPage != null) ...[
                  pw.Spacer(),
                  _buildFooter(piedPage),
                ],
              ],
            );
          },
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/dimensionnement_$timestamp.pdf');
      await file.writeAsBytes(await pdf.save());

      if (showPreview) {
        await Share.shareFiles([file.path], text: 'Rapport de dimensionnement');
      }

      return file;
    } catch (e, stackTrace) {
      _logger.e('Erreur lors de la génération du PDF de dimensionnement',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  pw.Widget _buildHeader(Map<String, String> entete) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        ...entete.entries.map((e) => pw.Text('${e.key}: ${e.value}')),
      ],
    );
  }

  pw.Widget _buildTitle(String typeCalcul) {
    return pw.Text(
      'Rapport de dimensionnement - $typeCalcul',
      style: pw.TextStyle(
        fontSize: 20,
        fontWeight: pw.FontWeight.bold,
      ),
    );
  }

  pw.Widget _buildResultats(Map<String, dynamic> resultats) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        ...resultats.entries.map((e) => pw.Text('${e.key}: ${e.value}')),
      ],
    );
  }

  pw.Widget _buildFooter(Map<String, String> piedPage) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        ...piedPage.entries.map((e) => pw.Text('${e.key}: ${e.value}')),
      ],
    );
  }

  @override
  List<Rapport> getReports() => List.unmodifiable(_reports);

  @override
  Future<File?> getReportFile(String reportId) async {
    try {
      final rapport = _reports.firstWhere(
        (r) => r.id == reportId,
        orElse: () => throw Exception('Rapport non trouvé: $reportId'),
      );

      if (rapport.filePath == null) {
        _logger.w('Le rapport $reportId n\'a pas de fichier associé');
        return null;
      }

      final file = File(rapport.filePath!);
      if (!await file.exists()) {
        _logger.w('Le fichier du rapport $reportId n\'existe pas');
        return null;
      }

      return file;
    } catch (e) {
      _logger.e(
          'Erreur lors de la récupération du fichier du rapport $reportId',
          error: e);
      return null;
    }
  }
}
