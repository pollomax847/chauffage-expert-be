// test/services/calcul_service_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:path/path.dart' as path;
import 'package:chauffage_expert/services/calcul_service.dart';
import 'package:chauffage_expert/models/calcul_puissance.dart';
import '../helpers/path_provider_mock.dart';

void main() {
  late CalculService calculService;
  late Directory tempDir;
  late String interventionId;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = MockPathProviderPlatform();
    tempDir = await getTemporaryDirectory();
    calculService = CalculService();
    await calculService.init();
    interventionId = 'test_intervention';
  });

  setUp(() async {
    // Nettoyer le répertoire des calculs avant chaque test
    final calculDir = Directory('${tempDir.path}/calculs');
    if (await calculDir.exists()) {
      await calculDir.delete(recursive: true);
    }
    await calculDir.create(recursive: true);
  });

  tearDownAll(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('CalculService', () {
    test('saveCalcul should save calculation data correctly', () async {
      final calcul = CalculPuissance(
        id: 'test_calcul',
        date: DateTime.now(),
        parametres: {
          'surface': 20.0,
          'hauteur': 2.5,
          'temperature': 20.0,
          'type': TypePiece.zoneJour.toString(),
        },
        puissance_calculee: 2000.0,
        notes: 'Test calcul',
      );

      await calculService.saveCalcul(calcul, interventionId);
      final calculs = await calculService.getCalculs(interventionId);
      expect(calculs.length, 1);
      expect(calculs.first.id, calcul.id);
    });

    test('getCalculs should return only calculations for intervention',
        () async {
      final calcul1 = CalculPuissance(
        id: 'test_calcul_1',
        date: DateTime.now(),
        parametres: {
          'surface': 20.0,
          'hauteur': 2.5,
          'temperature': 20.0,
          'type': TypePiece.zoneJour.toString(),
        },
        puissance_calculee: 2000.0,
        notes: 'Test calcul 1',
      );

      final calcul2 = CalculPuissance(
        id: 'test_calcul_2',
        date: DateTime.now(),
        parametres: {
          'surface': 15.0,
          'hauteur': 2.5,
          'temperature': 20.0,
          'type': TypePiece.cuisine.toString(),
        },
        puissance_calculee: 1500.0,
        notes: 'Test calcul 2',
      );

      await calculService.saveCalcul(calcul1, interventionId);
      await calculService.saveCalcul(calcul2, interventionId);

      final calculs = await calculService.getCalculs(interventionId);
      expect(calculs.length, 2);
      expect(calculs.map((c) => c.id).toList()..sort(),
          [calcul1.id, calcul2.id]..sort());
    });

    test('deleteCalcul should remove calculation', () async {
      final calcul = CalculPuissance(
        id: 'test_calcul',
        date: DateTime.now(),
        parametres: {
          'surface': 20.0,
          'hauteur': 2.5,
          'temperature': 20.0,
          'type': TypePiece.zoneJour.toString(),
        },
        puissance_calculee: 2000.0,
        notes: 'Test calcul',
      );

      await calculService.saveCalcul(calcul, interventionId);
      final file =
          File('${tempDir.path}/calculs/${interventionId}_${calcul.id}.json');
      expect(await file.exists(), true);

      await calculService.deleteCalcul(interventionId, calcul.id);
      expect(await file.exists(), false);

      final calculs = await calculService.getCalculs(interventionId);
      expect(calculs, isEmpty);
    });

    test('calculerPuissancePiece should calculate power correctly', () {
      const piece = Piece(
        id: 'test_piece',
        nom: 'Salon',
        surface: 20.0,
        hauteur: 2.5,
        type: TypePiece.zoneJour,
        temperature:
            15.0, // Température plus basse pour avoir un deltaT positif
        puissanceCalculee: 0.0,
      );

      final puissance = calculService.calculerPuissancePiece(piece);
      expect(puissance, greaterThan(0));
      expect(puissance, lessThan(5000)); // Valeur raisonnable pour un salon
    });
  });
}
