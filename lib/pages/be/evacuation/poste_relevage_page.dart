import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/be_evacuation.dart';

class PosteRelevagePage extends ConsumerStatefulWidget {
  const PosteRelevagePage({super.key});

  @override
  ConsumerState<PosteRelevagePage> createState() => _PosteRelevagePageState();
}

class _PosteRelevagePageState extends ConsumerState<PosteRelevagePage> {
  final _formKey = GlobalKey<FormState>();
  final _debitController = TextEditingController();
  final _hauteurRelevageController = TextEditingController();
  final _longueurConduiteController = TextEditingController();
  Map<String, dynamic>? _resultats;

  @override
  void dispose() {
    _debitController.dispose();
    _hauteurRelevageController.dispose();
    _longueurConduiteController.dispose();
    super.dispose();
  }

  void _calculer() {
    if (_formKey.currentState!.validate()) {
      final resultats = BEEvacuation.dimensionnerPosteRelevage(
        debit: double.parse(_debitController.text),
        hauteurRelevage: double.parse(_hauteurRelevageController.text),
        longueurConduite: double.parse(_longueurConduiteController.text),
      );
      setState(() => _resultats = resultats);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dimensionnement Poste de Relevage'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _debitController,
                decoration: const InputDecoration(
                  labelText: 'Débit (L/s)',
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
                    return 'Le débit doit être positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hauteurRelevageController,
                decoration: const InputDecoration(
                  labelText: 'Hauteur de relevage (m)',
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
                    return 'La hauteur doit être positive';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _longueurConduiteController,
                decoration: const InputDecoration(
                  labelText: 'Longueur de la conduite (m)',
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
                  label: 'Puissance de la pompe',
                  valeur: '${_resultats!['puissance']} W',
                ),
                _ResultatItem(
                  label: 'Volume de la cuve',
                  valeur: '${_resultats!['volumeCuve']} m³',
                ),
                _ResultatItem(
                  label: 'Consommation annuelle',
                  valeur: '${_resultats!['consommationAnnuelle']} kWh',
                ),
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
