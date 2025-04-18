import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'be_project_service.dart';
import 'be_security_service.dart';

class BEDatabaseService {
  static final String _apiUrl = 'https://api.be-calculator.com';
  static final String _apiKey = 'YOUR_API_KEY'; // À remplacer par une vraie clé
  static final Map<String, Map<String, dynamic>> _localCache = {};
  static String? _databaseFilePath;
  static const String _localFile = 'be_database.json';
  static const String _backupFile = 'be_database_backup.json';
  static const String _cloudEndpoint = 'https://api.example.com/data';
  static const Duration _cacheValidity = Duration(hours: 1);
  static DateTime? _lastSync;

  static Future<String> get _databaseFile async {
    if (_databaseFilePath == null) {
      final directory = await getApplicationDocumentsDirectory();
      _databaseFilePath = '${directory.path}/be_database.json';
    }
    return _databaseFilePath!;
  }

  static Future<void> initialize() async {
    try {
      await loadLocalData();
      await BESecurityService.logSecurityEvent(
        'initialisation',
        'Base de données initialisée',
      );
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de l\'initialisation de la base de données: $e',
      );
      rethrow;
    }
  }

  static Future<void> loadLocalData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_localFile');
      
      if (!await file.exists()) {
        await BESecurityService.logSecurityEvent(
          'chargement',
          'Aucun fichier de base de données local trouvé',
        );
        return;
      }

      final jsonData = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonData);

      // Vérification de l'intégrité des données
      for (final entry in data.entries) {
        final hash = entry.value['hash'];
        final calculatedHash = BESecurityService.hashData(entry.value['data']);

        if (hash != calculatedHash) {
          await BESecurityService.logSecurityEvent(
            'erreur',
            'Données corrompues détectées pour la clé: ${entry.key}',
          );
          continue;
        }

        _localCache[entry.key] = entry.value['data'];
      }

      await BESecurityService.logSecurityEvent(
        'chargement',
        'Données locales chargées: ${_localCache.length} entrées',
      );
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors du chargement des données locales: $e',
      );
      rethrow;
    }
  }

  static Future<void> _saveLocalData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_localFile');
      
      final Map<String, dynamic> dataToSave = {};
      for (final entry in _localCache.entries) {
        dataToSave[entry.key] = {
          'data': entry.value,
          'hash': BESecurityService.hashData(entry.value),
        };
      }

      final jsonData = jsonEncode(dataToSave);
      await file.writeAsString(jsonData);

      await BESecurityService.logSecurityEvent(
        'sauvegarde',
        'Données locales sauvegardées',
      );
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la sauvegarde des données locales: $e',
      );
      rethrow;
    }
  }

  static Future<void> syncWithCloud() async {
    try {
      if (_lastSync != null &&
          DateTime.now().difference(_lastSync!) < _cacheValidity) {
        await BESecurityService.logSecurityEvent(
          'synchronisation',
          'Synchronisation ignorée: cache valide',
        );
        return;
      }

      final response = await http.get(Uri.parse(_cloudEndpoint));
      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la synchronisation: ${response.statusCode}');
      }

      final Map<String, dynamic> cloudData = jsonDecode(response.body);
      
      // Vérification de l'intégrité des données cloud
      for (final entry in cloudData.entries) {
        final hash = entry.value['hash'];
        final calculatedHash = BESecurityService.hashData(entry.value['data']);

        if (hash != calculatedHash) {
          await BESecurityService.logSecurityEvent(
            'erreur',
            'Données cloud corrompues détectées pour la clé: ${entry.key}',
          );
          continue;
        }

        _localCache[entry.key] = entry.value['data'];
      }

      _lastSync = DateTime.now();
      await _saveLocalData();

      await BESecurityService.logSecurityEvent(
        'synchronisation',
        'Synchronisation avec le cloud réussie',
      );
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la synchronisation avec le cloud: $e',
      );
      rethrow;
    }
  }

  static Future<void> saveData({
    required String key,
    required Map<String, dynamic> data,
  }) async {
    try {
      if (!BESecurityService.validateParameters(
        module: 'database',
        parameters: {
          'key': key,
          'data': data,
        },
      )) {
        throw Exception('Paramètres invalides pour la sauvegarde');
      }

      _localCache[key] = data;
      await _saveLocalData();
      await _uploadToCloud(key, data);

      await BESecurityService.logSecurityEvent(
        'sauvegarde',
        'Données sauvegardées pour la clé: $key',
      );
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la sauvegarde des données: $e',
      );
      rethrow;
    }
  }

  static Future<void> _uploadToCloud(
    String key,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(_cloudEndpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'key': key,
          'data': data,
          'hash': BESecurityService.hashData(data),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de l\'upload: ${response.statusCode}');
      }

      await BESecurityService.logSecurityEvent(
        'upload',
        'Données uploadées pour la clé: $key',
      );
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de l\'upload des données: $e',
      );
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getData(String key) async {
    try {
      if (_localCache.containsKey(key)) {
        return _localCache[key];
      }

      await syncWithCloud();
      if (!_localCache.containsKey(key)) {
        throw Exception('Données non trouvées pour la clé: $key');
      }

      return _localCache[key];
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la récupération des données: $e',
      );
      rethrow;
    }
  }

  static Future<void> backup() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final sourceFile = File('${directory.path}/$_localFile');
      final backupFile = File('${directory.path}/$_backupFile');

      if (await sourceFile.exists()) {
        await sourceFile.copy(backupFile.path);
        await BESecurityService.logSecurityEvent(
          'sauvegarde',
          'Backup créé avec succès',
        );
      }
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la création du backup: $e',
      );
      rethrow;
    }
  }

  static Future<void> restoreFromBackup() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final sourceFile = File('${directory.path}/$_localFile');
      final backupFile = File('${directory.path}/$_backupFile');

      if (await backupFile.exists()) {
        await backupFile.copy(sourceFile.path);
        await loadLocalData();
        await BESecurityService.logSecurityEvent(
          'restauration',
          'Backup restauré avec succès',
        );
      }
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la restauration du backup: $e',
      );
      rethrow;
    }
  }
}

