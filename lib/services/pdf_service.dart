// services/pdf_service.dart
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:get_it/get_it.dart';
import '../features/gestion_donnees/domain/repositories/donnees_repository.dart';
import '../models/radiateur.dart';
import '../services/analyse_thermique_service.dart';
import '../services/calcul_service.dart';
import '../models/appareil.dart';

class PDFService {
  static Future<File> generateDimensionnementPDF({
    required Map<String, dynamic> resultats,
    required String typeCalcul,
    Map<String, String>? entete,
    Map<String, String>? piedPage,
    bool showPreview = false,
  }) async {
    final pdf = pw.Document();
    final repository = GetIt.instance<DonneesRepository>();
    final logoPath = await repository.getLogoPath();

    // En-tête personnalisé
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

    if (showPreview) {
      // TODO: Implémenter la prévisualisation
    }

    return await _saveAndSharePDF(pdf, 'dimensionnement_$typeCalcul');
  }

  static Future<File> generateBEPDF({
    required Map<String, dynamic> resultats,
    required String typeBE,
  }) async {
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
                if (logoPath != null) 'logoPath': logoPath,
              }),
              pw.SizedBox(height: 20),
              _buildTitle('Bureau d\'Étude - $typeBE'),
              pw.SizedBox(height: 20),
              _buildResultats(resultats),
            ],
          );
        },
      ),
    );

    return await _saveAndSharePDF(pdf, 'be_$typeBE');
  }

  static Future<File> generateRapportCompletPDF({
    required Map<String, dynamic> resultats,
    required String typeInstallation,
  }) async {
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
                if (logoPath != null) 'logoPath': logoPath,
              }),
              pw.SizedBox(height: 20),
              _buildTitle('Rapport Complet - $typeInstallation'),
              pw.SizedBox(height: 20),
              _buildResultatsComplets(resultats),
            ],
          );
        },
      ),
    );

    return await _saveAndSharePDF(pdf, 'rapport_complet_$typeInstallation');
  }

  static Future<File> generateExcel({
    required Map<String, dynamic> resultats,
    required String typeCalcul,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Résultats'];

    // Ajout des en-têtes
    sheet.appendRow(['Paramètre', 'Valeur']);

    // Ajout des données
    _addDataToExcel(sheet, resultats);

    // Sauvegarde du fichier
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/export_$typeCalcul.xlsx');
    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  static void _addDataToExcel(Sheet sheet, Map<String, dynamic> data) {
    data.forEach((key, value) {
      if (value is Map) {
        sheet.appendRow([key]);
        _addDataToExcel(sheet, value as Map<String, dynamic>);
      } else {
        sheet.appendRow([key, value.toString()]);
      }
    });
  }

  static pw.Widget _buildHeader(Map<String, String>? entete) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue100,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                entete?['titre'] ?? 'Chauffage Expert',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (entete?['sousTitre'] != null) ...[
                pw.SizedBox(height: 8),
                pw.Text(
                  entete!['sousTitre']!,
                  style: const pw.TextStyle(fontSize: 14),
                ),
              ],
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              if (entete?['logoPath'] != null) ...[
                pw.Image(
                  pw.MemoryImage(
                    File(entete!['logoPath']!).readAsBytesSync(),
                  ),
                  height: 50,
                ),
                pw.SizedBox(height: 8),
              ],
              pw.Text(
                DateFormat('dd/MM/yyyy').format(DateTime.now()),
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(Map<String, String> piedPage) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            piedPage['gauche'] ?? '',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            piedPage['droite'] ?? '',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTitle(String title) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
      ),
    );
  }

  static pw.Widget _buildResultats(Map<String, dynamic> resultats) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: resultats.entries.map((entry) {
        if (entry.value is Map) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                entry.key,
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              _buildResultats(entry.value as Map<String, dynamic>),
              pw.SizedBox(height: 10),
            ],
          );
        } else {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Text('${entry.key}: ${entry.value}'),
          );
        }
      }).toList(),
    );
  }

  static pw.Widget _buildResultatsComplets(Map<String, dynamic> resultats) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSection('Chauffage', resultats['chauffage']),
        pw.SizedBox(height: 20),
        _buildSection('ECS', resultats['ecs']),
        pw.SizedBox(height: 20),
        _buildSection('Ventilation', resultats['vmc']),
        pw.SizedBox(height: 20),
        _buildSection('Recommandations', resultats['recommandations']),
      ],
    );
  }

  static pw.Widget _buildSection(String title, Map<String, dynamic>? data) {
    if (data == null) return pw.SizedBox.shrink();

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildResultats(data),
        ],
      ),
    );
  }

  static Future<File> _saveAndSharePDF(pw.Document pdf, String fileName) async {
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$fileName.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<void> sharePDF(File file) async {
    await Share.shareXFiles([XFile(file.path)],
        text: 'Rapport Chauffage Expert');
  }

  static Future<pw.Document> genererRapportThermiquePDF({
    required List<Radiateur> radiateurs,
    required Map<String, String> entreprise,
    required Map<String, String> client,
  }) async {
    final rapportGlobal =
        AnalyseThermiqueService.genererRapportGlobal(radiateurs);
    final synthese = rapportGlobal['synthese'] as Map<String, dynamic>;
    final pdf = pw.Document();

    // Convertir les radiateurs en appareils pour les calculs hydrauliques
    final appareils = radiateurs
        .map((r) => Appareil(
              nom: "${r.modele} - ${r.identification}",
              uniteDebit: r.puissance / 1000, // Conversion en kW
              quantite: 1,
            ))
        .toList();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          _construireEntete(entreprise, client),
          pw.SizedBox(height: 20),
          _construireSynthese(synthese),
          pw.SizedBox(height: 20),
          _construireCalculsHydrauliques(appareils),
          pw.SizedBox(height: 20),
          _construireDetailsRadiateurs(
              rapportGlobal['rapportsDetaille'] as List),
          pw.SizedBox(height: 30),
          pw.Divider(),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              "Généré avec l'application Chauffage Expert®",
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ),
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _construireEntete(
    Map<String, String> entreprise,
    Map<String, String> client,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(
          level: 0,
          child: pw.Text(
            "Rapport d'Analyse Thermique",
            style: const pw.TextStyle(fontSize: 20),
          ),
        ),
        pw.Text(
          "Entreprise : ${entreprise['nom'] ?? ''}",
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          "SIRET : ${entreprise['siret'] ?? ''} - ${entreprise['tel'] ?? ''}",
        ),
        pw.SizedBox(height: 10),
        pw.Text("Client : ${client['nom'] ?? ''}"),
        pw.Text("Adresse : ${client['adresse'] ?? ''}"),
        pw.Text("Date : ${client['date'] ?? ''}"),
      ],
    );
  }

  static pw.Widget _construireSynthese(Map<String, dynamic> synthese) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "SYNTHÈSE DE L'INSTALLATION",
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Bullet(
          text:
              "Puissance totale : ${synthese['puissanceTotale'].toStringAsFixed(2)} W",
        ),
        pw.Bullet(
          text:
              "Besoin thermique total : ${synthese['besoinTotal'].toStringAsFixed(2)} W",
        ),
        pw.Bullet(
          text:
              "Marge totale : ${synthese['margeTotale'].toStringAsFixed(2)} W",
        ),
        pw.Bullet(
          text:
              "Nombre de radiateurs non conformes : ${synthese['nombreNonConformes']}",
        ),
      ],
    );
  }

  static pw.Widget _construireCalculsHydrauliques(List<Appareil> appareils) {
    final debit = CalculService.calculerDebit(appareils);
    final diametreInterieur = CalculService.calculerDiametreInterieur(debit);
    final diametreNominal =
        CalculService.trouverDiametreNominal(diametreInterieur);
    final coefficientSimultaneite =
        CalculService.calculerCoefficientSimultaneite(appareils.length);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "CALCULS HYDRAULIQUES",
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Paramètres de calcul",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Text("Vitesse maximale : ${CalculService.vitesseMax} m/s"),
              pw.Text("Nombre d'appareils : ${appareils.length}"),
              pw.Text(
                  "Coefficient de simultanéité : ${coefficientSimultaneite.toStringAsFixed(3)}"),
              pw.SizedBox(height: 10),
              pw.Text(
                "Résultats",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Text("Débit total : ${(debit * 1000).toStringAsFixed(2)} L/s"),
              pw.Text(
                  "Diamètre intérieur calculé : ${diametreInterieur.toStringAsFixed(2)} mm"),
              pw.Text("Diamètre nominal recommandé : $diametreNominal"),
              pw.SizedBox(height: 10),
              pw.Text(
                "Note : Les calculs sont basés sur les normes DTU 60.11",
                style: pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey700,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _construireDetailsRadiateurs(List<dynamic> rapports) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "DÉTAIL DES RADIATEURS",
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        ...rapports.map((rapport) => _construireRadiateurDetail(rapport)),
      ],
    );
  }

  static pw.Widget _construireRadiateurDetail(Map<String, dynamic> rapport) {
    final estConforme =
        rapport['puissanceSuffisante'] && rapport['materiauAdapte'];

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                "Radiateur ${rapport['reference']} - ${rapport['identification']}",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                estConforme ? "CONFORME" : "NON CONFORME",
                style: pw.TextStyle(
                  color: estConforme ? PdfColors.green : PdfColors.orange,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Text("Modèle : ${rapport['modele']}"),
          pw.Text("Dimensions : ${rapport['dimensions']}"),
          pw.Text("Puissance : ${rapport['puissance'].toStringAsFixed(2)} W"),
          pw.Text(
            "Besoin thermique : ${rapport['besoinThermique'].toStringAsFixed(2)} W",
          ),
          pw.Text("Marge : ${rapport['margePuissance'].toStringAsFixed(2)} W"),
          pw.Text("Matériau tuyauterie : ${rapport['materiauTuyauterie']}"),
          if ((rapport['recommandations'] as List).isNotEmpty) ...[
            pw.SizedBox(height: 5),
            pw.Text(
              "Recommandations :",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            ...rapport['recommandations'].map(
              (recommandation) => pw.Text(
                "• $recommandation",
                style: const pw.TextStyle(color: PdfColors.orange),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
