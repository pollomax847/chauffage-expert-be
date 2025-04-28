// services/be_notification_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'be_security_service.dart';

class BENotificationService {
  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();
  final List<Map<String, dynamic>> _notificationHistory = [];
  static const int _maxHistorySize = 1000;
  static const String _notificationFile = 'be_notifications.json';

  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationController.stream;

  Future<void> notify({
    required String type,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Validation des paramètres
      if (!BESecurityService.validateParameters(
        module: 'notification',
        parameters: {
          'type': type,
          'message': message,
          'data': data,
        },
      )) {
        throw Exception('Paramètres de notification invalides');
      }

      final notification = {
        'type': type,
        'message': message,
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
        'hash': BESecurityService.hashData({
          'type': type,
          'message': message,
          'data': data,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      };

      _notificationHistory.add(notification);
      if (_notificationHistory.length > _maxHistorySize) {
        _notificationHistory.removeAt(0);
      }

      _notificationController.add(notification);
      await _saveNotifications();

      await BESecurityService.logSecurityEvent(
        'notification',
        'Notification envoyée: $type - $message',
      );
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de l\'envoi de la notification: $e',
      );
      rethrow;
    }
  }

  Future<void> _saveNotifications() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_notificationFile');
      final jsonData = jsonEncode(_notificationHistory);
      await file.writeAsString(jsonData);

      await BESecurityService.logSecurityEvent(
        'sauvegarde',
        'Notifications sauvegardées',
      );
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la sauvegarde des notifications: $e',
      );
    }
  }

  Future<void> loadNotifications() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_notificationFile');

      if (!await file.exists()) {
        await BESecurityService.logSecurityEvent(
          'chargement',
          'Aucun fichier de notifications trouvé',
        );
        return;
      }

      final jsonData = await file.readAsString();
      final List<dynamic> notifications = jsonDecode(jsonData);
      _notificationHistory.clear();
      _notificationHistory
          .addAll(notifications.map((n) => n as Map<String, dynamic>));

      await BESecurityService.logSecurityEvent(
        'chargement',
        'Notifications chargées: ${_notificationHistory.length}',
      );
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors du chargement des notifications: $e',
      );
    }
  }

  List<Map<String, dynamic>> getNotificationHistory() {
    return List.from(_notificationHistory);
  }

  Future<void> clearNotifications() async {
    try {
      _notificationHistory.clear();
      await _saveNotifications();

      await BESecurityService.logSecurityEvent(
        'nettoyage',
        'Historique des notifications effacé',
      );
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de l\'effacement des notifications: $e',
      );
    }
  }

  void dispose() {
    _notificationController.close();
  }
}
