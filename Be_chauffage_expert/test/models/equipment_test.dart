// test/models/equipment_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:chauffage_expert/models/equipment.dart';

void main() {
  group('Equipment', () {
    final now = DateTime.now();

    test('should create an Equipment instance', () {
      final equipment = Equipment(
        id: '1',
        name: 'Chaudière Test',
        brand: 'Test Brand',
        model: 'Test Model',
        serialNumber: '123456',
        installationDate: now,
        lastMaintenanceDate: now,
        power: 24.0,
        type: 'chaudiere',
        isConforme: true,
        parameters: {'param1': 'value1'},
        notes: 'Test notes',
      );

      expect(equipment.id, '1');
      expect(equipment.name, 'Chaudière Test');
      expect(equipment.brand, 'Test Brand');
      expect(equipment.model, 'Test Model');
      expect(equipment.serialNumber, '123456');
      expect(equipment.installationDate, now);
      expect(equipment.lastMaintenanceDate, now);
      expect(equipment.power, 24.0);
      expect(equipment.type, 'chaudiere');
      expect(equipment.isConforme, true);
      expect(equipment.parameters, {'param1': 'value1'});
      expect(equipment.notes, 'Test notes');
    });

    test('should create an Equipment from JSON', () {
      final json = {
        'id': '1',
        'name': 'Chaudière Test',
        'brand': 'Test Brand',
        'model': 'Test Model',
        'serialNumber': '123456',
        'installationDate': now.toIso8601String(),
        'lastMaintenanceDate': now.toIso8601String(),
        'power': 24.0,
        'type': 'chaudiere',
        'isConforme': true,
        'parameters': {'param1': 'value1'},
        'notes': 'Test notes',
      };

      final equipment = Equipment.fromJson(json);

      expect(equipment.id, '1');
      expect(equipment.name, 'Chaudière Test');
      expect(equipment.brand, 'Test Brand');
      expect(equipment.model, 'Test Model');
      expect(equipment.serialNumber, '123456');
      expect(equipment.installationDate.toIso8601String(), now.toIso8601String());
      expect(equipment.lastMaintenanceDate.toIso8601String(), now.toIso8601String());
      expect(equipment.power, 24.0);
      expect(equipment.type, 'chaudiere');
      expect(equipment.isConforme, true);
      expect(equipment.parameters, {'param1': 'value1'});
      expect(equipment.notes, 'Test notes');
    });

    test('should convert Equipment to JSON', () {
      final equipment = Equipment(
        id: '1',
        name: 'Chaudière Test',
        brand: 'Test Brand',
        model: 'Test Model',
        serialNumber: '123456',
        installationDate: now,
        lastMaintenanceDate: now,
        power: 24.0,
        type: 'chaudiere',
        isConforme: true,
        parameters: {'param1': 'value1'},
        notes: 'Test notes',
      );

      final json = equipment.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Chaudière Test');
      expect(json['brand'], 'Test Brand');
      expect(json['model'], 'Test Model');
      expect(json['serialNumber'], '123456');
      expect(json['installationDate'], now.toIso8601String());
      expect(json['lastMaintenanceDate'], now.toIso8601String());
      expect(json['power'], 24.0);
      expect(json['type'], 'chaudiere');
      expect(json['isConforme'], true);
      expect(json['parameters'], {'param1': 'value1'});
      expect(json['notes'], 'Test notes');
    });

    test('should handle null optional fields', () {
      final equipment = Equipment(
        id: '1',
        name: 'Chaudière Test',
        brand: 'Test Brand',
        model: 'Test Model',
        serialNumber: '123456',
        installationDate: now,
        lastMaintenanceDate: now,
        power: 24.0,
        type: 'chaudiere',
        isConforme: true,
      );

      expect(equipment.parameters, null);
      expect(equipment.notes, null);
    });
  });
} 