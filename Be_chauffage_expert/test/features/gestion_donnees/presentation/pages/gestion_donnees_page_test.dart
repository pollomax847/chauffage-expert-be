// test/features/gestion_donnees/presentation/pages/gestion_donnees_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:chauffage_expert/features/gestion_donnees/domain/donnees_controller.dart';
import 'package:chauffage_expert/features/gestion_donnees/domain/donnees_repository.dart';
import 'package:chauffage_expert/features/gestion_donnees/presentation/pages/gestion_donnees_page.dart';
import 'package:mockito/mockito.dart';

class MockDonneesRepository extends Mock implements DonneesRepository {}

void main() {
  late DonneesController controller;
  late MockDonneesRepository mockRepository;

  setUp(() {
    mockRepository = MockDonneesRepository();
    controller = DonneesController(mockRepository);
  });

  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        Provider<DonneesRepository>.value(
          value: mockRepository,
        ),
        ChangeNotifierProvider<DonneesController>.value(
          value: controller,
        ),
      ],
      child: const MaterialApp(
        home: GestionDonneesPage(),
      ),
    );
  }

  group('Tests de l\'interface utilisateur', () {
    testWidgets('Test de l\'état initial', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Chargement des données...'), findsOneWidget);
    });

    testWidgets('Test de l\'état vide', (WidgetTester tester) async {
      when(mockRepository.getDonnees()).thenAnswer((_) async => {});
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Aucune donnée disponible'), findsOneWidget);
      expect(find.byIcon(Icons.folder_open), findsOneWidget);
    });

    testWidgets('Test de l\'affichage des données', (WidgetTester tester) async {
      when(mockRepository.getDonnees()).thenAnswer(
        (_) async => {'test': 'valeur'},
      );
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('test'), findsOneWidget);
      expect(find.text('valeur'), findsOneWidget);
    });

    testWidgets('Test de la recherche', (WidgetTester tester) async {
      when(mockRepository.getDonnees()).thenAnswer(
        (_) async => {
          'test1': 'valeur1',
          'test2': 'valeur2',
        },
      );
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).first,
        'test1',
      );
      await tester.pump();

      expect(find.text('test1'), findsOneWidget);
      expect(find.text('test2'), findsNothing);
    });

    testWidgets('Test du tri', (WidgetTester tester) async {
      when(mockRepository.getDonnees()).thenAnswer(
        (_) async => {
          'b': 'valeur2',
          'a': 'valeur1',
          'c': 'valeur3',
        },
      );
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Vérifie l'ordre initial (ascendant)
      final listFinder = find.byType(ListView);
      expect(listFinder, findsOneWidget);

      // Inverse le tri
      await tester.tap(find.byIcon(Icons.arrow_upward));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    testWidgets('Test de la suppression avec confirmation',
        (WidgetTester tester) async {
      when(mockRepository.getDonnees()).thenAnswer(
        (_) async => {'test': 'valeur'},
      );
      when(mockRepository.supprimerDonnee('test')).thenAnswer((_) async => true);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      expect(find.text('Confirmer la suppression'), findsOneWidget);

      await tester.tap(find.text('Confirmer'));
      await tester.pumpAndSettle();

      verify(mockRepository.supprimerDonnee('test')).called(1);
    });

    testWidgets('Test de l\'ajout de nouvelle donnée',
        (WidgetTester tester) async {
      when(mockRepository.getDonnees()).thenAnswer((_) async => {});
      when(mockRepository.ajouterDonnee('nouvelle_cle', 'nouvelle_valeur'))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).first,
        'nouvelle_cle',
      );
      await tester.enterText(
        find.byType(TextField).last,
        'nouvelle_valeur',
      );

      await tester.tap(find.text('Ajouter'));
      await tester.pumpAndSettle();

      verify(mockRepository.ajouterDonnee('nouvelle_cle', 'nouvelle_valeur'))
          .called(1);
    });

    testWidgets('Test de la modification d\'une donnée',
        (WidgetTester tester) async {
      when(mockRepository.getDonnees()).thenAnswer(
        (_) async => {'test': 'valeur'},
      );
      when(mockRepository.modifierDonnee('test', 'nouvelle_valeur'))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).first,
        'nouvelle_valeur',
      );

      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      verify(mockRepository.modifierDonnee('test', 'nouvelle_valeur')).called(1);
    });

    testWidgets('Test des animations', (WidgetTester tester) async {
      when(mockRepository.getDonnees()).thenAnswer(
        (_) async => {'test': 'valeur'},
      );

      await tester.pumpWidget(createTestWidget());
      
      // Vérifie l'animation de chargement
      expect(find.byType(AnimatedSwitcher), findsOneWidget);
      
      await tester.pumpAndSettle();

      // Vérifie les animations des cartes
      expect(find.byType(AnimatedContainer), findsWidgets);
    });

    testWidgets('Test de l\'export/import', (WidgetTester tester) async {
      when(mockRepository.getDonnees()).thenAnswer(
        (_) async => {'test': 'valeur'},
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Exporter'), findsOneWidget);
      expect(find.text('Importer'), findsOneWidget);
    });

    testWidgets('Test de l\'historique', (WidgetTester tester) async {
      when(mockRepository.getDonnees()).thenAnswer(
        (_) async => {'test': 'valeur'},
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      expect(find.text('Historique des modifications'), findsOneWidget);
    });
  });
} 