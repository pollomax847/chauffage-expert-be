// test/helpers/path_provider_mock.dart
import 'dart:io';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:path/path.dart' as path;

class MockPathProviderPlatform extends PathProviderPlatform {
  late Directory _testDir;

  MockPathProviderPlatform() {
    _testDir = Directory(path.join(Directory.systemTemp.path, 'chauffage_expert_test'));
    _testDir.createSync(recursive: true);
  }

  @override
  Future<String?> getTemporaryPath() async {
    return _testDir.path;
  }

  @override
  Future<String?> getApplicationSupportDirectory() async {
    return _testDir.path;
  }

  @override
  Future<String?> getLibraryDirectory() async {
    return _testDir.path;
  }

  @override
  Future<String?> getApplicationDocumentsDirectory() async {
    return _testDir.path;
  }

  @override
  Future<String?> getExternalStorageDirectory() async {
    return _testDir.path;
  }

  @override
  Future<List<String>?> getExternalCacheDirectories() async {
    return [_testDir.path];
  }

  @override
  Future<List<String>?> getExternalStorageDirectories({StorageDirectory? type}) async {
    return [_testDir.path];
  }

  @override
  Future<String?> getDownloadsDirectory() async {
    return _testDir.path;
  }

  @override
  Future<String?> getApplicationCachePath() async {
    return _testDir.path;
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return _testDir.path;
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return _testDir.path;
  }

  @override
  Future<String?> getDownloadsPath() async {
    return _testDir.path;
  }

  @override
  Future<String?> getLibraryPath() async {
    return _testDir.path;
  }

  @override
  Future<String?> getExternalCachePath() async {
    return _testDir.path;
  }

  @override
  Future<String?> getExternalStoragePath() async {
    return _testDir.path;
  }

  @override
  Future<List<String>?> getExternalCachePaths() async {
    return [_testDir.path];
  }

  @override
  Future<List<String>?> getExternalStoragePaths(
      {StorageDirectory? type}) async {
    return [_testDir.path];
  }
}
