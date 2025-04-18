// test/services/photo_service_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:chauffage_expert/services/photo_service.dart';
import 'package:chauffage_expert/models/photo_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../helpers/path_provider_mock.dart';

void main() {
  late PhotoService photoService;
  late Directory tempDir;
  late MockPathProviderPlatform mockPathProvider;
  late String interventionId;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockPathProvider = MockPathProviderPlatform();
    PathProviderPlatform.instance = mockPathProvider;
    tempDir = await Directory.systemTemp.createTemp();
    photoService = PhotoService();
    interventionId = 'test_intervention';
    await photoService.init();
  });

  tearDownAll(() async {
    await tempDir.delete(recursive: true);
  });

  group('PhotoService', () {
    test('savePhoto should save a photo file', () async {
      final photoFile = File('${tempDir.path}/test_photo.jpg');
      await photoFile.writeAsBytes([1, 2, 3]); // Simulated photo data
      final xFile = XFile(photoFile.path);

      final savedPath = await photoService.savePhoto(xFile, interventionId);

      expect(savedPath, isNotNull);
      final savedFile = File(savedPath);
      expect(await savedFile.exists(), isTrue);
    });

    test('saveAnnotation should save annotation data', () async {
      final appDir = await mockPathProvider.getApplicationDocumentsDirectory();
      final photoData = PhotoData(
        id: '123',
        path: path.join(appDir!, 'photos', '123.jpg'),
        date: DateTime.now(),
        title: 'Test Photo',
        category: PhotoCategory.chaudiere,
        annotations: [
          const PhotoAnnotation(
            id: '1',
            text: 'Test annotation 1',
            position: Offset(100, 100),
            color: Color(0xFFF44336),
          ),
          const PhotoAnnotation(
            id: '2',
            text: 'Test annotation 2',
            position: Offset(200, 200),
            color: Color(0xFF2196F3),
          ),
        ],
      );

      await photoService.saveAnnotation(photoData);

      final annotationFile = File(path.join(appDir, 'annotations', '123.json'));
      expect(await annotationFile.exists(), isTrue);

      final content = await annotationFile.readAsString();
      expect(content.contains('Test annotation 1'), isTrue);
      expect(content.contains('Test annotation 2'), isTrue);
    });

    test('deletePhoto should remove photo file', () async {
      final appDir = await mockPathProvider.getApplicationDocumentsDirectory();
      const photoId = '123';
      final photoFile = File(path.join(appDir!, 'photos', '123.jpg'));
      await photoFile.parent.create(recursive: true);
      await photoFile.writeAsBytes([1, 2, 3]);

      await photoService.deletePhoto(photoFile.path);

      expect(await photoFile.exists(), isFalse);
    });

    test('deleteAnnotation should remove annotation file', () async {
      final appDir = await mockPathProvider.getApplicationDocumentsDirectory();
      const photoId = '123';
      final annotationFile = File(path.join(appDir!, 'annotations', '123.json'));
      await annotationFile.parent.create(recursive: true);
      await annotationFile.writeAsString('{"annotations": ["Test"]}');

      await photoService.deleteAnnotation(photoId);

      expect(await annotationFile.exists(), isFalse);
    });
  });
}
