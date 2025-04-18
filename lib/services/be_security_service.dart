import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';

class BESecurityService {
  static final Map<String, String> _allowedTypes = {
    'temperature': r'^-?\d+(\.\d+)?$',
    'puissance': r'^\d+(\.\d+)?$',
    'debit': r'^\d+(\.\d+)?$',
    'surface': r'^\d+(\.\d+)?$',
    'nombre': r'^\d+$',
  };

  static final Map<String, List<String>> _requiredFields = {
    'chauffage': ['surfaces', 'zoneClimatique', 'temperatureInterieure'],
    'hydraulique': ['typeBatiment', 'appareils'],
    'vmc': ['volumeHabitable', 'typeVMC', 'nombrePieces'],
  };

  static final Map<String, List<String>> _parametresValides = {
    'chauffage': [
      'surfaces',
      'zoneClimatique',
      'temperatureInterieure',
      'temperatureExterieure'
    ],
    'hydraulique': ['typeBatiment', 'appareils'],
    'vmc': ['volumeHabitable', 'typeVMC', 'nombrePieces'],
    'geothermie': ['puissanceCalculee', 'typeCaptage', 'surfaceTerrain'],
    'regulation': ['puissanceChaudiere', 'typeRegulation', 'nombreZones'],
    'alimentation': ['puissanceThermique', 'typeSysteme'],
    'evacuation': ['puissanceChaudiere', 'typeEvacuation'],
    'project': ['name', 'parameters', 'results'],
    'notification': ['type', 'message', 'data'],
    'database': ['key', 'data'],
    'optimization': [
      'surfaces',
      'zoneClimatique',
      'temperatureInterieure',
      'temperatureExterieure',
      'typeBatiment',
      'appareils',
      'volumeHabitable',
      'typeVMC',
      'nombrePieces'
    ],
  };

  static final Map<String, List<String>> _resultatsValides = {
    'chauffage': ['deperditionsTotales', 'deperditionsParZone'],
    'hydraulique': ['debitProbable', 'diametre', 'pertesCharge'],
    'vmc': ['debitAjuste', 'puissanceVentilateur'],
    'geothermie': ['puissance', 'longueurCaptage'],
    'regulation': ['puissance', 'nombreVannes'],
    'alimentation': ['puissance', 'intensite', 'sectionCable'],
    'evacuation': ['diametre', 'hauteurMinimale', 'pertesCharge'],
  };

  static String? _logFilePath;

  static Future<String> get _logFile async {
    if (_logFilePath == null) {
      final directory = await getApplicationDocumentsDirectory();
      _logFilePath = '${directory.path}/be_security_logs.json';
    }
    return _logFilePath!;
  }

  static bool validateParameters({
    required String module,
    required Map<String, dynamic> parameters,
  }) {
    final parametresValides = _parametresValides[module];
    if (parametresValides == null) return false;

    for (final parametre in parametresValides) {
      if (!parameters.containsKey(parametre)) {
        return false;
      }
    }

    return true;
  }

  static bool validateResult({
    required String module,
    required Map<String, dynamic> result,
  }) {
    final resultatsValides = _resultatsValides[module];
    if (resultatsValides == null) return false;

    for (final resultat in resultatsValides) {
      if (!result.containsKey(resultat)) {
        return false;
      }
    }

    return true;
  }

  static String? _getValueType(dynamic value) {
    if (value is int || value is double) {
      return 'nombre';
    } else if (value is String) {
      if (value.contains('.')) {
        return 'temperature';
      }
      return 'nombre';
    }
    return null;
  }

  static bool _isValidType(dynamic value, String type) {
    final pattern = _allowedTypes[type];
    if (pattern == null) return true;

    return RegExp(pattern).hasMatch(value.toString());
  }

