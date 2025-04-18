// test/screens/standalone_gas_regulation_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../lib/screens/standalone_gas_regulation_screen.dart';
import '../../lib/services/gas_regulation_service.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Test de l\'interface utilisateur', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StandaloneGasRegulationScreen(),
      ),
    );

    // Vérification des champs obligatoires
    expect(find.text('Nom du client'), findsOneWidget);
    expect(find.text('Adresse'), findsOneWidget);
    expect(find.text('Nom du technicien'), findsOneWidget);

    // Test de la validation des champs vides
    await tester.tap(find.text('Enregistrer'));
    await tester.pump();
    expect(find.text('Veuillez entrer le nom du client'), findsOneWidget);
    expect(find.text('Veuillez entrer l\'adresse'), findsOneWidget);
    expect(find.text('Veuillez entrer le nom du technicien'), findsOneWidget);

    // Remplissage des champs
    await tester.enterText(find.byType(TextFormField).at(0), 'Test Client');
    await tester.enterText(find.byType(TextFormField).at(1), 'Test Address');
    await tester.enterText(find.byType(TextFormField).at(2), 'Test Technician');
    await tester.enterText(
        find.byType(TextFormField).at(3), 'Test Observations');
    await tester.enterText(find.byType(TextFormField).at(4), 'Test Conclusion');

    // Test des cases à cocher
    await tester.tap(find.byType(CheckboxListTile).at(0));
    await tester.tap(find.byType(CheckboxListTile).at(1));
    await tester.pump();

    // Test des champs de mesure
    await tester.enterText(find.byType(TextFormField).at(5), '10.0');
    await tester.enterText(find.byType(TextFormField).at(6), '20.0');
    await tester.enterText(find.byType(TextFormField).at(7), '30.0');
    await tester.enterText(find.byType(TextFormField).at(8), '40.0');
    await tester.enterText(find.byType(TextFormField).at(9), '50.0');

    // Test de l'enregistrement
    await tester.tap(find.text('Enregistrer'));
    await tester.pump();

    // Vérification du message de succès
    expect(find.text('Réglementation gaz enregistrée avec succès'),
        findsOneWidget);
  });
}
