import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class BEPhotoService {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (photo == null) return null;
      
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(photo.path).copy(
        '${directory.path}/$fileName'
      );
      
      return savedImage.path;
    } catch (e) {
      debugPrint('Erreur lors de la prise de photo: $e');
      return null;
    }
  }

  static Future<String?> pickPhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (photo == null) return null;
      
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(photo.path).copy(
        '${directory.path}/$fileName'
      );
      
      return savedImage.path;
    } catch (e) {
      debugPrint('Erreur lors de la sélection de photo: $e');
      return null;
    }
  }

  static Future<void> deletePhoto(String photoPath) async {
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Erreur lors de la suppression de la photo: $e');
    }
  }

  static Future<List<String>> getStudyPhotos(String studyId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final studyDir = Directory('${directory.path}/$studyId');
      
      if (!await studyDir.exists()) {
        return [];
      }
      
      final files = await studyDir.list().toList();
      return files
          .where((file) => file is File && path.extension(file.path) == '.jpg')
          .map((file) => file.path)
          .toList();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des photos: $e');
      return [];
    }
  }
} 