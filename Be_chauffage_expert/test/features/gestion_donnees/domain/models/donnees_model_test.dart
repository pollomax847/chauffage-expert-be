// test/features/gestion_donnees/domain/models/donnees_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:chauffage_expert/features/gestion_donnees/domain/models/donnees_model.dart';

void main() {
  group('DonneesModel', () {
    final DateTime maintenant = DateTime(2024, 3, 20, 12, 0);
    final Map<String, dynamic> donneesMock = {
      'id': 'test-123',
      'nom': 'Test Données',
      'dateCreation': maintenant.toIso8601String(),
      'dateModification': maintenant.toIso8601String(),
      'contenu': {'cle': 'valeur'}
    };

    test('devrait créer une instance à partir de JSON', () {
      final model = DonneesModel.fromJson(donneesMock);

      expect(model.id, equals('test-123'));
      expect(model.nom, equals('Test Données'));
      expect(model.dateCreation, equals(maintenant));
      expect(model.dateModification, equals(maintenant));
      expect(model.contenu, equals({'cle': 'valeur'}));
    });

    test('devrait convertir en JSON correctement', () {
      final model = DonneesModel(
        id: 'test-123',
        nom: 'Test Données',
        dateCreation: maintenant,
        dateModification: maintenant,
        contenu: {'cle': 'valeur'},
      );

      final json = model.toJson();
      
      expect(json, equals(donneesMock));
    });

    test('devrait créer une copie avec modifications', () {
      final model = DonneesModel.fromJson(donneesMock);
      final nouveauNom = 'Nouveau Nom';
      final copie = model.copyWith(nom: nouveauNom);

      expect(copie.id, equals(model.id));
      expect(copie.nom, equals(nouveauNom));
      expect(copie.dateCreation, equals(model.dateCreation));
      expect(copie.dateModification, equals(model.dateModification));
      expect(copie.contenu, equals(model.contenu));
    });

    test('devrait lever une exception pour un JSON invalide', () {
      final jsonInvalide = {
        'id': 'test-123',
        'nom': 'Test Données',
        'dateCreation': 'date invalide',
        'dateModification': maintenant.toIso8601String(),
        'contenu': {'cle': 'valeur'}
      };

      expect(
        () => DonneesModel.fromJson(jsonInvalide),
        throwsA(isA<FormatException>()),
      );
    });
  });
} 