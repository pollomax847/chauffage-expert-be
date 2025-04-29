// services/be_pdf_service.dart
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/radiateur.dart';
import '../services/analyse_thermique_service.dart';

class BEPdfService {
  // Méthodes pour générer des PDFs
  static Future<File> generateDimensionnementPDF({
    required Map<String, dynamic> resultats,
    required String typeCalcul,
    Map<String, String>? entete,
    Map<String, String>? piedPage,
    bool showPreview = false,
  }) async {
    // Implémentation de la méthode pour générer un PDF de dimensionnement
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            if (entete != null)
              pw.Text(
                entete['titre'] ?? '',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            pw.SizedBox(height: 20),
            pw.Text('Type de calcul: $typeCalcul'),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['Paramètre', 'Valeur'],
              data: resultats.entries
                  .map((e) => [e.key, e.value.toString()])
                  .toList(),
            ),
            if (piedPage != null)
              pw.Text(
                piedPage['texte'] ?? '',
                style: const pw.TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/dimensionnement_$typeCalcul.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<File> generateBEStudyPDF({
    required String clientName,
    required String entrepriseName,
    required String moduleName,
    required Map<String, dynamic> results,
  }) async {
    return generateDimensionnementPDF(
      resultats: {
        'Client': clientName,
        'Entreprise': entrepriseName,
        'Module': moduleName,
        'Résultats': results,
      },
      typeCalcul: 'Étude $moduleName',
    );
  }

  static Future<File> generateBEPDF({
    required Map<String, dynamic> resultats,
    required String typeBE,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Bureau d\'Étude - $typeBE',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            _buildResultsSection(resultats),
            pw.SizedBox(height: 20),
            pw.Text(
              'Généré le ${DateFormat('dd/MM/yyyy à HH:mm').format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/be_$typeBE.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<pw.Document> genererRapportThermiquePDF({
    required List<Radiateur> radiateurs,
    required List<double> besoinsThermiques,
    required List<String> materiauxTuyauterie,
    required List<String> identifications,
    required List<String?> modeles,
    required Map<String, String> entreprise,
    required Map<String, String> client,
  }) async {
    // Vérification que les listes ont la même taille
    if (radiateurs.length != besoinsThermiques.length ||
        radiateurs.length != materiauxTuyauterie.length ||
        radiateurs.length != identifications.length ||
        radiateurs.length != modeles.length) {
      throw ArgumentError('Toutes les listes doivent avoir la même longueur');
    }

    final rapportGlobal = AnalyseThermiqueService.genererRapportGlobal(
      radiateurs,
      besoinsThermiques,
      materiauxTuyauterie,
      identifications,
      modeles,
    );

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Rapport Thermique',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Entreprise: ${entreprise['nom']}'),
            pw.Text('Client: ${client['nom']}'),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: [
                'Radiateur',
                'Besoin Thermique',
                'Matériau Tuyauterie',
                'Identification',
                'Modèle'
              ],
              data: List.generate(
                radiateurs.length,
                (index) => [
                  radiateurs[index]
                      .reference, // Utiliser reference au lieu de nom
                  besoinsThermiques[index].toString(),
                  materiauxTuyauterie[index],
                  identifications[index],
                  modeles[index] ?? 'Non spécifié',
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Synthèse du Rapport:'),
            _buildResultsSection(
                rapportGlobal['synthese'] as Map<String, dynamic>),
          ],
        ),
      ),
    );

    return pdf;
  }

  static Future<void> sharePDF(File file) async {
    await Share.shareXFiles([XFile(file.path)],
        text: 'Rapport Chauffage Expert');
  }

  static pw.Widget _buildResultsSection(Map<String, dynamic> results) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: results.entries.map((entry) {
        if (entry.value is Map) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                entry.key,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              _buildResultsSection(entry.value as Map<String, dynamic>),
              pw.SizedBox(height: 10),
            ],
          );
        } else {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(entry.key),
                pw.Text(entry.value.toString()),
              ],
            ),
          );
        }
      }).toList(),
    );
  }

  static Future<String> genererRapport({
    required String module,
    required Map<String, dynamic> parametres,
    required Map<String, dynamic> resultats,
  }) async {
    // Implementation for generating a PDF report
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Rapport - $module',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Paramètres:'),
            _buildResultsSection(parametres),
            pw.SizedBox(height: 20),
            pw.Text('Résultats:'),
            _buildResultsSection(resultats),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/rapport_${module.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}
