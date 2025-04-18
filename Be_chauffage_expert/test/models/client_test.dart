// test/models/client_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:chauffage_expert/models/client.dart';

void main() {
  group('Client', () {
    test('should create a Client instance', () {
      const client = Client(
        id: '1',
        nom: 'John Doe',
        adresse: '123 Main St',
        codePostal: '75000',
        ville: 'Paris',
        telephone: '0123456789',
        email: 'john@example.com',
        notes: 'Test notes',
      );

      expect(client.id, '1');
      expect(client.nom, 'John Doe');
      expect(client.adresse, '123 Main St');
      expect(client.codePostal, '75000');
      expect(client.ville, 'Paris');
      expect(client.telephone, '0123456789');
      expect(client.email, 'john@example.com');
      expect(client.notes, 'Test notes');
    });

    test('should create a Client from JSON', () {
      final json = {
        'id': '1',
        'nom': 'John Doe',
        'adresse': '123 Main St',
        'codePostal': '75000',
        'ville': 'Paris',
        'telephone': '0123456789',
        'email': 'john@example.com',
        'notes': 'Test notes',
      };

      final client = Client.fromJson(json);

      expect(client.id, '1');
      expect(client.nom, 'John Doe');
      expect(client.adresse, '123 Main St');
      expect(client.codePostal, '75000');
      expect(client.ville, 'Paris');
      expect(client.telephone, '0123456789');
      expect(client.email, 'john@example.com');
      expect(client.notes, 'Test notes');
    });

    test('should convert Client to JSON', () {
      const client = Client(
        id: '1',
        nom: 'John Doe',
        adresse: '123 Main St',
        codePostal: '75000',
        ville: 'Paris',
        telephone: '0123456789',
        email: 'john@example.com',
        notes: 'Test notes',
      );

      final json = client.toJson();

      expect(json['id'], '1');
      expect(json['nom'], 'John Doe');
      expect(json['adresse'], '123 Main St');
      expect(json['codePostal'], '75000');
      expect(json['ville'], 'Paris');
      expect(json['telephone'], '0123456789');
      expect(json['email'], 'john@example.com');
      expect(json['notes'], 'Test notes');
    });

    test('should handle null notes', () {
      const client = Client(
        id: '1',
        nom: 'John Doe',
        adresse: '123 Main St',
        codePostal: '75000',
        ville: 'Paris',
        telephone: '0123456789',
        email: 'john@example.com',
      );

      expect(client.notes, null);
    });
  });
}
