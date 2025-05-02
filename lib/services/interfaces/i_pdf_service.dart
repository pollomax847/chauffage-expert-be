import 'dart:io';
import '../../models/rapport.dart';

abstract class IPdfService {
  Future<Rapport> generateBEStudyPDF({
    required String clientName,
    required String entrepriseName,
    required String moduleName,
    required Map<String, dynamic> results,
  });

  List<Rapport> getReports();
  Future<File?> getReportFile(String reportId);
  Future<void> initialize();
}
