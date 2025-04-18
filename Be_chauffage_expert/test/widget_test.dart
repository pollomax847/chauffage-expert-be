// test/widget_test.dart
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memo_chaudiere/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tests de l\'application Mémo Chaudière', () {
    testWidgets('Test de base de l\'application', (WidgetTester tester) async {
      // Construire notre application et déclencher une frame
      await tester.pumpWidget(const MyApp(isDarkMode: false));

      // Vérifier que l'application se lance correctement
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Test de la page d\'accueil', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(isDarkMode: false));

      // Vérifier la présence des éléments principaux
      expect(find.text('Mémo Chaudière'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Test de la navigation vers le contrôle gaz',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(isDarkMode: false));

      // Simuler un tap sur le bouton de contrôle gaz
      await tester.tap(find.text('Contrôle Gaz'));
      await tester.pumpAndSettle();

      // Vérifier que nous sommes sur la page de contrôle gaz
      expect(find.text('Contrôle Gaz'), findsOneWidget);
    });

    testWidgets('Test de la prise de photos', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(isDarkMode: false));

      // Naviguer vers la page de contrôle gaz
      await tester.tap(find.text('Contrôle Gaz'));
      await tester.pumpAndSettle();

      // Vérifier la présence du bouton de prise de photo
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets('Test de la validation des formulaires',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(isDarkMode: false));

      // Naviguer vers la page de contrôle gaz
      await tester.tap(find.text('Contrôle Gaz'));
      await tester.pumpAndSettle();

      // Vérifier la présence des champs de formulaire
      expect(find.byType(TextFormField), findsWidgets);
    });
  });
}
