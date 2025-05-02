// test/services/be_pdf_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chauffage_expert/services/be_pdf_service.dart';
import 'package:chauffage_expert/services/interfaces/i_pdf_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

@GenerateMocks([SharedPreferences])
void main() {
  late BEPdfService pdfService;
  late MockSharedPreferences mockPrefs;
  late Directory tempDir;

  setUpAll(() async {
    // Initialiser les mocks
    mockPrefs = MockSharedPreferences();
    when(mockPrefs.getStringList(any)).thenReturn([]);
    when(mockPrefs.setStringList(any, any)).thenAnswer((_) async => true);

    // Créer un répertoire temporaire pour les tests
    tempDir = await Directory.systemTemp.createTemp('pdf_test');
    getApplicationDocumentsDirectory = () async => tempDir;
  });

  setUp(() async {
    pdfService = BEPdfService(mockPrefs);
    await pdfService.initialize();
  });

  tearDownAll(() async {
    // Nettoyer le répertoire temporaire
    await tempDir.delete(recursive: true);
  });

  group('BEPdfService Tests', () {
    test('should initialize correctly', () async {
      expect(pdfService, isA<IPdfService>());
      expect(pdfService.getReports(), isEmpty);
    });

    test('should generate a PDF report', () async {
      final report = await pdfService.generateBEStudyPDF(
        clientName: 'Test Client',
        entrepriseName: 'Test Entreprise',
        moduleName: 'Test Module',
        results: {'test': 'value'},
      );

      expect(report, isNotNull);
      expect(report.clientName, 'Test Client');
      expect(report.entrepriseName, 'Test Entreprise');
      expect(report.moduleName, 'Test Module');
      expect(report.results, {'test': 'value'});
      expect(report.filePath, isNotNull);
    });

    test('should save and load reports', () async {
      final report = await pdfService.generateBEStudyPDF(
        clientName: 'Test Client',
        entrepriseName: 'Test Entreprise',
        moduleName: 'Test Module',
        results: {'test': 'value'},
      );

      final reports = pdfService.getReports();
      expect(reports, hasLength(1));
      expect(reports.first.id, report.id);
    });

    test('should retrieve report file', () async {
      final report = await pdfService.generateBEStudyPDF(
        clientName: 'Test Client',
        entrepriseName: 'Test Entreprise',
        moduleName: 'Test Module',
        results: {'test': 'value'},
      );

      final file = await pdfService.getReportFile(report.id);
      expect(file, isNotNull);
      expect(await file!.exists(), isTrue);
    });

    test('should handle non-existent report file', () async {
      final file = await pdfService.getReportFile('non-existent-id');
      expect(file, isNull);
    });

    test('should handle invalid report data', () async {
      when(mockPrefs.getStringList(any)).thenReturn(['invalid json']);

      final pdfService = BEPdfService(mockPrefs);
      await pdfService.initialize();

      expect(pdfService.getReports(), isEmpty);
    });
  });
}
