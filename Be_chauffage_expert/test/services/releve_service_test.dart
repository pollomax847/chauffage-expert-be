// test/services/releve_service_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:chauffage_expert/services/releve_service.dart';
import 'package:chauffage_expert/models/releve_technique.dart';
import '../helpers/path_provider_mock.dart';

void main() {
  late ReleveService releveService;
  late Directory tempDir;
  late String interventionId;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = MockPathProviderPlatform();
    tempDir = await getTemporaryDirectory();
    releveService = ReleveService();
    await releveService.init();
    interventionId = 'test_intervention';
  });

  tearDownAll(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('ReleveService', () {
    test('saveReleve should save releve data correctly', () async {
      final releve = ReleveTechnique(
        id: 'test_releve',
        date: DateTime.now(),
        type: ReleveType.chaudiere,
        mesures: {
          'pression': 2.0,
          'temperature': 60.0,
          'reglage': 1.0,
          'entretien': 1.0,
        },
        notes: 'Test releve',
        observations: 'Observations test',
        actions: 'Actions test',
        photos: [],
      );

      await releveService.saveReleve(releve);
      final releves = await releveService.getReleves(interventionId);
      expect(releves, contains(releve));
    });

    test('getReleves should return only releves for intervention', () async {
      final releve1 = ReleveTechnique(
        id: 'test_releve_1',
        date: DateTime.now(),
        type: ReleveType.chaudiere,
        mesures: {
          'pression': 2.0,
          'temperature': 60.0,
          'reglage': 1.0,
          'entretien': 1.0,
        },
        notes: 'Test releve 1',
        observations: 'Observations test 1',
        actions: 'Actions test 1',
        photos: [],
      );

      final releve2 = ReleveTechnique(
        id: 'test_releve_2',
        date: DateTime.now(),
        type: ReleveType.radiateur,
        mesures: {
          'pression': 1.5,
          'temperature': 55.0,
          'reglage': 0.8,
          'entretien': 0.9,
        },
        notes: 'Test releve 2',
        observations: 'Observations test 2',
        actions: 'Actions test 2',
        photos: [],
      );

      await releveService.saveReleve(releve1);
      await releveService.saveReleve(releve2);

      final releves = await releveService.getReleves(interventionId);
      expect(releves.length, 2);
      expect(releves, contains(releve1));
      expect(releves, contains(releve2));
    });

    test('deleteReleve should remove releve', () async {
      final releve = ReleveTechnique(
        id: 'test_releve',
        date: DateTime.now(),
        type: ReleveType.chaudiere,
        mesures: {
          'pression': 2.0,
          'temperature': 60.0,
          'reglage': 1.0,
          'entretien': 1.0,
        },
        notes: 'Test releve',
        observations: 'Observations test',
        actions: 'Actions test',
        photos: [],
      );

      await releveService.saveReleve(releve);
      await releveService.deleteReleve(releve.id);
      final releves = await releveService.getReleves(interventionId);
      expect(releves, isEmpty);
    });
  });
}
