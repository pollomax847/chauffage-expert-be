// test/features/gestion_donnees/domain/donnees_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chauffage_expert/features/gestion_donnees/domain/donnees_repository.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late DonneesRepository repository;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    repository = DonneesRepository(prefs: mockPrefs);
  });

  group('DonneesRepository', () {
    test('getDonnees retourne une Map vide quand aucune donnée n\'existe', () async {
      when(mockPrefs.getKeys()).thenReturn({});

      final resultat = await repository.getDonnees();

      expect(resultat, isEmpty);
    });

    test('getDonnees retourne les données correctement', () async {
      when(mockPrefs.getKeys()).thenReturn({'test1', 'test2'});
      when(mockPrefs.getString('test1')).thenReturn('valeur1');
      when(mockPrefs.getString('test2')).thenReturn('valeur2');

      final resultat = await repository.getDonnees();

      expect(resultat, {
        'test1': 'valeur1',
        'test2': 'valeur2',
      });
    });

    test('ajouterDonnee ajoute une nouvelle donnée', () async {
      when(mockPrefs.setString('test', 'valeur')).thenAnswer((_) async => true);

      final resultat = await repository.ajouterDonnee('test', 'valeur');

      expect(resultat, true);
      verify(mockPrefs.setString('test', 'valeur')).called(1);
    });

    test('modifierDonnee modifie une donnée existante', () async {
      when(mockPrefs.setString('test', 'nouvelle_valeur'))
          .thenAnswer((_) async => true);

      final resultat = await repository.modifierDonnee('test', 'nouvelle_valeur');

      expect(resultat, true);
      verify(mockPrefs.setString('test', 'nouvelle_valeur')).called(1);
    });

    test('supprimerDonnee supprime une donnée', () async {
      when(mockPrefs.remove('test')).thenAnswer((_) async => true);

      final resultat = await repository.supprimerDonnee('test');

      expect(resultat, true);
      verify(mockPrefs.remove('test')).called(1);
    });

    test('viderDonnees efface toutes les données', () async {
      when(mockPrefs.clear()).thenAnswer((_) async => true);

      await repository.viderDonnees();

      verify(mockPrefs.clear()).called(1);
    });
  });
} 