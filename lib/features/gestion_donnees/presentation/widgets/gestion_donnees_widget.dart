// features/gestion_donnees/presentation/widgets/gestion_donnees_widget.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/repositories/donnees_repository.dart';

class GestionDonneesWidget extends StatefulWidget {
  const GestionDonneesWidget({super.key});

  @override
  State<GestionDonneesWidget> createState() => _GestionDonneesWidgetState();
}

class _GestionDonneesWidgetState extends State<GestionDonneesWidget> {
  final _repository = GetIt.instance<DonneesRepository>();
  Map<String, dynamic> _donnees = {};
  List<Map<String, dynamic>> _historique = [];

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    final donnees = await _repository.chargerDonnees();
    final historique = await _repository.obtenirHistorique();
    setState(() {
      _donnees = donnees;
      _historique = historique;
    });
  }

  Future<void> _sauvegarderDonnees() async {
    final nouvellesDonnees = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      'donnees': _donnees,
    };
    await _repository.sauvegarderDonnees(nouvellesDonnees);
    await _chargerDonnees();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Données actuelles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(_donnees.toString()),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _sauvegarderDonnees,
                  child: const Text('Sauvegarder'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Historique',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _historique.length,
                  itemBuilder: (context, index) {
                    final entree = _historique[index];
                    return ListTile(
                      title: Text('Entrée ${index + 1}'),
                      subtitle: Text(entree['timestamp']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _repository.supprimerDonnees(entree['id']);
                          await _chargerDonnees();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
