import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/rapport.dart';
import './interfaces/i_pdf_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BEPdfService implements IPdfService {
  final List<Rapport> _reports = [];
  late final String _basePath;
  static const _reportsKey = 'pdf_reports';
  final SharedPreferences _prefs;

  BEPdfService(this._prefs);

  @override
  Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    _basePath = '${appDir.path}/rapports';
    await Directory(_basePath).create(recursive: true);
    _loadSavedReports();
  }

  void _loadSavedReports() {
    final savedReports = _prefs.getStringList(_reportsKey) ?? [];
    _reports.clear();
    for (final reportJson in savedReports) {
      try {
        _reports.add(Rapport.fromJson(
            Map<String, dynamic>.from(Map.from(reportJson as Map))));
      } catch (e) {
        print('Erreur lors du chargement du rapport: $e');
      }
    }
  }

  void _saveReports() {
    final reportsJson = _reports.map((r) => r.toJson()).toList();
    _prefs.setStringList(
        _reportsKey, reportsJson.map((r) => r.toString()).toList());
  }

  @override
  Future<Rapport> generateBEStudyPDF({
    required String clientName,
    required String entrepriseName,
    required String moduleName,
    required Map<String, dynamic> results,
  }) async {
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

    return rapportWithPath;
  }

  @override
  List<Rapport> getReports() => List.unmodifiable(_reports);

  @override
  Future<File?> getReportFile(String reportId) async {
    final rapport = _reports.firstWhere(
      (r) => r.id == reportId,
      orElse: () => throw Exception('Rapport non trouvé'),
    );

    if (rapport.filePath == null) return null;

    final file = File(rapport.filePath!);
    if (!await file.exists()) return null;

    return file;
  }
}
