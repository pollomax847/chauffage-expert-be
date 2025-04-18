// test/models/dgi_verification_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:chauffage_expert/models/dgi_verification.dart';

void main() {
  group('DGIVerification', () {
    final now = DateTime.now();
    final resultats = {
      'co_ambiant': 0.0,
      'co_fumees': 5.0,
      'tirage': 15.0,
      'temperature_fumees': 180.0,
    };

    test('should create a DGIVerification instance', () {
      final verification = DGIVerification(
        id: '1',
        date: now,
        resultats: resultats,
        conforme: true,
        notes: 'Test notes',
      );

      expect(verification.id, '1');
      expect(verification.date, now);
      expect(verification.resultats, resultats);
      expect(verification.conforme, true);
      expect(verification.notes, 'Test notes');
    });

    test('should create a DGIVerification from JSON', () {
      final json = {
        'id': '1',
        'date': now.toIso8601String(),
        'resultats': {
          'co_ambiant': 0.0,
          'co_fumees': 5.0,
          'tirage': 15.0,
          'temperature_fumees': 180.0,
        },
        'conforme': true,
        'notes': 'Test notes',
      };

      final verification = DGIVerification.fromJson(json);

      expect(verification.id, '1');
      expect(verification.date.toIso8601String(), now.toIso8601String());
      expect(verification.resultats, resultats);
      expect(verification.conforme, true);
      expect(verification.notes, 'Test notes');
    });

    test('should convert DGIVerification to JSON', () {
      final verification = DGIVerification(
        id: '1',
        date: now,
        resultats: resultats,
        conforme: true,
        notes: 'Test notes',
      );

      final json = verification.toJson();

      expect(json['id'], '1');
      expect(json['date'], now.toIso8601String());
      expect(json['resultats'], resultats);
      expect(json['conforme'], true);
      expect(json['notes'], 'Test notes');
    });

    test('should handle null optional fields', () {
      final verification = DGIVerification(
        id: '1',
        date: now,
        resultats: resultats,
        conforme: true,
      );

      expect(verification.notes, null);
    });
  });
}
