import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'be_coordination_service.dart';
import 'be_security_service.dart';

class BEProjectService {
  static final Map<String, Map<String, dynamic>> _projects = {};
  static String? _projectsFilePath;

  static Future<String> get _projectsFile async {
    if (_projectsFilePath == null) {
      final directory = await getApplicationDocumentsDirectory();
      _projectsFilePath = '${directory.path}/be_projects.json';
    }
    return _projectsFilePath!;
  }

  static Future<void> saveProject({
    required String name,
    required Map<String, dynamic> parameters,
    required Map<String, dynamic> results,
  }) async {
    try {
      // Validation des paramètres
      if (!BESecurityService.validateParameters(
        module: 'project',
        parameters: parameters,
      )) {
        throw Exception('Paramètres de projet invalides');
      }

      final project = {
        'name': name,
        'parameters': parameters,
        'results': results,
        'timestamp': DateTime.now().toIso8601String(),
        'hash': BESecurityService.hashData({
          'parameters': parameters,
          'results': results,
        }),
      };

      _projects[name] = project;
      await _saveProjectsToFile();
      
      await BESecurityService.logSecurityEvent(
        'projet',
        'Projet $name sauvegardé avec succès',
      );
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la sauvegarde du projet: $e',
      );
      rethrow;
    }
  }

  static Future<void> _saveProjectsToFile() async {
    try {
      final projectsFile = await _projectsFile;
      final dataToSave = Map<String, dynamic>.from(_projects);
      
      // Ajouter le hachage pour chaque projet
      for (final entry in dataToSave.entries) {
        final project = Map<String, dynamic>.from(entry.value);
        project['hash'] = BESecurityService.hashData({
          'parameters': project['parameters'],
          'results': project['results'],
        });
        dataToSave[entry.key] = project;
      }
      
      final jsonProjects = jsonEncode(dataToSave);
      await File(projectsFile).writeAsString(jsonProjects);
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la sauvegarde des projets: $e',
      );
      print('Erreur lors de la sauvegarde des projets: $e');
    }
  }

  static Future<void> loadProjects() async {
    try {
      final projectsFile = await _projectsFile;
      final file = File(projectsFile);
      if (await file.exists()) {
        final jsonProjects = await file.readAsString();
        final decodedProjects = jsonDecode(jsonProjects);
        
        // Vérifier l'intégrité des projets
        for (final entry in decodedProjects.entries) {
          final project = entry.value;
          final storedHash = project['hash'];
          if (storedHash == null) continue;
          
          final dataToVerify = {
            'parameters': project['parameters'],
            'results': project['results'],
          };
          
          final calculatedHash = BESecurityService.hashData(dataToVerify);
          if (calculatedHash == storedHash) {
            _projects[entry.key] = project;
          } else {
            await BESecurityService.logSecurityEvent(
              'securité',
              'Intégrité du projet ${entry.key} compromise',
            );
          }
        }
      }
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors du chargement des projets: $e',
      );
      print('Erreur lors du chargement des projets: $e');
    }
  }

  static Future<Map<String, dynamic>> compareProjects(
    String project1Name,
    String project2Name,
  ) async {
    try {
      final project1 = _projects[project1Name];
      final project2 = _projects[project2Name];

      if (project1 == null || project2 == null) {
        throw Exception('Projet non trouvé');
      }

      // Vérifier l'intégrité des projets
      if (!_verifyProjectIntegrity(project1) || !_verifyProjectIntegrity(project2)) {
        throw Exception('Intégrité des projets compromise');
      }

      final results1 = project1['results'];
      final results2 = project2['results'];

      final comparison = {
        'deperditions': _compareValues(
          double.parse(results1['deperditions']['deperditionsTotales']),
          double.parse(results2['deperditions']['deperditionsTotales']),
        ),
        'hydraulique': _compareValues(
          double.parse(results1['hydraulique']['debitProbable']),
          double.parse(results2['hydraulique']['debitProbable']),
        ),
        'vmc': _compareValues(
          double.parse(results1['vmc']['debitAjuste']),
          double.parse(results2['vmc']['debitAjuste']),
        ),
      };

      await BESecurityService.logSecurityEvent(
        'comparaison',
        'Comparaison des projets $project1Name et $project2Name effectuée',
      );

      return comparison;
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la comparaison des projets: $e',
      );
      rethrow;
    }
  }

  static bool _verifyProjectIntegrity(Map<String, dynamic> project) {
    try {
      final storedHash = project['hash'];
      if (storedHash == null) return false;

      final dataToVerify = {
        'parameters': project['parameters'],
        'results': project['results'],
      };

      final calculatedHash = BESecurityService.hashData(dataToVerify);
      return calculatedHash == storedHash;
    } catch (e) {
      return false;
    }
  }

  static Map<String, dynamic> _compareValues(double value1, double value2) {
    final difference = value2 - value1;
    final percentage = (difference / value1 * 100).abs();

    return {
      'value1': value1.toStringAsFixed(2),
      'value2': value2.toStringAsFixed(2),
      'difference': difference.toStringAsFixed(2),
      'percentage': percentage.toStringAsFixed(1),
      'isBetter': difference < 0,
    };
  }

  static Future<Map<String, dynamic>> generateReport(String projectName) async {
    try {
      final project = _projects[projectName];
      if (project == null) {
        throw Exception('Projet non trouvé');
      }

      if (!_verifyProjectIntegrity(project)) {
        throw Exception('Intégrité du projet compromise');
      }

      final results = project['results'];
      final recommendations = await _generateRecommendations(results);

      final report = {
        'project': project,
        'recommendations': recommendations,
        'timestamp': DateTime.now().toIso8601String(),
        'hash': BESecurityService.hashData({
          'project': project,
          'recommendations': recommendations,
        }),
      };

      await BESecurityService.logSecurityEvent(
        'rapport',
        'Rapport généré pour le projet $projectName',
      );

      return report;
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la génération du rapport: $e',
      );
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> _generateRecommendations(
    Map<String, dynamic> results,
  ) async {
    final recommendations = <Map<String, dynamic>>[];

    // Recommandations basées sur les déperditions
    final deperditions =
        double.parse(results['deperditions']['deperditionsTotales']);
    if (deperditions > 10000) {
      recommendations.add({
        'type': 'alerte',
        'message': 'Les déperditions thermiques sont élevées',
        'suggestion': 'Envisager une meilleure isolation',
      });
    }

    // Recommandations basées sur le débit hydraulique
    final debit = double.parse(results['hydraulique']['debitProbable']);
    if (debit > 2.0) {
      recommendations.add({
        'type': 'info',
        'message': 'Débit hydraulique important',
        'suggestion': 'Vérifier le dimensionnement des canalisations',
      });
    }

    return recommendations;
  }

  static List<String> getProjectNames() {
    return _projects.keys.toList();
  }

  static Map<String, dynamic>? getProject(String name) {
    final project = _projects[name];
    if (project != null && !_verifyProjectIntegrity(project)) {
      BESecurityService.logSecurityEvent(
        'securité',
        'Tentative d\'accès à un projet corrompu: $name',
      );
      return null;
    }
    return project;
  }

  static Future<void> deleteProject(String name) async {
    try {
      _projects.remove(name);
      await _saveProjectsToFile();
      
      await BESecurityService.logSecurityEvent(
        'projet',
        'Projet $name supprimé avec succès',
      );
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la suppression du projet: $e',
      );
      rethrow;
    }
  }
}
