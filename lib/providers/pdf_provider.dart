import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/be_pdf_service.dart';
import '../models/rapport.dart';

final pdfServiceProvider = Provider((ref) => BEPDFService());

final rapportsProvider =
    StateNotifierProvider<RapportsNotifier, List<Rapport>>((ref) {
  return RapportsNotifier(ref.watch(pdfServiceProvider));
});

class RapportsNotifier extends StateNotifier<List<Rapport>> {
  final BEPDFService _pdfService;

  RapportsNotifier(this._pdfService) : super([]) {
    state = _pdfService.getReports();
  }

  Future<void> generateReport({
    required String clientName,
    required String entrepriseName,
    required String moduleName,
    required Map<String, dynamic> results,
  }) async {
    final rapport = await _pdfService.generateBEStudyPDF(
      clientName: clientName,
      entrepriseName: entrepriseName,
      moduleName: moduleName,
      results: results,
    );
    state = [...state, rapport];
  }
}
