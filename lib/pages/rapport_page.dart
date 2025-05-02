import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pdf_provider.dart';

class RapportPage extends ConsumerStatefulWidget {
  const RapportPage({super.key});

  @override
  ConsumerState<RapportPage> createState() => _RapportPageState();
}

class _RapportPageState extends ConsumerState<RapportPage> {
  final _clientNameController = TextEditingController();
  final _entrepriseNameController = TextEditingController();
  final _moduleNameController = TextEditingController();

  @override
  void dispose() {
    _clientNameController.dispose();
    _entrepriseNameController.dispose();
    _moduleNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rapports = ref.watch(rapportsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapports'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Générer un rapport',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _clientNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom du client',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _entrepriseNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom de l\'entreprise',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _moduleNameController,
                      decoration: const InputDecoration(
                        labelText: 'Module',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final clientName = _clientNameController.text;
                        final entrepriseName = _entrepriseNameController.text;
                        final moduleName = _moduleNameController.text;

                        if (clientName.isEmpty ||
                            entrepriseName.isEmpty ||
                            moduleName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Veuillez remplir tous les champs')),
                          );
                          return;
                        }

                        try {
                          await ref
                              .read(rapportsProvider.notifier)
                              .generateReport(
                            clientName: clientName,
                            entrepriseName: entrepriseName,
                            moduleName: moduleName,
                            results: {
                              'Résultat 1': 'Valeur 1',
                              'Résultat 2': 'Valeur 2',
                            },
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Rapport généré avec succès')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Erreur lors de la génération: $e')),
                          );
                        }
                      },
                      child: const Text('Générer le rapport'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Historique des rapports',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rapports.length,
                      itemBuilder: (context, index) {
                        final rapport = rapports[index];
                        return ListTile(
                          title: Text(
                              '${rapport.clientName} - ${rapport.moduleName}'),
                          subtitle: Text(
                              'Date: ${rapport.createdAt.toLocal().toString().split('.')[0]}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () async {
                              final file = await ref
                                  .read(pdfServiceProvider)
                                  .getReportFile(rapport.id);
                              if (file != null) {
                                // TODO: Implémenter le partage du fichier
                              }
                            },
                          ),
                        );
                      },
                    ),
                    if (rapports.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                            child: Text('Aucun rapport dans l\'historique.')),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
