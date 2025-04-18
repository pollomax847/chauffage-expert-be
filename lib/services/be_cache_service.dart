import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'be_security_service.dart';

class BECacheService {
  static final Map<String, Map<String, dynamic>> _cache = {};
  static final Map<String, DateTime> _timestamps = {};
  static const Duration _dureeValidite = Duration(minutes: 30);
  static String? _cacheFilePath;

  static Future<String> get _cacheFile async {
    if (_cacheFilePath == null) {
      final directory = await getApplicationDocumentsDirectory();
      _cacheFilePath = '${directory.path}/be_cache.json';
    }
    return _cacheFilePath!;
  }

  static Future<Map<String, dynamic>?> get(String key) async {
    try {
      if (!_cache.containsKey(key)) {
        return null;
      }

      final timestamp = _timestamps[key];
      if (timestamp == null ||
          DateTime.now().difference(timestamp) > _dureeValidite) {
        _cache.remove(key);
        _timestamps.remove(key);
        return null;
      }

      return _cache[key];
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la récupération du cache: $e',
      );
      return null;
    }
  }

  static Future<void> set(String key, Map<String, dynamic> value) async {
    try {
      _cache[key] = value;
      _timestamps[key] = DateTime.now();
      await _saveCache();
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la sauvegarde du cache: $e',
      );
    }
  }

  static Future<void> _saveCache() async {
    try {
      final cacheFile = await _cacheFile;
      final dataToSave = {
        'cache': _cache,
        'timestamps': _timestamps.map(
          (key, value) => MapEntry(key, value.toIso8601String()),
        ),
      };
      final jsonData = jsonEncode(dataToSave);
      await File(cacheFile).writeAsString(jsonData);
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la sauvegarde du cache: $e',
      );
    }
  }

  static Future<void> loadCache() async {
    try {
      final cacheFile = await _cacheFile;
      final file = File(cacheFile);
      if (await file.exists()) {
        final jsonData = await file.readAsString();
        final decodedData = jsonDecode(jsonData);
        _cache.clear();
        _timestamps.clear();
        _cache.addAll(decodedData['cache']);
        _timestamps.addAll(
          (decodedData['timestamps'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, DateTime.parse(value)),
          ),
        );
      }
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors du chargement du cache: $e',
      );
    }
  }

  static void clear() {
    _cache.clear();
    _timestamps.clear();
  }
}
