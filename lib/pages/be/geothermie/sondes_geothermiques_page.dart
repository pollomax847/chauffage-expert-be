import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/be_geothermie.dart';

class SondesGeothermiquesPage extends ConsumerStatefulWidget {
  const SondesGeothermiquesPage({super.key});

  @override
  ConsumerState<SondesGeothermiquesPage> createState() =>
      _SondesGeothermiquesPageState();
}

class _SondesGeothermiquesPageState
    extends ConsumerState<SondesGeothermiquesPage> {
  final _formKey = GlobalKey<FormState>();
  final _puissanceController = TextEditingController();
  final _temperatureSourceController = TextEditingController();
  final _temperatureEmiseController = TextEditingController();
  final _profondeurController = TextEditingController();
  Map<String, dynamic>? _resultats;

  @override
  void dispose() {
    _puissanceController.dispose();
    _temperatureSourceController.dispose();
    _temperatureEmiseController.dispose();
    _profondeurController.dispose();
    super.dispose();
  }

  void _calculer() {
    if (_formKey.currentState!.validate()) {
      final resultats = BEGeothermie.dimensionnerSondesGeothermiques(
        puissanceThermique: double.parse(_puissanceController.text),
        temperatureSource: double.parse(_temperatureSourceController.text),
        temperatureEmise: double.parse(_temperatureEmiseController.text),
        profondeur: double.parse(_profondeurController.text),
      );
      setState(() => _resultats = resultats);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dimensionnement Sondes Géothermiques'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _puissanceController,
                decoration: const InputDecoration(
                  labelText: 'Puissance thermique (kW)',
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
                    return 'La puissance doit être positive';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _temperatureSourceController,
                decoration: const InputDecoration(
                  labelText: 'Température source (°C)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _temperatureEmiseController,
                decoration: const InputDecoration(
                  labelText: 'Température émise (°C)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (double.parse(value) <=
                      double.parse(_temperatureSourceController.text)) {
                    return 'La température émise doit être supérieure à la température source';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _profondeurController,
                decoration: const InputDecoration(
                  labelText: 'Profondeur (m)',
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
                    return 'La profondeur doit être positive';
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
                  label: 'Nombre de sondes',
                  valeur: _resultats!['nombreSondes'].toString(),
                ),
                _ResultatItem(
                  label: 'Longueur totale',
                  valeur: '${_resultats!['longueurTotale']} m',
                ),
                _ResultatItem(
                  label: 'Espacement entre sondes',
                  valeur: '${_resultats!['espacement']} m',
                ),
                _ResultatItem(
                  label: 'Surface au sol',
                  valeur: '${_resultats!['surfaceSol']} m²',
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
