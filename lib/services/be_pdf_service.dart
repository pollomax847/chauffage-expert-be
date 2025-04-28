import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'be_security_service.dart';
import 'be_schema_service.dart';

class BEPDFService {
  // Définition des thèmes par défaut
  static const Map<String, Map<String, dynamic>> _themes = {
    'classique': {
      'fond': '#f8f9fa',
      'texte': '#212529',
      'texteSecondaire': '#495057',
      'bordure': '#dee2e6',
      'chaudiere': '#dc3545',
      'circuit': '#0d6efd',
      'radiateur': '#198754',
      'retour': '#6c757d',
      'tailles': {
        'largeurSchema': 600,
        'hauteurSchema': 400,
        'largeurLegende': 150,
        'hauteurLegende': 100,
        'taillePoliceTitre': 12,
        'taillePoliceTexte': 10,
        'taillePoliceValeur': 8,
        'epaisseurTrait': 2,
        'rayonPoint': 10,
        'marge': 20,
      },
      'polices': {
        'titre': 'Arial',
        'texte': 'Arial',
        'valeur': 'Arial',
        'styleTitre': 'bold',
        'styleTexte': 'normal',
        'styleValeur': 'normal',
      },
    },
    'sombre': {
      'fond': '#212529',
      'texte': '#f8f9fa',
      'texteSecondaire': '#adb5bd',
      'bordure': '#495057',
      'chaudiere': '#ff6b6b',
      'circuit': '#4dabf7',
      'radiateur': '#51cf66',
      'retour': '#adb5bd',
      'tailles': {
        'largeurSchema': 600,
        'hauteurSchema': 400,
        'largeurLegende': 150,
        'hauteurLegende': 100,
        'taillePoliceTitre': 12,
        'taillePoliceTexte': 10,
        'taillePoliceValeur': 8,
        'epaisseurTrait': 2,
        'rayonPoint': 10,
        'marge': 20,
      },
      'polices': {
        'titre': 'Arial',
        'texte': 'Arial',
        'valeur': 'Arial',
        'styleTitre': 'bold',
        'styleTexte': 'normal',
        'styleValeur': 'normal',
      },
    },
    'professionnel': {
      'fond': '#ffffff',
      'texte': '#1a1a1a',
      'texteSecondaire': '#666666',
      'bordure': '#cccccc',
      'chaudiere': '#e63946',
      'circuit': '#1d3557',
      'radiateur': '#2a9d8f',
      'retour': '#457b9d',
      'tailles': {
        'largeurSchema': 800,
        'hauteurSchema': 500,
        'largeurLegende': 200,
        'hauteurLegende': 120,
        'taillePoliceTitre': 14,
        'taillePoliceTexte': 12,
        'taillePoliceValeur': 10,
        'epaisseurTrait': 3,
        'rayonPoint': 12,
        'marge': 30,
      },
      'polices': {
        'titre': 'Helvetica',
        'texte': 'Helvetica',
        'valeur': 'Helvetica',
        'styleTitre': 'bold',
        'styleTexte': 'normal',
        'styleValeur': 'normal',
      },
    },
  };

  static const Map<String, Map<String, dynamic>> _zonesClimatiques = {
    'H1': {
      'temperature_reference': -9,
      'coefficient_correction': 1.2,
      'description': 'Zone froide',
    },
    'H2': {
      'temperature_reference': -6,
      'coefficient_correction': 1.1,
      'description': 'Zone tempérée',
    },
    'H3': {
      'temperature_reference': -3,
      'coefficient_correction': 1.0,
      'description': 'Zone chaude',
    },
  };

  static const Map<String, Map<String, dynamic>> _typesBatiments = {
    'residentiel_maison': {
      'occupation': 24,
      'renouvellement_air': 0.6,
      'temperature_consigne': 19,
    },
    'residentiel_collectif': {
      'occupation': 16,
      'renouvellement_air': 0.8,
      'temperature_consigne': 20,
    },
    'tertiaire_bureaux': {
      'occupation': 8,
      'renouvellement_air': 1.0,
      'temperature_consigne': 21,
    },
    'tertiaire_commerces': {
      'occupation': 12,
      'renouvellement_air': 1.2,
      'temperature_consigne': 20,
    },
    'educatif': {
      'occupation': 6,
      'renouvellement_air': 1.5,
      'temperature_consigne': 20,
    },
    'sante': {
      'occupation': 24,
      'renouvellement_air': 2.0,
      'temperature_consigne': 22,
    },
  };