  static String hashData(Map<String, dynamic> data) {
    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<void> logSecurityEvent(String type, String message) async {
    try {
      final logFile = await _logFile;
      final timestamp = DateTime.now().toIso8601String();
      final logEntry = {
        'timestamp': timestamp,
        'type': type,
        'message': message,
      };

      final file = File(logFile);
      List<Map<String, dynamic>> logs = [];

      if (await file.exists()) {
        final jsonData = await file.readAsString();
        logs = List<Map<String, dynamic>>.from(jsonDecode(jsonData));
      }

      logs.add(logEntry);

      // Garder seulement les 1000 dernières entrées
      if (logs.length > 1000) {
        logs = logs.sublist(logs.length - 1000);
      }

      await file.writeAsString(jsonEncode(logs));
    } catch (e) {
      print('Erreur lors de l\'écriture du log de sécurité: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getSecurityLogs({
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final logFile = await _logFile;
      final file = File(logFile);

      if (!await file.exists()) {
        return [];
      }

      final jsonData = await file.readAsString();
      List<Map<String, dynamic>> logs =
          List<Map<String, dynamic>>.from(jsonDecode(jsonData));

      // Filtrer par type si spécifié
      if (type != null) {
        logs = logs.where((log) => log['type'] == type).toList();
      }

      // Filtrer par date si spécifié
      if (startDate != null) {
        logs = logs.where((log) {
          final timestamp = DateTime.parse(log['timestamp']);
          return timestamp.isAfter(startDate);
        }).toList();
      }

      if (endDate != null) {
        logs = logs.where((log) {
          final timestamp = DateTime.parse(log['timestamp']);
          return timestamp.isBefore(endDate);
        }).toList();
      }

      return logs;
    } catch (e) {
      print('Erreur lors de la lecture des logs de sécurité: $e');
      return [];
    }
  }

  static Future<void> clearSecurityLogs() async {
    try {
      final logFile = await _logFile;
      final file = File(logFile);
      if (await file.exists()) {
        await file.writeAsString('[]');
      }
    } catch (e) {
      print('Erreur lors de la suppression des logs de sécurité: $e');
    }
  }

  static Future<void> backupSecurityLogs() async {
    try {
      final logFile = await _logFile;
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final backupFile =
          '${directory.path}/be_security_logs_backup_$timestamp.json';

      final file = File(logFile);
      if (await file.exists()) {
        await file.copy(backupFile);
      }
    } catch (e) {
      print('Erreur lors de la création du backup des logs de sécurité: $e');
    }
  }

  static bool validateResults({
    required String module,
    required Map<String, dynamic> results,
  }) {
    try {
      // Vérification des résultats selon le module
      switch (module) {
        case 'geothermie':
          return _validateGeothermieResults(results);
        case 'chauffage':
          return _validateChauffageResults(results);
        case 'hydraulique':
          return _validateHydrauliqueResults(results);
        case 'vmc':
          return _validateVMCResults(results);
        default:
          return false;
      }
    } catch (e) {
      logSecurityEvent('erreur', 'Erreur lors de la validation des résultats: $e');
      return false;
    }
  }

  static bool _validateGeothermieResults(Map<String, dynamic> results) {
    // Vérification des champs obligatoires
    if (!results.containsKey('type_captage') ||
        !results.containsKey('puissance_thermique') ||
        !results.containsKey('cop')) {
      return false;
    }

    // Vérification des valeurs
    final typeCaptage = results['type_captage'] as String;
    final puissanceThermique = results['puissance_thermique'] as double;
    final cop = results['cop'] as double;

    if (puissanceThermique <= 0 || cop <= 0) {
      return false;
    }

    // Vérifications spécifiques selon le type de captage
    switch (typeCaptage) {
      case 'horizontal':
        if (!results.containsKey('longueur_capteur') ||
            !results.containsKey('surface_captage') ||
            !results.containsKey('faisable')) {
          return false;
        }
        final longueurCapteur = results['longueur_capteur'] as double;
        final surfaceCaptage = results['surface_captage'] as double;
        if (longueurCapteur <= 0 || surfaceCaptage <= 0) {
          return false;
        }
        break;

      case 'vertical':
        if (!results.containsKey('nombre_sondes') ||
            !results.containsKey('profondeur_sondes') ||
            !results.containsKey('longueur_totale')) {
          return false;
        }
        final nombreSondes = results['nombre_sondes'] as int;
        final profondeurSondes = results['profondeur_sondes'] as double;
        final longueurTotale = results['longueur_totale'] as double;
        if (nombreSondes <= 0 || profondeurSondes <= 0 || longueurTotale <= 0) {
          return false;
        }
        break;

      case 'sur_sonde':
        if (!results.containsKey('longueur_sonde') ||
            !results.containsKey('profondeur_sonde')) {
          return false;
        }
        final longueurSonde = results['longueur_sonde'] as double;
        final profondeurSonde = results['profondeur_sonde'] as double;
        if (longueurSonde <= 0 || profondeurSonde <= 0) {
          return false;
        }
        break;

      default:
        return false;
    }

    return true;
  }

  static bool _validateChauffageResults(Map<String, dynamic> results) {
    // Vérification des champs obligatoires
    if (!results.containsKey('deperditions_totales') ||
        !results.containsKey('deperditions_par_zone') ||
        !results.containsKey('puissance_chaudiere')) {
      return false;
    }

    // Vérification des valeurs
    final deperditionsTotales = results['deperditions_totales'] as double;
    final deperditionsParZone = results['deperditions_par_zone'] as Map<String, double>;
    final puissanceChaudiere = results['puissance_chaudiere'] as double;

    if (deperditionsTotales <= 0 || puissanceChaudiere <= 0) {
      return false;
    }

    // Vérification des déperditions par zone
    for (final zone in deperditionsParZone.values) {
      if (zone <= 0) {
        return false;
      }
    }

    // Vérification des champs optionnels
    if (results.containsKey('rendement_chaudiere')) {
      final rendement = results['rendement_chaudiere'] as double;
      if (rendement <= 0 || rendement > 1) {
        return false;
      }
    }

    return true;
  }

  static bool _validateHydrauliqueResults(Map<String, dynamic> results) {
    // Vérification des champs obligatoires
    if (!results.containsKey('debit_probable') ||
        !results.containsKey('diametre_tuyau') ||
        !results.containsKey('pertes_charge')) {
      return false;
    }

    // Vérification des valeurs
    final debitProbable = results['debit_probable'] as double;
    final diametreTuyau = results['diametre_tuyau'] as double;
    final pertesCharge = results['pertes_charge'] as double;

    if (debitProbable <= 0 || diametreTuyau <= 0 || pertesCharge < 0) {
      return false;
    }

    // Vérification des champs optionnels
    if (results.containsKey('vitesse_ecoulement')) {
      final vitesse = results['vitesse_ecoulement'] as double;
      if (vitesse <= 0) {
        return false;
      }
    }

    return true;
  }

  static bool _validateVMCResults(Map<String, dynamic> results) {
    // Vérification des champs obligatoires
    if (!results.containsKey('debit_ajuste') ||
        !results.containsKey('puissance_ventilateur') ||
        !results.containsKey('nombre_extractions')) {
      return false;
    }

    // Vérification des valeurs
    final debitAjuste = results['debit_ajuste'] as double;
    final puissanceVentilateur = results['puissance_ventilateur'] as double;
    final nombreExtractions = results['nombre_extractions'] as int;

    if (debitAjuste <= 0 || puissanceVentilateur <= 0 || nombreExtractions <= 0) {
      return false;
    }

    // Vérification des champs optionnels
    if (results.containsKey('debit_par_extraction')) {
      final debitParExtraction = results['debit_par_extraction'] as Map<String, double>;
      for (final debit in debitParExtraction.values) {
        if (debit <= 0) {
          return false;
        }
      }
    }

    return true;
  }
}
