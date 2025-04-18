import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'be_chauffage.dart';
import 'be_hydraulique.dart';
import 'be_vmc.dart';
import 'be_geothermie.dart';
import 'be_regulation.dart';
import 'be_alimentation.dart';
import 'be_evacuation.dart';
import 'be_security_service.dart';

class BEOptimizationService {
  static final Map<String, Map<String, dynamic>> _preCalculatedResults = {};
  static final Map<String, DateTime> _preCalculatedTimestamps = {};

  // Calcul parallèle des différents modules
  static Future<Map<String, dynamic>> calculateParallel({
    required Map<String, dynamic> parametres,
  }) async {
    try {
      // Validation des paramètres
      if (!BESecurityService.validateParameters(
        module: 'optimization',
        parameters: parametres,
      )) {
        throw Exception('Paramètres d\'optimisation invalides');
      }

      final results = await Future.wait([
        _calculateInIsolate(
          BEChauffage.calculerDeperditions,
          {
            'surfaces': parametres['surfaces'],
            'zoneClimatique': parametres['zoneClimatique'],
            'temperatureInterieure': parametres['temperatureInterieure'],
            'temperatureExterieure': parametres['temperatureExterieure'],
          },
        ),
        _calculateInIsolate(
          BEHydraulique.calculerDebitProbable,
          {
            'typeBatiment': parametres['typeBatiment'],
            'appareils': parametres['appareils'],
          },
        ),
        _calculateInIsolate(
          BEVMC.calculerDebitVMC,
          {
            'volumeHabitable': parametres['volumeHabitable'],
            'typeVMC': parametres['typeVMC'],
            'nombrePieces': parametres['nombrePieces'],
          },
        ),
      ]);

      // Vérification de l'intégrité des résultats
      for (final result in results) {
        final hash = BESecurityService.hashData(result);
        await BESecurityService.logSecurityEvent(
          'calcul',
          'Calcul parallèle terminé - Hash: $hash',
        );
      }

      return {
        'deperditions': results[0],
        'hydraulique': results[1],
        'vmc': results[2],
        'hash': BESecurityService.hashData({
          'deperditions': results[0],
          'hydraulique': results[1],
          'vmc': results[2],
        }),
      };
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors du calcul parallèle: $e',
      );
      rethrow;
    }
  }

  // Pré-calcul des scénarios courants
  static void preCalculateCommonScenarios() {
    try {
      final commonScenarios = [
        {
          'type': 'maison_individuelle',
          'surface': 100.0,
          'zones': 3,
          'appareils': {
            'radiateur': 5,
            'plancher': 1,
          },
        },
        {
          'type': 'appartement',
          'surface': 70.0,
          'zones': 2,
          'appareils': {
            'radiateur': 3,
            'plancher': 0,
          },
        },
      ];

      for (final scenario in commonScenarios) {
        _preCalculateScenario(scenario);
      }

      BESecurityService.logSecurityEvent(
        'optimisation',
        'Pré-calcul des scénarios courants terminé',
      );
    } catch (e) {
      BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors du pré-calcul des scénarios: $e',
      );
    }
  }

  static Future<void> _preCalculateScenario(
      Map<String, dynamic> scenario) async {
    try {
      final key = _generateScenarioKey(scenario);
      if (_isPreCalculatedValid(key)) {
        return;
      }

      final results = await calculateParallel(parametres: scenario);
      _preCalculatedResults[key] = results;
      _preCalculatedTimestamps[key] = DateTime.now();

      await BESecurityService.logSecurityEvent(
        'optimisation',
        'Scénario pré-calculé: $key',
      );
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors du pré-calcul du scénario: $e',
      );
    }
  }

  static String _generateScenarioKey(Map<String, dynamic> scenario) {
    return BESecurityService.hashData(scenario);
  }

  static bool _isPreCalculatedValid(String key) {
    final timestamp = _preCalculatedTimestamps[key];
    if (timestamp == null) return false;

    return DateTime.now().difference(timestamp) < const Duration(hours: 24);
  }

  static Future<Map<String, dynamic>> _calculateInIsolate(
    Function function,
    Map<String, dynamic> params,
  ) async {
    try {
      final receivePort = ReceivePort();
      await Isolate.spawn(
        _isolateEntry,
        _IsolateData(
          function: function,
          params: params,
          sendPort: receivePort.sendPort,
        ),
      );

      final result = await receivePort.first;
      
      // Vérification de l'intégrité du résultat
      final hash = BESecurityService.hashData(result);
      await BESecurityService.logSecurityEvent(
        'calcul',
        'Calcul en isolate terminé - Hash: $hash',
      );

      return result;
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors du calcul en isolate: $e',
      );
      rethrow;
    }
  }

  static void _isolateEntry(_IsolateData data) {
    try {
      final result = data.function(data.params);
      data.sendPort.send(result);
    } catch (e) {
      data.sendPort.send({'error': e.toString()});
    }
  }
}

class _IsolateData {
  final Function function;
  final Map<String, dynamic> params;
  final SendPort sendPort;

  _IsolateData({
    required this.function,
    required this.params,
    required this.sendPort,
  });
}
