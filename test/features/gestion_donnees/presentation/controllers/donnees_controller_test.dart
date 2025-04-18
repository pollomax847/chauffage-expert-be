// test/features/gestion_donnees/presentation/controllers/donnees_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chauffage_expert/features/gestion_donnees/domain/repositories/donnees_repository.dart';
import 'package:chauffage_expert/features/gestion_donnees/presentation/controllers/donnees_controller.dart';

class MockDonneesRepository extends Mock implements DonneesRepository {}

void main() {
  late DonneesController controller;
  late MockDonneesRepository mockRepository;

  setUp(() {
    mockRepository = MockDonneesRepository();
    controller = DonneesController(mockRepository);
  });

  group('DonneesController', () {
    test('sauvegarderDonnees appelle le repository', () async {
      final donnees = {'test': 'data'};
      when(() => mockRepository.sauvegarderDonnees(donnees))
          .thenAnswer((_) async => true);

      await controller.sauvegarderDonnees(donnees);

      verify(() => mockRepository.sauvegarderDonnees(donnees)).called(1);
    });

    test('chargerDonnees appelle le repository', () async {
      final donnees = {'test': 'data'};
      when(() => mockRepository.chargerDonnees())
          .thenAnswer((_) async => donnees);

      final result = await controller.chargerDonnees();

      expect(result, donnees);
      verify(() => mockRepository.chargerDonnees()).called(1);
    });

    test('supprimerDonnees appelle le repository', () async {
      const id = 'test-id';
      when(() => mockRepository.supprimerDonnees(id))
          .thenAnswer((_) async => true);

      await controller.supprimerDonnees(id);

      verify(() => mockRepository.supprimerDonnees(id)).called(1);
    });

    test('obtenirHistorique appelle le repository', () async {
      final historique = [{'test': 'data'}];
      when(() => mockRepository.obtenirHistorique())
          .thenAnswer((_) async => historique);

      final result = await controller.obtenirHistorique();

      expect(result, historique);
      verify(() => mockRepository.obtenirHistorique()).called(1);
    });
  });
} 