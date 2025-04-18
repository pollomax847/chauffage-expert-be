import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class BELoggingService {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  static String? _logFilePath;

  static Future<String> get _logFile async {
    if (_logFilePath == null) {
      final directory = await getApplicationDocumentsDirectory();
      _logFilePath = '${directory.path}/be_calculs.log';
    }
    return _logFilePath!;
  }

  static Future<void> logCalcul(
      String module, Map<String, dynamic> resultats) async {
    try {
      final logFile = await _logFile;
      final timestamp = _dateFormat.format(DateTime.now());
      final logEntry = '''
[$timestamp] CALCUL - Module: $module
${_formatMap(resultats)}
''';

      await File(logFile).writeAsString(logEntry, mode: FileMode.append);
    } catch (e) {
      print('Erreur lors de l\'enregistrement du log: $e');
    }
  }

  static Future<void> logErreur(String module, String erreur) async {
    try {
      final logFile = await _logFile;
      final timestamp = _dateFormat.format(DateTime.now());
      final logEntry = '''
[$timestamp] ERREUR - Module: $module
Message: $erreur
''';

      await File(logFile).writeAsString(logEntry, mode: FileMode.append);
    } catch (e) {
      print('Erreur lors de l\'enregistrement de l\'erreur: $e');
    }
  }

  static String _formatMap(Map<String, dynamic> map, {int indent = 0}) {
    final buffer = StringBuffer();
    final indentStr = '  ' * indent;

    map.forEach((key, value) {
      if (value is Map) {
        buffer.writeln('$indentStr$key:');
        buffer.write(
            _formatMap(value as Map<String, dynamic>, indent: indent + 1));
      } else {
        buffer.writeln('$indentStr$key: $value');
      }
    });

    return buffer.toString();
  }

  static Future<List<String>> getLogs({int? limit}) async {
    try {
      final logFile = await _logFile;
      final file = File(logFile);

      if (!await file.exists()) {
        return [];
      }

      final lines = await file.readAsLines();
      return limit != null ? lines.take(limit).toList() : lines;
    } catch (e) {
      print('Erreur lors de la lecture des logs: $e');
      return [];
    }
  }

  static Future<void> clearLogs() async {
    try {
      final logFile = await _logFile;
      final file = File(logFile);
      if (await file.exists()) {
        await file.writeAsString('');
      }
    } catch (e) {
      print('Erreur lors de la suppression des logs: $e');
    }
  }
}
