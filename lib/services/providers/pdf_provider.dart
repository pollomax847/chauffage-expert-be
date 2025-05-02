import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../interfaces/i_pdf_service.dart';
import '../../models/rapport.dart';

// Utiliser l'instance singleton de IPdfService depuis GetIt
final pdfServiceProvider = Provider<IPdfService>((ref) {
  return GetIt.instance<IPdfService>();
});

// Provider pour la liste des rapports
final rapportsProvider =
    StateNotifierProvider<RapportsNotifier, List<Rapport>>((ref) {
  final pdfService = ref.watch(pdfServiceProvider);
  return RapportsNotifier(pdfService);
});

class RapportsNotifier extends StateNotifier<List<Rapport>> {
  final IPdfService _pdfService;

  RapportsNotifier(this._pdfService) : super([]) {
    _loadReports();
  }

  void _loadReports() {
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
