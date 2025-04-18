import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/be_alimentation.dart';

class RetourBouclePage extends ConsumerStatefulWidget {
  const RetourBouclePage({super.key});

  @override
  ConsumerState<RetourBouclePage> createState() => _RetourBouclePageState();
}

class _RetourBouclePageState extends ConsumerState<RetourBouclePage> {
  final _formKey = GlobalKey<FormState>();
  final _debitController = TextEditingController();
  final _longueurBoucleController = TextEditingController();
  final _temperatureDepartController = TextEditingController();
  final _temperatureRetourController = TextEditingController();
  final _nombreLogementsController = TextEditingController();
  final _nombreEtagesController = TextEditingController();
  final _hauteurEtageController = TextEditingController();
  Map<String, dynamic>? _resultats;

  @override
  void dispose() {
    _debitController.dispose();
    _longueurBoucleController.dispose();
    _temperatureDepartController.dispose();
    _temperatureRetourController.dispose();
    _nombreLogementsController.dispose();
    _nombreEtagesController.dispose();
    _hauteurEtageController.dispose();
    super.dispose();
  }

  void _calculer() {
    if (_formKey.currentState!.validate()) {
      final resultats = BEAlimentation.dimensionnerRetourBoucle(
        debit: double.parse(_debitController.text),
        longueurBoucle: double.parse(_longueurBoucleController.text),
        temperatureDepart: double.parse(_temperatureDepartController.text),
        temperatureRetour: double.parse(_temperatureRetourController.text),
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
        title: const Text('Dimensionnement Retour de Boucle'),
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
                controller: _longueurBoucleController,
                decoration: const InputDecoration(
                  labelText: 'Longueur de la boucle (m)',
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
                controller: _temperatureDepartController,
                decoration: const InputDecoration(
                  labelText: 'Température de départ (°C)',
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
                controller: _temperatureRetourController,
                decoration: const InputDecoration(
                  labelText: 'Température de retour (°C)',
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
                  label: 'Pertes de charge',
                  valeur: '${_resultats!['pertesCharge']} bar',
                ),
                _ResultatItem(
                  label: 'Puissance hydraulique',
                  valeur: '${_resultats!['puissanceHydraulique']} kW',
                ),
                _ResultatItem(
                  label: 'Puissance absorbée',
                  valeur: '${_resultats!['puissanceAbsorbee']} kW',
                ),
                _ResultatItem(
                  label: 'Débit de circulation',
                  valeur: '${_resultats!['debitCirculation']} m³/h',
                ),
                _ResultatItem(
                  label: 'Diamètre de la boucle',
                  valeur: '${_resultats!['diametreBoucle']} mm',
                ),
                _ResultatItem(
                  label: 'Vitesse d\'écoulement',
                  valeur: '${_resultats!['vitesse']} m/s',
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
