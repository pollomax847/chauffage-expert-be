import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'be_security_service.dart';

class BEMonitoringService {
  static final Map<String, List<Map<String, dynamic>>> _performances = {};
  static final Map<String, int> _statistiques = {};
  static final Map<String, List<Map<String, dynamic>>> _anomalies = {};
  static const int _maxPerformances = 1000;
  static const int _maxAnomalies = 100;
  static String? _monitoringFilePath;

  static Future<String> get _monitoringFile async {
    if (_monitoringFilePath == null) {
      final directory = await getApplicationDocumentsDirectory();
      _monitoringFilePath = '${directory.path}/be_monitoring.json';
    }
    return _monitoringFilePath!;
  }

  static Future<void> enregistrerPerformance({
    required String module,
    required String operation,
    required Duration duree,
    Map<String, dynamic>? details,
  }) async {
    try {
      final performance = {
        'timestamp': DateTime.now().toIso8601String(),
        'module': module,
        'operation': operation,
        'duree': duree.inMilliseconds,
        'details': details,
      };

      if (!_performances.containsKey(module)) {
        _performances[module] = [];
      }

      _performances[module]!.add(performance);
      if (_performances[module]!.length > _maxPerformances) {
        _performances[module]!.removeAt(0);
      }

      // Mise à jour des statistiques
      _statistiques[module] = (_statistiques[module] ?? 0) + 1;

      // Détection d'anomalies
      if (_estAnomalie(performance)) {
        await _enregistrerAnomalie(performance);
      }

      await _sauvegarderMonitoring();
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de l\'enregistrement des performances: $e',
      );
    }
  }

  static bool _estAnomalie(Map<String, dynamic> performance) {
    final duree = performance['duree'] as int;
    final module = performance['module'] as String;

    // Calcul de la moyenne des durées pour ce module
    final performancesModule = _performances[module] ?? [];
    if (performancesModule.isEmpty) return false;

    final moyenne = performancesModule
            .map((p) => p['duree'] as int)
            .reduce((a, b) => a + b) /
        performancesModule.length;

    // Une anomalie est détectée si la durée est 3 fois supérieure à la moyenne
    return duree > moyenne * 3;
  }

  static Future<void> _enregistrerAnomalie(
      Map<String, dynamic> performance) async {
    try {
      final anomalie = {
        'timestamp': DateTime.now().toIso8601String(),
        'performance': performance,
        'type': 'duree_excessive',
      };

      if (!_anomalies.containsKey(performance['module'])) {
        _anomalies[performance['module']] = [];
      }

      _anomalies[performance['module']]!.add(anomalie);
      if (_anomalies[performance['module']]!.length > _maxAnomalies) {
        _anomalies[performance['module']]!.removeAt(0);
      }

      await BESecurityService.logSecurityEvent(
        'anomalie',
        'Anomalie détectée dans le module ${performance['module']}',
      );
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de l\'enregistrement de l\'anomalie: $e',
      );
    }
  }

  static Future<void> _sauvegarderMonitoring() async {
    try {
      final monitoringFile = await _monitoringFile;
      final dataToSave = {
        'performances': _performances,
        'statistiques': _statistiques,
        'anomalies': _anomalies,
      };
      final jsonData = jsonEncode(dataToSave);
      await File(monitoringFile).writeAsString(jsonData);
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la sauvegarde du monitoring: $e',
      );
    }
  }

  static Future<void> chargerMonitoring() async {
    try {
      final monitoringFile = await _monitoringFile;
      final file = File(monitoringFile);
      if (await file.exists()) {
        final jsonData = await file.readAsString();
        final decodedData = jsonDecode(jsonData);
        _performances.clear();
        _statistiques.clear();
        _anomalies.clear();
        _performances.addAll(decodedData['performances']);
        _statistiques.addAll(decodedData['statistiques']);
        _anomalies.addAll(decodedData['anomalies']);
      }
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors du chargement du monitoring: $e',
      );
    }
  }

  static Map<String, dynamic> getStatistiquesModule(String module) {
    final performances = _performances[module] ?? [];
    final anomalies = _anomalies[module] ?? [];
    final nombreOperations = _statistiques[module] ?? 0;

    if (performances.isEmpty) {
      return {
        'nombreOperations': 0,
        'dureeMoyenne': 0,
        'nombreAnomalies': 0,
      };
    }

    final dureeMoyenne =
        performances.map((p) => p['duree'] as int).reduce((a, b) => a + b) /
            performances.length;

    return {
      'nombreOperations': nombreOperations,
      'dureeMoyenne': dureeMoyenne,
      'nombreAnomalies': anomalies.length,
    };
  }

  static List<Map<String, dynamic>> getAnomaliesModule(String module) {
    return List.from(_anomalies[module] ?? []);
  }

  static void reinitialiser() {
    _performances.clear();
    _statistiques.clear();
    _anomalies.clear();
  }
}
