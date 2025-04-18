// test/integration/gas_regulation_integration_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../lib/screens/standalone_gas_regulation_screen.dart';
import '../../lib/services/gas_regulation_service.dart';
import '../../lib/config/firebase_config.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.init();

  late GasRegulationService service;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  setUp(() async {
    service = GasRegulationService();
  });

  test('Test d\'intégration - Débit ECS et Relevés techniques', () async {
    // 1. Test du débit ECS
    final debitEcs = {
      'temperatureEntree': 10.0,
      'temperatureSortie': 60.0,
      'debit': 2.5,
      'date': DateTime.now(),
    };

    await firestore.collection('debits_ecs').add(debitEcs);

    // Vérification du débit ECS
    final debitSnapshot = await firestore
        .collection('debits_ecs')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    expect(debitSnapshot.docs.isNotEmpty, true);
    expect(debitSnapshot.docs.first.data()['debit'], 2.5);

    // 2. Test de la réglementation gaz
    final regulation = {
      'clientName': 'Test Client',
      'address': 'Test Address',
      'technicianName': 'Test Technician',
      'date': DateTime.now(),
      'observations': 'Test Observations',
      'conclusion': 'Test Conclusion',
      'isVentilationOk': true,
      'isCombustionOk': true,
      'isInstallationOk': true,
      'isPressureOk': true,
      'isLeakageOk': true,
      'co2Value': 10.0,
      'o2Value': 20.0,
      'coValue': 30.0,
      'temperatureValue': 40.0,
      'pressureValue': 50.0,
    };

    await firestore.collection('gas_regulations').add(regulation);

    // Vérification de la réglementation
    final regulationSnapshot = await firestore
        .collection('gas_regulations')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    expect(regulationSnapshot.docs.isNotEmpty, true);
    expect(regulationSnapshot.docs.first.data()['clientName'], 'Test Client');

    // 3. Test des relevés techniques
    final releve = {
      'type': 'Relevé technique',
      'date': DateTime.now(),
      'technicianName': 'Test Technician',
      'observations': 'Test Observations',
      'mesures': {
        'pression': 1.5,
        'temperature': 65.0,
        'debit': 2.0,
      },
      'photos': ['photo1.jpg', 'photo2.jpg'],
    };

    await firestore.collection('releves_techniques').add(releve);

    // Vérification du relevé technique
    final releveSnapshot = await firestore
        .collection('releves_techniques')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    expect(releveSnapshot.docs.isNotEmpty, true);
    expect(releveSnapshot.docs.first.data()['type'], 'Relevé technique');
  });

  testWidgets('Test d\'intégration - Interface utilisateur',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StandaloneGasRegulationScreen(),
      ),
    );

    // Test de la saisie des mesures
    await tester.enterText(find.byType(TextFormField).at(0), 'Test Client');
    await tester.enterText(find.byType(TextFormField).at(1), 'Test Address');
    await tester.enterText(find.byType(TextFormField).at(2), 'Test Technician');
    await tester.enterText(
        find.byType(TextFormField).at(3), 'Test Observations');
    await tester.enterText(find.byType(TextFormField).at(4), 'Test Conclusion');

    // Test des mesures techniques
    await tester.enterText(find.byType(TextFormField).at(5), '10.0'); // CO2
    await tester.enterText(find.byType(TextFormField).at(6), '20.0'); // O2
    await tester.enterText(find.byType(TextFormField).at(7), '30.0'); // CO
    await tester.enterText(
        find.byType(TextFormField).at(8), '40.0'); // Température
    await tester.enterText(
        find.byType(TextFormField).at(9), '50.0'); // Pression

    // Test de l'enregistrement
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    // Vérification de l'enregistrement dans Firebase
    final snapshot = await firestore
        .collection('gas_regulations')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    expect(snapshot.docs.isNotEmpty, true);
    expect(snapshot.docs.first.data()['clientName'], 'Test Client');
    expect(snapshot.docs.first.data()['co2Value'], 10.0);
  });
}
