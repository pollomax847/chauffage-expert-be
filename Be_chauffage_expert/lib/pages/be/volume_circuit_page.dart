// Be_chauffage_expert/lib/pages/be/volume_circuit_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/be_service.dart';

class VolumeCircuitPage extends ConsumerStatefulWidget {
  const VolumeCircuitPage({super.key});

  @override
  ConsumerState<VolumeCircuitPage> createState() => _VolumeCircuitPageState();
}

class _VolumeCircuitPageState extends ConsumerState<VolumeCircuitPage> {
  final _formKey = GlobalKey<FormState>();
  final _longueurController = TextEditingController();
  final _diametreController = TextEditingController();
  final _volumeRadiateursController = TextEditingController();
  double? _resultat;

  @override
  void dispose() {
    _longueurController.dispose();
    _diametreController.dispose();
    _volumeRadiateursController.dispose();
    super.dispose();
  }

  void _calculerVolume() {
    if (_formKey.currentState!.validate()) {
      final beService = ref.read(beServiceProvider);
      final resultat = beService.calculerVolumeCircuit(
        longueurTuyaux: double.parse(_longueurController.text),
        diametreTuyaux: double.parse(_diametreController.text),
        volumeRadiateurs: double.parse(_volumeRadiateursController.text),
      );
      setState(() {
        _resultat = resultat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcul du Volume du Circuit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _longueurController,
                decoration: const InputDecoration(
                  labelText: 'Longueur totale des tuyaux (m)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la longueur';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diametreController,
                decoration: const InputDecoration(
                  labelText: 'Diamètre des tuyaux (mm)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le diamètre';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _volumeRadiateursController,
                decoration: const InputDecoration(
                  labelText: 'Volume total des radiateurs (L)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le volume';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculerVolume,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Calculer le Volume'),
              ),
              if (_resultat != null) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Résultat',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Volume total du circuit : ${_resultat!.toStringAsFixed(2)} L',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
