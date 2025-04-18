// test/models/calcul_puissance_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:chauffage_expert/models/calcul_puissance.dart';

void main() {
  group('CalculPuissance', () {
    final now = DateTime.now();
    final parametres = {
      'surface': 120.0,
      'hauteur': 2.5,
      'isolation': 'moyenne',
      'region': 'H1',
      'temperature_exterieure': -7.0,
      'temperature_interieure': 19.0,
    };

    test('should create a CalculPuissance instance', () {
      final calcul = CalculPuissance(
        id: '1',
        date: now,
        parametres: parametres,
        puissance_calculee: 8500.0,
        notes: 'Test notes',
      );

      expect(calcul.id, '1');
      expect(calcul.date, now);
      expect(calcul.parametres, parametres);
      expect(calcul.puissance_calculee, 8500.0);
      expect(calcul.notes, 'Test notes');
    });

    test('should create a CalculPuissance from JSON', () {
      final json = {
        'id': '1',
        'date': now.toIso8601String(),
        'parametres': {
          'surface': 120.0,
          'hauteur': 2.5,
          'isolation': 'moyenne',
          'region': 'H1',
          'temperature_exterieure': -7.0,
          'temperature_interieure': 19.0,
        },
        'puissance_calculee': 8500.0,
        'notes': 'Test notes',
      };

      final calcul = CalculPuissance.fromJson(json);

      expect(calcul.id, '1');
      expect(calcul.date.toIso8601String(), now.toIso8601String());
      expect(calcul.parametres, parametres);
      expect(calcul.puissance_calculee, 8500.0);
      expect(calcul.notes, 'Test notes');
    });

    test('should convert CalculPuissance to JSON', () {
      final calcul = CalculPuissance(
        id: '1',
        date: now,
        parametres: parametres,
        puissance_calculee: 8500.0,
        notes: 'Test notes',
      );

      final json = calcul.toJson();

      expect(json['id'], '1');
      expect(json['date'], now.toIso8601String());
      expect(json['parametres'], parametres);
      expect(json['puissance_calculee'], 8500.0);
      expect(json['notes'], 'Test notes');
    });

    test('should handle null optional fields', () {
      final calcul = CalculPuissance(
        id: '1',
        date: now,
        parametres: parametres,
        puissance_calculee: 8500.0,
      );

      expect(calcul.notes, null);
    });
  });
}
