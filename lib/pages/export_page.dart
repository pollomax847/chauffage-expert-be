// pages/export_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../services/pdf_service.dart';

class ExportPage extends ConsumerStatefulWidget {
  final Map<String, dynamic>? resultats;
  final String typeExport;
  final String titre;

  const ExportPage({
    super.key,
    this.resultats,
    required this.typeExport,
    required this.titre,
  });

  @override
  ConsumerState<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends ConsumerState<ExportPage> {
  bool _isExporting = false;
  String _formatExport = 'pdf';
  bool _showPreview = false;
  final _enteteController = TextEditingController();
  final _piedPageController = TextEditingController();

  @override
  void dispose() {
    _enteteController.dispose();
    _piedPageController.dispose();
    super.dispose();
  }

  Future<void> _exportFile() async {
    if (widget.resultats == null) return;

    setState(() {
      _isExporting = true;
    });

    try {
      File file;
      if (_formatExport == 'pdf') {
        file = await PDFService.generateDimensionnementPDF(
          resultats: widget.resultats!,
          typeCalcul: widget.titre,
          entete: _enteteController.text.isNotEmpty
              ? {'titre': _enteteController.text}
              : null,
          piedPage: _piedPageController.text.isNotEmpty
              ? {'gauche': _piedPageController.text}
              : null,
          showPreview: _showPreview,
        );
      } else {
        file = await PDFService.generateExcel(
          resultats: widget.resultats!,
          typeCalcul: widget.titre,
        );
      }

      await PDFService.sharePDF(file);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'exportation : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exportation PDF'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.file_download,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            Text(
              'Exporter les résultats',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              widget.titre,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Options d\'export',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _formatExport,
                      decoration: const InputDecoration(
                        labelText: 'Format d\'export',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'pdf',
                          child: Text('PDF'),
                        ),
                        DropdownMenuItem(
                          value: 'excel',
                          child: Text('Excel'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _formatExport = value!;
                        });
                      },
                    ),
                    if (_formatExport == 'pdf') ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _enteteController,
                        decoration: const InputDecoration(
                          labelText: 'En-tête personnalisé',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _piedPageController,
                        decoration: const InputDecoration(
                          labelText: 'Pied de page personnalisé',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Afficher la prévisualisation'),
                        value: _showPreview,
                        onChanged: (value) {
                          setState(() {
                            _showPreview = value;
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isExporting ? null : _exportFile,
              icon: _isExporting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.file_download),
              label: Text(_isExporting ? 'Exportation...' : 'Exporter'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            if (widget.resultats == null) ...[
              const SizedBox(height: 16),
              const Text(
                'Aucun résultat à exporter',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
