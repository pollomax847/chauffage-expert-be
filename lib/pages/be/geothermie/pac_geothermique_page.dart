import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/be_geothermie.dart';

class PACGeothermiquePage extends ConsumerStatefulWidget {
  const PACGeothermiquePage({super.key});

  @override
  ConsumerState<PACGeothermiquePage> createState() =>
      _PACGeothermiquePageState();
}

class _PACGeothermiquePageState extends ConsumerState<PACGeothermiquePage> {
  final _formKey = GlobalKey<FormState>();
  final _puissanceController = TextEditingController();
  final _temperatureSourceController = TextEditingController();
  final _temperatureEmiseController = TextEditingController();
  String _typeCaptage = 'horizontal';
  Map<String, dynamic>? _resultats;

  @override
  void dispose() {
    _puissanceController.dispose();
    _temperatureSourceController.dispose();
    _temperatureEmiseController.dispose();
    super.dispose();
  }

  void _calculer() {
    if (_formKey.currentState!.validate()) {
      final resultats = BEGeothermie.dimensionnerPACGeothermique(
        puissanceThermique: double.parse(_puissanceController.text),
        temperatureSource: double.parse(_temperatureSourceController.text),
        temperatureEmise: double.parse(_temperatureEmiseController.text),
        typeCaptage: _typeCaptage,
      );
      setState(() => _resultats = resultats);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dimensionnement PAC Géothermique'),
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
              DropdownButtonFormField<String>(
                value: _typeCaptage,
                decoration: const InputDecoration(
                  labelText: 'Type de captage',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'horizontal',
                    child: Text('Captage horizontal'),
                  ),
                  DropdownMenuItem(
                    value: 'vertical',
                    child: Text('Captage vertical'),
                  ),
                  DropdownMenuItem(
                    value: 'sur_eau',
                    child: Text('Captage sur eau'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _typeCaptage = value);
                  }
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
                  label: 'COP théorique',
                  valeur: _resultats!['copTheorique'],
                ),
                _ResultatItem(
                  label: 'COP réel',
                  valeur: _resultats!['copReel'],
                ),
                _ResultatItem(
                  label: 'Puissance électrique',
                  valeur: '${_resultats!['puissanceElectrique']} kW',
                ),
                _ResultatItem(
                  label: 'Débit source',
                  valeur: '${_resultats!['debitSource']} m³/h',
                ),
                _ResultatItem(
                  label: 'Surface de captage',
                  valeur: '${_resultats!['surfaceCaptage']} m²',
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
