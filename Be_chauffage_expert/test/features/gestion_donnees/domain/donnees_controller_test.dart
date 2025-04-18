// test/features/gestion_donnees/domain/donnees_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:chauffage_expert/features/gestion_donnees/domain/donnees_repository.dart';
import 'package:chauffage_expert/features/gestion_donnees/domain/donnees_controller.dart';

class MockDonneesRepository extends Mock implements DonneesRepository {}

void main() {
  late DonneesController controller;
  late MockDonneesRepository mockRepository;

  setUp(() {
    mockRepository = MockDonneesRepository();
    controller = DonneesController(mockRepository);
  });

  group('DonneesController', () {
    test('état initial est correct', () {
      expect(controller.donnees, isEmpty);
      expect(controller.isLoading, false);
      expect(controller.searchQuery, isEmpty);
      expect(controller.sortAscending, true);
    });

    test('chargerDonnees met à jour l\'état correctement', () async {
      when(mockRepository.getDonnees()).thenAnswer(
        (_) async => {'test1': 'valeur1', 'test2': 'valeur2'},
      );

      await controller.chargerDonnees();

      expect(controller.donnees, {'test1': 'valeur1', 'test2': 'valeur2'});
      expect(controller.isLoading, false);
    });

    test('chargerDonnees gère les erreurs', () async {
      when(mockRepository.getDonnees()).thenThrow(Exception('Erreur test'));

      await controller.chargerDonnees();

      expect(controller.donnees, isEmpty);
      expect(controller.isLoading, false);
    });

    test('ajouterDonnee ajoute une nouvelle donnée', () async {
      when(mockRepository.ajouterDonnee('test', 'valeur'))
          .thenAnswer((_) async => true);

      final resultat = await controller.ajouterDonnee('test', 'valeur');

      expect(resultat, true);
      expect(controller.donnees['test'], 'valeur');
    });

    test('modifierDonnee modifie une donnée existante', () async {
      when(mockRepository.modifierDonnee('test', 'nouvelle_valeur'))
          .thenAnswer((_) async => true);

      final resultat = await controller.modifierDonnee('test', 'nouvelle_valeur');

      expect(resultat, true);
      expect(controller.donnees['test'], 'nouvelle_valeur');
    });

    test('supprimerDonnee supprime une donnée', () async {
      controller = DonneesController(mockRepository)
        .._donnees = {'test': 'valeur'};

      when(mockRepository.supprimerDonnee('test'))
          .thenAnswer((_) async => true);

      final resultat = await controller.supprimerDonnee('test');

      expect(resultat, true);
      expect(controller.donnees['test'], isNull);
    });

    test('setSearchQuery met à jour la requête de recherche', () {
      controller.setSearchQuery('test');
      expect(controller.searchQuery, 'test');
    });

    test('toggleSort inverse l\'ordre de tri', () {
      expect(controller.sortAscending, true);
      controller.toggleSort();
      expect(controller.sortAscending, false);
    });

    group('donneesFiltrees', () {
      setUp(() {
        controller = DonneesController(mockRepository)
          .._donnees = {
            'abc': 'valeur1',
            'def': 'valeur2',
            'ghi': 'test3',
          };
      });

      test('filtre les données selon la recherche', () {
        controller.setSearchQuery('test');
        
        final resultat = controller.donneesFiltrees;
        expect(resultat.length, 1);
        expect(resultat['ghi'], 'test3');
      });

      test('trie les données en ordre ascendant', () {
        final resultat = controller.donneesFiltrees.keys.toList();
        expect(resultat, ['abc', 'def', 'ghi']);
      });

      test('trie les données en ordre descendant', () {
        controller.toggleSort();
        final resultat = controller.donneesFiltrees.keys.toList();
        expect(resultat, ['ghi', 'def', 'abc']);
      });
    });
  });
} 