// providers/pdf_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/be_pdf_service.dart';
import '../models/rapport.dart';

final pdfServiceProvider = FutureProvider<BEPdfService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final service = BEPdfService(prefs);
  await service.initialize();
  return service;
});

final rapportsProvider =
    StateNotifierProvider<RapportsNotifier, List<Rapport>>((ref) {
  final pdfService = ref.watch(pdfServiceProvider).value;
  if (pdfService == null) return RapportsNotifier(null);
  return RapportsNotifier(pdfService);
});

class RapportsNotifier extends StateNotifier<List<Rapport>> {
  final BEPdfService? _pdfService;

  RapportsNotifier(this._pdfService) : super([]) {
    if (_pdfService != null) {
      state = _pdfService.getReports();
    }
  }

  Future<void> generateReport({
    required String clientName,
    required String entrepriseName,
    required String moduleName,
    required Map<String, dynamic> results,
  }) async {
    if (_pdfService == null) return;

    final rapport = await _pdfService.generateBEStudyPDF(
      clientName: clientName,
      entrepriseName: entrepriseName,
      moduleName: moduleName,
      results: results,
    );
    state = [...state, rapport];
  }
}
