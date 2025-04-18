import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/be_geothermie.dart';

class PompesCirculationPage extends ConsumerStatefulWidget {
  const PompesCirculationPage({super.key});

  @override
  ConsumerState<PompesCirculationPage> createState() =>
      _PompesCirculationPageState();
}

class _PompesCirculationPageState extends ConsumerState<PompesCirculationPage> {
  final _formKey = GlobalKey<FormState>();
  final _debitController = TextEditingController();
  final _hauteurManometriqueController = TextEditingController();
  final _rendementController = TextEditingController();
  Map<String, dynamic>? _resultats;

  @override
  void dispose() {
    _debitController.dispose();
    _hauteurManometriqueController.dispose();
    _rendementController.dispose();
    super.dispose();
  }

  void _calculer() {
    if (_formKey.currentState!.validate()) {
      final resultats = BEGeothermie.dimensionnerPompesCirculation(
        debit: double.parse(_debitController.text),
        hauteurManometrique: double.parse(_hauteurManometriqueController.text),
        rendement: double.parse(_rendementController.text),
      );
      setState(() => _resultats = resultats);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dimensionnement Pompes de Circulation'),
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
                  labelText: 'Débit (m³/h)',
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
                controller: _hauteurManometriqueController,
                decoration: const InputDecoration(
                  labelText: 'Hauteur manométrique (m)',
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
                    return 'La hauteur manométrique doit être positive';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rendementController,
                decoration: const InputDecoration(
                  labelText: 'Rendement (%)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  final rendement = double.parse(value);
                  if (rendement <= 0 || rendement > 100) {
                    return 'Le rendement doit être entre 0 et 100';
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
                  label: 'Puissance hydraulique',
                  valeur: '${_resultats!['puissanceHydraulique']} kW',
                ),
                _ResultatItem(
                  label: 'Puissance absorbée',
                  valeur: '${_resultats!['puissanceAbsorbee']} kW',
                ),
                _ResultatItem(
                  label: 'Vitesse de rotation',
                  valeur: '${_resultats!['vitesseRotation']} tr/min',
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
