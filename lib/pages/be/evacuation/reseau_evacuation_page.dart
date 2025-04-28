import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/be_evacuation.dart';

class ReseauEvacuationPage extends ConsumerStatefulWidget {
  const ReseauEvacuationPage({super.key});

  @override
  ConsumerState<ReseauEvacuationPage> createState() =>
      _ReseauEvacuationPageState();
}

class _ReseauEvacuationPageState extends ConsumerState<ReseauEvacuationPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _appareilsControllers = {
    'lavabo': TextEditingController(),
    'douche': TextEditingController(),
    'baignoire': TextEditingController(),
    'wc': TextEditingController(),
    'lave_linge': TextEditingController(),
    'lave_vaisselle': TextEditingController(),
    'evier': TextEditingController(),
  };
  final _longueurController = TextEditingController();
  final _penteController = TextEditingController();
  Map<String, dynamic>? _resultats;

  @override
  void dispose() {
    for (var controller in _appareilsControllers.values) {
      controller.dispose();
    }
    _longueurController.dispose();
    _penteController.dispose();
    super.dispose();
  }

  void _calculer() {
    if (_formKey.currentState!.validate()) {
      final appareils = <String, int>{};
      for (var entry in _appareilsControllers.entries) {
        final nombre = int.tryParse(entry.value.text) ?? 0;
        if (nombre > 0) {
          appareils[entry.key] = nombre;
        }
      }

      final resultats = BEEvacuation.dimensionnerReseau(
        appareils: appareils,
        longueur: double.parse(_longueurController.text),
        pente: double.parse(_penteController.text),
      );
      setState(() => _resultats = resultats);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dimensionnement Réseau d\'Évacuation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Nombre d\'appareils :',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ..._appareilsControllers.entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: entry.value,
                      decoration: InputDecoration(
                        labelText:
                            entry.key.replaceAll('_', ' ').toUpperCase(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une valeur';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Veuillez entrer un nombre valide';
                        }
                        if (int.parse(value) < 0) {
                          return 'Le nombre doit être positif';
                        }
                        return null;
                      },
                    ),
                  )),
              const SizedBox(height: 16),
              TextFormField(
                controller: _longueurController,
                decoration: const InputDecoration(
                  labelText: 'Longueur du réseau (m)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (double.parse(value) <= 0) {
                    return 'La longueur doit être positive';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _penteController,
                decoration: const InputDecoration(
                  labelText: 'Pente du réseau (%)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  final pente = double.parse(value);
                  if (pente <= 0 || pente > 5) {
                    return 'La pente doit être entre 0 et 5%';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculer,
                child: const Text('Calculer'),
              ),
              if (_resultats != null) ...[
                const SizedBox(height: 24),
                const Text(
                  'Résultats :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _ResultatItem(
                  label: 'Débit total',
                  valeur: '${_resultats!['debitTotal']} L/s',
                ),
                _ResultatItem(
                  label: 'Diamètre minimal',
                  valeur: '${_resultats!['diametreMinimal']} mm',
                ),
                _ResultatItem(
                  label: 'Diamètre théorique',
                  valeur: '${_resultats!['diametreTheorique']} mm',
                ),
                _ResultatItem(
                  label: 'Diamètre final',
                  valeur: '${_resultats!['diametreFinal']} mm',
                ),
                _ResultatItem(
                  label: 'Vitesse d\'écoulement',
                  valeur: '${_resultats!['vitesse']} m/s',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Débits par appareil :',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...(_resultats!['debitsParAppareil'] as Map<String, double>)
                    .entries
                    .map((entry) => _ResultatItem(
                          label: entry.key.replaceAll('_', ' ').toUpperCase(),
                          valeur: '${entry.value.toStringAsFixed(2)} L/s',
                        )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultatItem extends StatelessWidget {
  final String label;
  final String valeur;

  const _ResultatItem({
    required this.label,
    required this.valeur,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            valeur,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
