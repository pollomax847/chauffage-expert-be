// test/features/gestion_donnees/presentation/controllers/donnees_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:chauffage_expert/features/gestion_donnees/data/donnees_repository.dart';
import 'package:chauffage_expert/features/gestion_donnees/domain/models/donnees_model.dart';
import 'package:chauffage_expert/features/gestion_donnees/presentation/controllers/donnees_controller.dart';

@GenerateMocks([DonneesRepository])
import 'donnees_controller_test.mocks.dart';

void main() {
  late MockDonneesRepository mockRepository;
  late DonneesController controller;
  late DateTime maintenant;
  late Map<String, dynamic> donneesMock;

  setUp(() {
    mockRepository = MockDonneesRepository();
    controller = DonneesController(mockRepository);
    maintenant = DateTime(2024, 3, 20, 12, 0);
    donneesMock = {
      'id': 'test-123',
      'nom': 'Test Données',
      'dateCreation': maintenant.toIso8601String(),
      'dateModification': maintenant.toIso8601String(),
      'contenu': {'cle': 'valeur'}
    };
  });

  group('DonneesController', () {
    test('devrait initialiser avec des valeurs par défaut', () {
      expect(controller.isLoading, isFalse);
      expect(controller.error, isNull);
      expect(controller.donneesCourantes, isNull);
    });

    test('devrait charger les données avec succès', () async {
      when(mockRepository.chargerDonnees())
          .thenAnswer((_) async => donneesMock);

      await controller.chargerDonnees();

      verify(mockRepository.chargerDonnees()).called(1);
      expect(controller.isLoading, isFalse);
      expect(controller.error, isNull);
      expect(controller.donneesCourantes?.id, equals('test-123'));
    });

    test('devrait gérer une erreur lors du chargement', () async {
      when(mockRepository.chargerDonnees())
          .thenThrow(Exception('Erreur test'));

      await controller.chargerDonnees();

      verify(mockRepository.chargerDonnees()).called(1);
      expect(controller.isLoading, isFalse);
      expect(controller.error, contains('Erreur test'));
      expect(controller.donneesCourantes, isNull);
    });

    test('devrait sauvegarder les données avec succès', () async {
      final donnees = DonneesModel.fromJson(donneesMock);
      when(mockRepository.sauvegarderDonnees(any))
          .thenAnswer((_) async {});

      await controller.sauvegarderDonnees(donnees);

      verify(mockRepository.sauvegarderDonnees(donneesMock)).called(1);
      expect(controller.isLoading, isFalse);
      expect(controller.error, isNull);
      expect(controller.donneesCourantes, equals(donnees));
    });

    test('devrait supprimer les données avec succès', () async {
      when(mockRepository.supprimerDonnees())
          .thenAnswer((_) async {});

      await controller.supprimerDonnees();

      verify(mockRepository.supprimerDonnees()).called(1);
      expect(controller.isLoading, isFalse);
      expect(controller.error, isNull);
      expect(controller.donneesCourantes, isNull);
    });
  });
} 