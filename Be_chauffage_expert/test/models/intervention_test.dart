// test/models/intervention_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:chauffage_expert/models/intervention.dart';
import 'package:chauffage_expert/models/photo_data.dart';
import 'package:chauffage_expert/models/releve_technique.dart';

void main() {
  group('Intervention', () {
    final now = DateTime.now();
    final photos = <PhotoData>[];
    final releves = <ReleveTechnique>[];

    test('should create an Intervention instance', () {
      final intervention = Intervention(
        id: '1',
        clientId: 'client1',
        equipmentId: 'equipment1',
        date: now,
        type: InterventionType.maintenance,
        status: InterventionStatus.terminee,
        description: 'Test intervention',
        photos: photos,
        releves: releves,
        duree: 2.5,
        cout: 150.0,
        notes: 'Test notes',
      );

      expect(intervention.id, '1');
      expect(intervention.clientId, 'client1');
      expect(intervention.equipmentId, 'equipment1');
      expect(intervention.date, now);
      expect(intervention.type, InterventionType.maintenance);
      expect(intervention.status, InterventionStatus.terminee);
      expect(intervention.description, 'Test intervention');
      expect(intervention.photos, photos);
      expect(intervention.releves, releves);
      expect(intervention.duree, 2.5);
      expect(intervention.cout, 150.0);
      expect(intervention.notes, 'Test notes');
    });

    test('should create an Intervention from JSON', () {
      final json = {
        'id': '1',
        'clientId': 'client1',
        'equipmentId': 'equipment1',
        'date': now.toIso8601String(),
        'type': 'maintenance',
        'status': 'terminee',
        'description': 'Test intervention',
        'photos': [],
        'releves': [],
        'duree': 2.5,
        'cout': 150.0,
        'notes': 'Test notes',
      };

      final intervention = Intervention.fromJson(json);

      expect(intervention.id, '1');
      expect(intervention.clientId, 'client1');
      expect(intervention.equipmentId, 'equipment1');
      expect(intervention.date.toIso8601String(), now.toIso8601String());
      expect(intervention.type, InterventionType.maintenance);
      expect(intervention.status, InterventionStatus.terminee);
      expect(intervention.description, 'Test intervention');
      expect(intervention.photos, isEmpty);
      expect(intervention.releves, isEmpty);
      expect(intervention.duree, 2.5);
      expect(intervention.cout, 150.0);
      expect(intervention.notes, 'Test notes');
    });

    test('should convert Intervention to JSON', () {
      final intervention = Intervention(
        id: '1',
        clientId: 'client1',
        equipmentId: 'equipment1',
        date: now,
        type: InterventionType.maintenance,
        status: InterventionStatus.terminee,
        description: 'Test intervention',
        photos: photos,
        releves: releves,
        duree: 2.5,
        cout: 150.0,
        notes: 'Test notes',
      );

      final json = intervention.toJson();

      expect(json['id'], '1');
      expect(json['clientId'], 'client1');
      expect(json['equipmentId'], 'equipment1');
      expect(json['date'], now.toIso8601String());
      expect(json['type'], 'maintenance');
      expect(json['status'], 'terminee');
      expect(json['description'], 'Test intervention');
      expect(json['photos'], isEmpty);
      expect(json['releves'], isEmpty);
      expect(json['duree'], 2.5);
      expect(json['cout'], 150.0);
      expect(json['notes'], 'Test notes');
    });

    test('should handle null notes', () {
      final intervention = Intervention(
        id: '1',
        clientId: 'client1',
        equipmentId: 'equipment1',
        date: now,
        type: InterventionType.maintenance,
        status: InterventionStatus.terminee,
        description: 'Test intervention',
        photos: photos,
        releves: releves,
        duree: 2.5,
        cout: 150.0,
      );

      expect(intervention.notes, null);
    });
  });
} 