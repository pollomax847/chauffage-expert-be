import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/collectif_service.dart';

class BallonSolairePage extends ConsumerStatefulWidget {
  const BallonSolairePage({super.key});

  @override
  ConsumerState<BallonSolairePage> createState() => _BallonSolairePageState();
}

class _BallonSolairePageState extends ConsumerState<BallonSolairePage> {
  final _formKey = GlobalKey<FormState>();
  int _nombreLogements = 0;
  double _surfaceCapteurs = 0;
  double _consommationECS = 0;
  double _tauxCouverture = 0;
  Map<String, double>? _resultat;

  void _calculer() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _resultat = CollectifService.calculerVolumeBallon(
          nombreLogements: _nombreLogements,
          surfaceCapteurs: _surfaceCapteurs,
          consommationECS: _consommationECS,
          tauxCouverture: _tauxCouverture,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dimensionnement du ballon solaire',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nombre de logements',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une valeur';
                        }
                        final number = int.tryParse(value);
                        if (number == null || number <= 0) {
                          return 'Veuillez entrer un nombre positif';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _nombreLogements = int.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Surface des capteurs (m²)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une valeur';
                        }
                        final number = double.tryParse(value);
                        if (number == null || number <= 0) {
                          return 'Veuillez entrer un nombre positif';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _surfaceCapteurs = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Consommation ECS (L/personne/jour)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une valeur';
                        }
                        final number = double.tryParse(value);
                        if (number == null || number <= 0) {
                          return 'Veuillez entrer un nombre positif';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _consommationECS = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Taux de couverture souhaité (%)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une valeur';
                        }
                        final number = double.tryParse(value);
                        if (number == null || number <= 0 || number > 100) {
                          return 'Veuillez entrer un pourcentage entre 0 et 100';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _tauxCouverture = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _calculer,
                      child: const Text('Calculer'),
                    ),
                  ],
                ),
              ),
            ),
            if (_resultat != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Résultats',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Volume minimal selon surface : ${_resultat!['volumeMinimal']?.toStringAsFixed(1) ?? '0'} L',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Volume selon consommation : ${_resultat!['volumeConsommation']?.toStringAsFixed(1) ?? '0'} L',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Volume selon couverture : ${_resultat!['volumeCouverture']?.toStringAsFixed(1) ?? '0'} L',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Volume final recommandé : ${_resultat!['volumeFinal']?.toStringAsFixed(1) ?? '0'} L',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
