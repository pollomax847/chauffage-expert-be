// test/services/dgi_service_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:chauffage_expert/services/dgi_service.dart';
import 'package:chauffage_expert/models/verification_dgi.dart';
import '../helpers/path_provider_mock.dart';

void main() {
  late DGIService dgiService;
  late Directory tempDir;
  late String interventionId;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = MockPathProviderPlatform();
    tempDir = await getTemporaryDirectory();
    dgiService = DGIService();
    await dgiService.init();
    interventionId = 'test_intervention';
  });

  tearDownAll(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('DGIService', () {
    test('saveVerification should save verification data correctly', () async {
      final verification = VerificationDGI(
        id: 'test_verification',
        date: DateTime.now(),
        type: TypeDGI.entretien,
        resultats: {
          'pression': true,
          'temperature': true,
          'reglage': true,
          'entretien': true,
        },
        notes: 'Test verification',
      );

      await dgiService.saveVerification(verification);
      final verifications = await dgiService.getVerifications(interventionId);
      expect(verifications, contains(verification));
    });

    test('getVerifications should return only verifications for intervention', () async {
      final verification1 = VerificationDGI(
        id: 'test_verification_1',
        date: DateTime.now(),
        type: TypeDGI.entretien,
        resultats: {
          'pression': true,
          'temperature': true,
          'reglage': true,
          'entretien': true,
        },
        notes: 'Test verification 1',
      );

      final verification2 = VerificationDGI(
        id: 'test_verification_2',
        date: DateTime.now(),
        type: TypeDGI.entretien,
        resultats: {
          'pression': true,
          'temperature': true,
          'reglage': true,
          'entretien': true,
        },
        notes: 'Test verification 2',
      );

      await dgiService.saveVerification(verification1);
      await dgiService.saveVerification(verification2);

      final verifications = await dgiService.getVerifications(interventionId);
      expect(verifications.length, 2);
      expect(verifications, contains(verification1));
      expect(verifications, contains(verification2));
    });

    test('deleteVerification should remove verification', () async {
      final verification = VerificationDGI(
        id: 'test_verification',
        date: DateTime.now(),
        type: TypeDGI.entretien,
        resultats: {
          'pression': true,
          'temperature': true,
          'reglage': true,
          'entretien': true,
        },
        notes: 'Test verification',
      );

      await dgiService.saveVerification(verification);
      await dgiService.deleteVerification(verification.id);
      final verifications = await dgiService.getVerifications(interventionId);
      expect(verifications, isEmpty);
    });

    test('isConforme should check all criteria', () async {
      final verification = VerificationDGI(
        id: 'test_verification',
        date: DateTime.now(),
        type: TypeDGI.entretien,
        resultats: {
          'pression': true,
          'temperature': true,
          'reglage': true,
          'entretien': true,
        },
        notes: 'Test verification',
      );

      expect(dgiService.isConforme(verification), true);

      final verificationNonConforme = VerificationDGI(
        id: 'test_verification_non_conforme',
        date: DateTime.now(),
        type: TypeDGI.entretien,
        resultats: {
          'pression': true,
          'temperature': false,
          'reglage': true,
          'entretien': true,
        },
        notes: 'Test verification non conforme',
      );

      expect(dgiService.isConforme(verificationNonConforme), false);
    });
  });
}
