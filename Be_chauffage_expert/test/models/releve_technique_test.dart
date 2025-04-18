// test/models/releve_technique_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:chauffage_expert/models/releve_technique.dart';

void main() {
  group('ReleveTechnique', () {
    final now = DateTime.now();
    final mesures = {
      'temperature': 75.5,
      'pression': 2.5,
      'debit': 15.0,
    };

    test('should create a ReleveTechnique instance', () {
      final releve = ReleveTechnique(
        id: '1',
        date: now,
        type: ReleveType.chaudiere,
        mesures: mesures,
        notes: 'Test notes',
      );

      expect(releve.id, '1');
      expect(releve.date, now);
      expect(releve.type, ReleveType.chaudiere);
      expect(releve.mesures, mesures);
      expect(releve.notes, 'Test notes');
    });

    test('should create a ReleveTechnique from JSON', () {
      final json = {
        'id': '1',
        'date': now.toIso8601String(),
        'type': 'chaudiere',
        'mesures': {
          'temperature': 75.5,
          'pression': 2.5,
          'debit': 15.0,
        },
        'notes': 'Test notes',
      };

      final releve = ReleveTechnique.fromJson(json);

      expect(releve.id, '1');
      expect(releve.date.toIso8601String(), now.toIso8601String());
      expect(releve.type, ReleveType.chaudiere);
      expect(releve.mesures, mesures);
      expect(releve.notes, 'Test notes');
    });

    test('should convert ReleveTechnique to JSON', () {
      final releve = ReleveTechnique(
        id: '1',
        date: now,
        type: ReleveType.chaudiere,
        mesures: mesures,
        notes: 'Test notes',
      );

      final json = releve.toJson();

      expect(json['id'], '1');
      expect(json['date'], now.toIso8601String());
      expect(json['type'], 'chaudiere');
      expect(json['mesures'], mesures);
      expect(json['notes'], 'Test notes');
    });

    test('should handle null optional fields', () {
      final releve = ReleveTechnique(
        id: '1',
        date: now,
        type: ReleveType.chaudiere,
        mesures: mesures,
      );

      expect(releve.notes, null);
    });
  });
}
