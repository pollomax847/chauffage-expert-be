import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/be_alimentation.dart';

class SurpresseurPage extends ConsumerStatefulWidget {
  const SurpresseurPage({super.key});

  @override
  ConsumerState<SurpresseurPage> createState() => _SurpresseurPageState();
}

class _SurpresseurPageState extends ConsumerState<SurpresseurPage> {
  final _formKey = GlobalKey<FormState>();
  final _debitController = TextEditingController();
  final _hauteurManometriqueController = TextEditingController();
  final _pressionMinimaleController = TextEditingController();
  final _nombreLogementsController = TextEditingController();
  final _nombreEtagesController = TextEditingController();
  final _hauteurEtageController = TextEditingController();
  Map<String, dynamic>? _resultats;

  @override
  void dispose() {
    _debitController.dispose();
    _hauteurManometriqueController.dispose();
    _pressionMinimaleController.dispose();
    _nombreLogementsController.dispose();
    _nombreEtagesController.dispose();
    _hauteurEtageController.dispose();
    super.dispose();
  }

  void _calculer() {
    if (_formKey.currentState!.validate()) {
      final resultats = BEAlimentation.dimensionnerSurpresseur(
        debit: double.parse(_debitController.text),
        hauteurManometrique: double.parse(_hauteurManometriqueController.text),
        pressionMinimale: double.parse(_pressionMinimaleController.text),
        nombreLogements: int.parse(_nombreLogementsController.text),
        nombreEtages: int.parse(_nombreEtagesController.text),
        hauteurEtage: double.parse(_hauteurEtageController.text),
      );
      setState(() => _resultats = resultats);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dimensionnement Surpresseur'),
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
                    return 'La hauteur doit être positive';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pressionMinimaleController,
                decoration: const InputDecoration(
                  labelText: 'Pression minimale (bar)',
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
                    return 'La pression doit être positive';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreLogementsController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de logements',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Le nombre doit être positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreEtagesController,
                decoration: const InputDecoration(
                  labelText: 'Nombre d\'étages',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Le nombre doit être positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hauteurEtageController,
                decoration: const InputDecoration(
                  labelText: 'Hauteur d\'étage (m)',
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
                  label: 'Volume du ballon',
                  valeur: '${_resultats!['volumeBallon']} L',
                ),
                _ResultatItem(
                  label: 'Consommation annuelle',
                  valeur: '${_resultats!['consommationAnnuelle']} kWh',
                ),
                _ResultatItem(
                  label: 'Pression minimale requise',
                  valeur: '${_resultats!['pressionMinimaleRequise']} bar',
                ),
                _ResultatItem(
                  label: 'Hauteur totale',
                  valeur: '${_resultats!['hauteurTotale']} m',
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
