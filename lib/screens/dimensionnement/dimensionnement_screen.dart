import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/appareil.dart';
import '../../services/calcul_service.dart';

// Provider pour gérer l'état des appareils
final appareilsProvider = StateProvider<List<Appareil>>((ref) => []);

class DimensionnementScreen extends ConsumerWidget {
  const DimensionnementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appareils = ref.watch(appareilsProvider);
    final resultats = _calculerResultats(appareils);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dimensionnement EFS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddAppareilDialog(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildListeAppareils(appareils, ref),
            const SizedBox(height: 24),
            _buildResultats(resultats),
          ],
        ),
      ),
    );
  }

  void _showAddAppareilDialog(BuildContext context, WidgetRef ref) {
    final nomController = TextEditingController();
    final debitController = TextEditingController();
    final quantiteController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un appareil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomController,
              decoration: const InputDecoration(
                labelText: 'Nom de l\'appareil',
                hintText: 'Ex: WC, Lavabo...',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: debitController,
              decoration: const InputDecoration(
                labelText: 'Unité de débit (DU)',
                hintText: 'Ex: 1.0, 0.2...',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: quantiteController,
              decoration: const InputDecoration(
                labelText: 'Quantité',
                hintText: 'Ex: 1, 2...',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final nom = nomController.text;
              final debit = double.tryParse(debitController.text) ?? 0.0;
              final quantite = int.tryParse(quantiteController.text) ?? 1;

              if (nom.isNotEmpty && debit > 0) {
                ref.read(appareilsProvider.notifier).state = [
                  ...ref.read(appareilsProvider),
                  Appareil(
                    nom: nom,
                    uniteDebit: debit,
                    quantite: quantite,
                  ),
                ];
                Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  Widget _buildListeAppareils(List<Appareil> appareils, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Appareils sanitaires',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Builder(
                  builder: (context) => TextButton.icon(
                    onPressed: () => _showAddAppareilDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (appareils.isEmpty)
              const Center(
                child: Text('Aucun appareil ajouté'),
              )
            else
              ...appareils.map((appareil) => _buildAppareilTile(appareil, ref)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppareilTile(Appareil appareil, WidgetRef ref) {
    return Dismissible(
      key: Key(appareil.nom),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(appareilsProvider.notifier).state = [
          for (var a in ref.read(appareilsProvider))
            if (a.nom != appareil.nom) a,
        ];
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appareil.nom,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'DU = ${appareil.uniteDebit}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (appareil.quantite > 0) {
                      ref.read(appareilsProvider.notifier).state = [
                        for (var a in ref.read(appareilsProvider))
                          if (a.nom == appareil.nom)
                            Appareil(
                              nom: a.nom,
                              uniteDebit: a.uniteDebit,
                              quantite: a.quantite - 1,
                            )
                          else
                            a,
                      ];
                    }
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    appareil.quantite.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    ref.read(appareilsProvider.notifier).state = [
                      for (var a in ref.read(appareilsProvider))
                        if (a.nom == appareil.nom)
                          Appareil(
                            nom: a.nom,
                            uniteDebit: a.uniteDebit,
                            quantite: a.quantite + 1,
                          )
                        else
                          a,
                    ];
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _calculerResultats(List<Appareil> appareils) {
    final nombreAppareils = appareils.fold<int>(
      0,
      (sum, appareil) => sum + appareil.quantite,
    );

    final sommeDU = appareils.fold<double>(
      0,
      (sum, appareil) => sum + (appareil.uniteDebit * appareil.quantite),
    );

    final y = CalculService.calculerCoefficientSimultaneite(nombreAppareils);
    final debit = CalculService.calculerDebit(appareils);
    final diametreInterieur = CalculService.calculerDiametreInterieur(debit);
    final diametreNominal = CalculService.trouverDiametreNominal(
      diametreInterieur,
    );

    return {
      'nombreAppareils': nombreAppareils,
      'sommeDU': sommeDU,
      'coefficientSimultaneite': y,
      'debit': debit,
      'diametreInterieur': diametreInterieur,
      'diametreNominal': diametreNominal,
    };
  }

  Widget _buildResultats(Map<String, dynamic> resultats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Résultats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildResultatLine(
              'Nombre total d\'appareils',
              resultats['nombreAppareils'].toString(),
            ),
            _buildResultatLine(
              'Somme des DU',
              resultats['sommeDU'].toStringAsFixed(2),
            ),
            _buildResultatLine(
              'Coefficient de simultanéité',
              resultats['coefficientSimultaneite'].toStringAsFixed(3),
            ),
            _buildResultatLine(
              'Débit (L/s)',
              resultats['debit'].toStringAsFixed(2),
            ),
            _buildResultatLine(
              'Diamètre intérieur (mm)',
              resultats['diametreInterieur'].toStringAsFixed(1),
            ),
            _buildResultatLine(
              'Diamètre nominal',
              resultats['diametreNominal'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultatLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
