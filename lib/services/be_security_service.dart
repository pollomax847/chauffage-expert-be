import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class BESecurityService {
  static const String _logFileName = 'security_log.txt';

  // Hasher les données pour vérification d'intégrité
  static String hashData(dynamic data) {
    final jsonData = jsonEncode(data);
    final bytes = utf8.encode(jsonData);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Valider les paramètres requis
  static bool validateParameters({
    required String module,
    required Map<String, dynamic> parameters,
  }) {
    final requiredParams = _getRequiredParameters(module);

    for (final param in requiredParams) {
      if (!parameters.containsKey(param) || parameters[param] == null) {
        logSecurityEvent(
            'validation', 'Paramètre manquant: $param pour module $module');
        return false;
      }
    }

    return true;
  }

  // Valider les résultats des calculs
  static bool validateResults({
    required String module,
    required Map<String, dynamic> results,
  }) {
    // Vérifier les valeurs anormales ou incohérentes
    if (results.isEmpty) {
      logSecurityEvent('validation', 'Résultats vides pour module $module');
      return false;
    }

    // Vérifications spécifiques par module
    switch (module) {
      case 'chauffage':
        return _validateChauffageResults(results);
      case 'hydraulique':
        return _validateHydrauliqueResults(results);
      case 'vmc':
        return _validateVMCResults(results);
      case 'geothermie':
        return _validateGeothermieResults(results);
      default:
        return true;
    }
  }

  // Journaliser les événements de sécurité
  static Future<void> logSecurityEvent(String type, String message) async {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '$timestamp [$type] $message\n';

    try {
      final directory = await _getLogDirectory();
      final file = File('${directory.path}/$_logFileName');
      await file.writeAsString(logEntry, mode: FileMode.append);

      if (kDebugMode) {
        debugPrint('Log: $logEntry');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Erreur lors de la journalisation: $e');
      }
    }
  }

  // Obtenir le répertoire des journaux
  static Future<Directory> _getLogDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final logDir = Directory('${appDir.path}/logs');

    if (!(await logDir.exists())) {
      await logDir.create(recursive: true);
    }

    return logDir;
  }

  // Obtenir les paramètres requis par module
  static List<String> _getRequiredParameters(String module) {
    switch (module) {
      case 'chauffage':
        return ['surfaces', 'zoneClimatique', 'temperatureInterieure'];
      case 'hydraulique':
        return ['appareils', 'longueur'];
      case 'vmc':
        return ['locaux', 'longueur', 'diametre'];
      case 'geothermie':
        return ['puissanceThermique', 'typeCaptage'];
      default:
        return [];
    }
  }

  // Validation spécifique des résultats de chauffage
  static bool _validateChauffageResults(Map<String, dynamic> results) {
    final deperditions = results['deperditionsTotales'];
    return deperditions != null &&
        double.tryParse(deperditions.toString()) != null;
  }

  // Validation spécifique des résultats hydrauliques
  static bool _validateHydrauliqueResults(Map<String, dynamic> results) {
    return results['debitProbable'] != null &&
        results['diametreNominal'] != null;
  }

  // Validation spécifique des résultats VMC
  static bool _validateVMCResults(Map<String, dynamic> results) {
    return results['debitTotal'] != null;
  }

  // Validation spécifique des résultats géothermie
  static bool _validateGeothermieResults(Map<String, dynamic> results) {
    return results['longueur'] != null && results['typeCaptage'] != null;
  }
}
