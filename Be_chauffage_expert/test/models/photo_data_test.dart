// test/models/photo_data_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:chauffage_expert/models/photo_data.dart';

void main() {
  group('PhotoData', () {
    final now = DateTime.now();
    final annotations = [
      const PhotoAnnotation(
        id: '1',
        text: 'Test annotation',
        position: Offset(100, 100),
        color: Color(0xFFF44336),
      ),
    ];

    test('should create a PhotoData instance', () {
      final photoData = PhotoData(
        id: '1',
        path: '/path/to/photo.jpg',
        date: now,
        title: 'Test photo',
        description: 'Test description',
        annotations: annotations,
        category: PhotoCategory.chaudiere,
      );

      expect(photoData.id, '1');
      expect(photoData.path, '/path/to/photo.jpg');
      expect(photoData.date, now);
      expect(photoData.title, 'Test photo');
      expect(photoData.description, 'Test description');
      expect(photoData.annotations, annotations);
      expect(photoData.category, PhotoCategory.chaudiere);
    });

    test('should create a PhotoData from JSON', () {
      final json = {
        'id': '1',
        'path': '/path/to/photo.jpg',
        'date': now.toIso8601String(),
        'title': 'Test photo',
        'description': 'Test description',
        'annotations': [
          {
            'id': '1',
            'text': 'Test annotation',
            'position': {'dx': 100.0, 'dy': 100.0},
            'color': 0xFFF44336,
          }
        ],
        'category': 'chaudiere',
      };

      final photoData = PhotoData.fromJson(json);

      expect(photoData.id, '1');
      expect(photoData.path, '/path/to/photo.jpg');
      expect(photoData.date.toIso8601String(), now.toIso8601String());
      expect(photoData.title, 'Test photo');
      expect(photoData.description, 'Test description');
      expect(photoData.annotations.length, 1);
      expect(photoData.annotations.first.id, '1');
      expect(photoData.annotations.first.text, 'Test annotation');
      expect(photoData.annotations.first.position, const Offset(100, 100));
      expect(photoData.annotations.first.color, const Color(0xFFF44336));
      expect(photoData.category, PhotoCategory.chaudiere);
    });

    test('should convert PhotoData to JSON', () {
      final photoData = PhotoData(
        id: '1',
        path: '/path/to/photo.jpg',
        date: now,
        title: 'Test photo',
        description: 'Test description',
        annotations: annotations,
        category: PhotoCategory.chaudiere,
      );

      final json = photoData.toJson();

      expect(json['id'], '1');
      expect(json['path'], '/path/to/photo.jpg');
      expect(json['date'], now.toIso8601String());
      expect(json['title'], 'Test photo');
      expect(json['description'], 'Test description');
      expect(json['annotations'].length, 1);
      expect(json['annotations'][0]['id'], '1');
      expect(json['annotations'][0]['text'], 'Test annotation');
      expect(json['annotations'][0]['position']['dx'], 100.0);
      expect(json['annotations'][0]['position']['dy'], 100.0);
      expect(json['annotations'][0]['color'], 0xFFF44336);
      expect(json['category'], 'chaudiere');
    });

    test('should handle null optional fields', () {
      final photoData = PhotoData(
        id: '1',
        path: '/path/to/photo.jpg',
        date: now,
        title: 'Test photo',
        annotations: [],
        category: PhotoCategory.chaudiere,
      );

      expect(photoData.description, null);
    });
  });

  group('PhotoAnnotation', () {
    test('should create a PhotoAnnotation instance', () {
      const annotation = PhotoAnnotation(
        id: '1',
        text: 'Test annotation',
        position: const Offset(100, 100),
        color: const Color(0xFFF44336),
      );

      expect(annotation.id, '1');
      expect(annotation.text, 'Test annotation');
      expect(annotation.position, const Offset(100, 100));
      expect(annotation.color, const Color(0xFFF44336));
    });

    test('should create a PhotoAnnotation from JSON', () {
      final json = {
        'id': '1',
        'text': 'Test annotation',
        'position': {'dx': 100.0, 'dy': 100.0},
        'color': 0xFFF44336,
      };

      final annotation = PhotoAnnotation.fromJson(json);

      expect(annotation.id, '1');
      expect(annotation.text, 'Test annotation');
      expect(annotation.position, const Offset(100, 100));
      expect(annotation.color, const Color(0xFFF44336));
    });

    test('should convert PhotoAnnotation to JSON', () {
      const annotation = PhotoAnnotation(
        id: '1',
        text: 'Test annotation',
        position: const Offset(100, 100),
        color: const Color(0xFFF44336),
      );

      final json = annotation.toJson();

      expect(json['id'], '1');
      expect(json['text'], 'Test annotation');
      expect(json['position']['dx'], 100.0);
      expect(json['position']['dy'], 100.0);
      expect(json['color'], 0xFFF44336);
    });
  });
}
