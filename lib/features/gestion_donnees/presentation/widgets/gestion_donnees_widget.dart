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

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    final donnees = await _repository.getDonnees();
    setState(() {
      _donnees = donnees;
    });
  }

  Future<void> _sauvegarderDonnees() async {
    for (final entry in _donnees.entries) {
      await _repository.ajouterDonnee(entry.key, entry.value);
    }
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
      ],
    );
  }
}