  static const Map<String, Map<String, dynamic>> _niveauxPerformance = {
    'bbc': {
      'consommation_max': 50,
      'description': 'Bâtiment Basse Consommation',
      'exigences': [
        'Isolation renforcée',
        'Ventilation double flux',
        'Étanchéité à l\'air',
      ],
    },
    'bepos': {
      'consommation_max': 0,
      'description': 'Bâtiment à Énergie Positive',
      'exigences': [
        'Production d\'énergie renouvelable',
        'Batteries de stockage',
        'Gestion intelligente de l\'énergie',
      ],
    },
    'rt2012': {
      'consommation_max': 50,
      'description': 'Réglementation Thermique 2012',
      'exigences': [
        'Bbio max',
        'Cep max',
        'Tic max',
      ],
    },
    'rt2020': {
      'consommation_max': 0,
      'description': 'Réglementation Thermique 2020',
      'exigences': [
        'Bepos',
        'Carbone',
        'Confort d\'été',
      ],
    },
    're2020': {
      'consommation_max': 0,
      'description': 'Réglementation Environnementale 2020',
      'exigences': [
        'Carbone',
        'Énergie',
        'Confort d\'été',
      ],
    },
  };

  static Future<File> generateBEStudyPDF({
    required String clientName,
    required String entrepriseName,
    required String moduleName,
    required Map<String, dynamic> results,
    String? remarque,
    String? photoPath,
  }) async {
    final pdf = pw.Document();

    // En-tête
    final header = pw.Header(
      level: 0,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Client: $clientName'),
          pw.Text('Entreprise: $entrepriseName'),
        ],
      ),
    );

    // Corps
    final body = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Module: $moduleName', style: const pw.TextStyle(fontSize: 20)),
        pw.SizedBox(height: 20),
        pw.Table(
          border: pw.TableBorder.all(),
          children: results.entries.map((entry) {
            return pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(entry.key),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(entry.value.toString()),
                ),
              ],
            );
          }).toList(),
        ),
        if (remarque != null) ...[
          pw.SizedBox(height: 20),
          pw.Text('Remarques:'),
          pw.Text(remarque),
        ],
      ],
    );

    // Pied de page
    final footer = pw.Container(
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('© $entrepriseName'),
          pw.Text('Date: ${DateTime.now().toString()}'),
        ],
      ),
    );

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [header, body, footer],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$moduleName.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<File> generateMultiStudyPDF({
    required String clientName,
    required String entrepriseName,
    required List<Map<String, dynamic>> studies,
  }) async {
    final pdf = pw.Document();

    for (var study in studies) {
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            children: [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Client: $clientName'),
                    pw.Text('Entreprise: $entrepriseName'),
                  ],
                ),
              ),
              pw.Text('Module: ${study['moduleName']}'),
              pw.Table(
                border: pw.TableBorder.all(),
                children: study['results'].entries.map((entry) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(entry.key),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(entry.value.toString()),
                      ),
                    ],
                  );
                }).toList(),
              ),
              if (study['remarque'] != null) ...[
                pw.SizedBox(height: 20),
                pw.Text('Remarques:'),
                pw.Text(study['remarque']),
              ],
            ],
          ),
        ),
      );
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/etudes_completes.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<String> genererRapport({
    required String module,
    required Map<String, dynamic> parametres,
    required Map<String, dynamic> resultats,
    String theme = 'classique',
    Map<String, String>? stylePersonnalise,
    Map<String, double>? taillesPersonnalisees,
    Map<String, String>? policesPersonnalisees,
    String typeBatiment = 'neuf',
    Map<String, dynamic>? contexteProjet,
  }) async {
    try {
      final pdf = pw.Document();
      final schema = await BESchemaService.genererSchema(
        module: module,
        resultats: resultats,
        theme: theme,
        stylePersonnalise: stylePersonnalise,
        taillesPersonnalisees: taillesPersonnalisees,
        policesPersonnalisees: policesPersonnalisees,
      );

      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Rapport de calcul - Module $module',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Date: ${DateTime.now().toString()}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
              if (contexteProjet != null) ...[
                pw.Header(
                  level: 1,
                  child: pw.Text(
                    'Contexte du projet',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Table.fromTextArray(
                  headers: ['Paramètre', 'Valeur'],
                  data: contexteProjet.entries
                      .map((e) => [e.key, e.value.toString()])
                      .toList(),
                ),
                pw.SizedBox(height: 20),
              ],
              pw.Header(
                level: 1,
                child: pw.Text(
                  'Paramètres d\'entrée',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Table.fromTextArray(
                headers: ['Paramètre', 'Valeur', 'Unité'],
                data: parametres.entries
                    .map((e) => [
                          e.key,
                          e.value.toString(),
                          _getUnite(e.key),
                        ])
                    .toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Header(
                level: 1,
                child: pw.Text(
                  'Résultats',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Table.fromTextArray(
                headers: ['Résultat', 'Valeur', 'Unité'],
                data: resultats.entries
                    .map((e) => [
                          e.key,
                          e.value.toString(),
                          _getUnite(e.key),
                        ])
                    .toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Header(
                level: 1,
                child: pw.Text(
                  'Schéma de principe',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SvgImage(svg: schema),
              pw.SizedBox(height: 20),
              pw.Header(
                level: 1,
                child: pw.Text(
                  'Recommandations',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(_getRecommandations(
                module,
                resultats,
                typeBatiment,
                contexteProjet,
              )),
              pw.SizedBox(height: 20),
              pw.Text(
                'Document généré par BE - Hash: ${_genererHash(module, parametres, resultats)}',
                style: const pw.TextStyle(fontSize: 8),
              ),
            ],
          ),
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final file = File(
          '${directory.path}/rapport_${module}_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      await BESecurityService.logSecurityEvent(
        'info',
        'Rapport PDF généré pour le module $module',
      );

      return file.path;
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la génération du rapport PDF: $e',
      );
      rethrow;
    }
  }

  static String _getUnite(String cle) {
    switch (cle) {
      case 'puissance':
        return 'kW';
      case 'temperature':
      case 'temperature_depart':
      case 'temperature_retour':
      case 'temperature_entree':
      case 'temperature_sortie':
        return '°C';
      case 'debit':
        return 'm³/h';
      case 'volume':
        return 'L';
      case 'pression':
        return 'bar';
      case 'surface':
        return 'm²';
      case 'rendement':
        return '%';
      default:
        return '';
    }
  }

  static String _getStatutEtude(Map<String, dynamic> etude) {
    final typeBatiment = etude['type_batiment'] ?? 'Non spécifié';
    final module = etude['module'];
    final resultats = etude['resultats'];

    switch (module) {
      case 'chauffage':
        final puissance = resultats['puissance'] ?? 0;
        if (typeBatiment == 'neuf') {
          return puissance > 100 ? 'À optimiser' : 'Conforme RT 2020';
        } else {
          return puissance > 100 ? 'À optimiser' : 'Conforme RT existant';
        }
      case 'vmc':
        final debit = resultats['debit'] ?? 0;
        if (typeBatiment == 'neuf') {
          return debit < 100 ? 'Non conforme' : 'Conforme RT 2020';
        } else {
          return debit < 100 ? 'À améliorer' : 'Conforme RT existant';
        }
      default:
        return 'À évaluer';
    }
  }

  static String _getRecommandations(
    String module,
    Map<String, dynamic> resultats,
    String typeBatiment,
    Map<String, dynamic>? contexteProjet,
  ) {
    var recommandations = '';

    switch (module.toLowerCase()) {
      case 'chauffage':
        final puissance = resultats['puissance'] ?? 0;
        final temperatureConsigne =
            contexteProjet?['temperature_consigne'] ?? 20;
        final zoneClimatique =
            contexteProjet?['zone_climatique'] ?? 'Non spécifiée';

        recommandations =
            'Pour un bâtiment $typeBatiment en zone $zoneClimatique :\n'
            '- Puissance calculée : ${puissance.toStringAsFixed(2)} kW\n'
            '- Température de consigne : $temperatureConsigne°C\n\n'
            'Recommandations générales :\n'
            '- Optimiser l\'isolation thermique\n'
            '- Mettre en place une régulation performante\n'
            '- Considérer les énergies renouvelables\n\n';

        if (contexteProjet != null) {
          recommandations += 'Recommandations spécifiques au contexte :\n';
          if (contexteProjet['niveau_performance'] != null) {
            recommandations +=
                '- Respecter les exigences ${contexteProjet['niveau_performance']}\n';
          }
          if (contexteProjet['contraintes_particulieres'] != null) {
            recommandations +=
                '- Prendre en compte : ${contexteProjet['contraintes_particulieres']}\n';
          }
        }
        break;

      case 'vmc':
        final debit = resultats['debit'] ?? 0;
        final renouvellementAir = contexteProjet?['renouvellement_air'] ?? 0.6;
        final occupation = contexteProjet?['occupation'] ?? 8;

        recommandations = 'Pour un bâtiment $typeBatiment :\n'
            '- Débit calculé : ${debit.toStringAsFixed(2)} m³/h\n'
            '- Renouvellement d\'air : $renouvellementAir vol/h\n'
            '- Occupation : $occupation h/jour\n\n'
            'Recommandations générales :\n'
            '- Assurer une bonne étanchéité à l\'air\n'
            '- Optimiser le réseau de gaines\n'
            '- Mettre en place une régulation adaptée\n\n';

        if (contexteProjet != null) {
          recommandations += 'Recommandations spécifiques au contexte :\n';
          if (contexteProjet['qualite_air'] != null) {
            recommandations +=
                '- Respecter les exigences de qualité d\'air : ${contexteProjet['qualite_air']}\n';
          }
          if (contexteProjet['contraintes_acoustiques'] != null) {
            recommandations +=
                '- Prendre en compte les contraintes acoustiques\n';
          }
        }
        break;

      default:
        recommandations = 'Recommandations générales pour le module $module :\n'
            '- Vérifier la conformité aux réglementations en vigueur\n'
            '- Optimiser les performances énergétiques\n'
            '- Assurer le confort des occupants\n';

        if (contexteProjet != null) {
          recommandations += '\nRecommandations spécifiques au contexte :\n';
          contexteProjet.forEach((key, value) {
            if (key != 'temperature_consigne' &&
                key != 'renouvellement_air' &&
                key != 'occupation') {
              recommandations += '- $key : $value\n';
            }
          });
        }
    }

    return recommandations;
  }

  static String _genererHash(String module, Map<String, dynamic> parametres,
      Map<String, dynamic> resultats) {
    final data = {
      'module': module,
      'parametres': parametres,
      'resultats': resultats,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    return data.toString().hashCode.toRadixString(16);
  }

  static Map<String, dynamic> _fusionnerThemes(
    Map<String, dynamic> themeBase,
    Map<String, dynamic>? stylePersonnalise,
    Map<String, dynamic>? taillesPersonnalisees,
    Map<String, dynamic>? policesPersonnalisees,
  ) {
    final themeFusionne = Map<String, dynamic>.from(themeBase);

    if (stylePersonnalise != null) {
      themeFusionne.addAll(stylePersonnalise);
    }

    if (taillesPersonnalisees != null) {
      themeFusionne['tailles'] = {
        ...themeFusionne['tailles'],
        ...taillesPersonnalisees,
      };
    }

    if (policesPersonnalisees != null) {
      themeFusionne['polices'] = {
        ...themeFusionne['polices'],
        ...policesPersonnalisees,
      };
    }

    return themeFusionne;
  }

  static Map<String, dynamic> _getTheme(String nomTheme) {
    return _themes[nomTheme] ?? _themes['classique']!;
  }
}
