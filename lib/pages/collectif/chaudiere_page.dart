// pages/collectif/chaudiere_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/collectif_service.dart';

class ChaudierePage extends ConsumerStatefulWidget {
  const ChaudierePage({super.key});

  @override
  ConsumerState<ChaudierePage> createState() => _ChaudierePageState();
}

class _ChaudierePageState extends ConsumerState<ChaudierePage> {
  final _formKey = GlobalKey<FormState>();
  int _nombreLogements = 0;
  double _surfaceChauffee = 0;
  String _isolation = 'moyenne';
  double _temperatureExterieure = 0;
  double _temperatureInterieure = 0;
  Map<String, double>? _resultat;

  final List<String> _niveauxIsolation = [
    'excellente',
    'bonne',
    'moyenne',
    'mauvaise',
  ];

  void _calculer() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _resultat = CollectifService.calculerPuissanceChaudiere(
          nombreLogements: _nombreLogements,
          surfaceChauffee: _surfaceChauffee,
          isolation: _isolation,
          temperatureExterieure: _temperatureExterieure,
          temperatureInterieure: _temperatureInterieure,
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
                      'Dimensionnement de la chaudière collective',
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
                        labelText: 'Surface chauffée totale (m²)',
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
                        _surfaceChauffee = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _isolation,
                      decoration: const InputDecoration(
                        labelText: 'Niveau d\'isolation',
                        border: OutlineInputBorder(),
                      ),
                      items: _niveauxIsolation.map((niveau) {
                        return DropdownMenuItem(
                          value: niveau,
                          child: Text(niveau.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _isolation = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Température extérieure (°C)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Obligatoire';
                              }
                              final number = double.tryParse(value);
                              if (number == null) {
                                return 'Nombre valide requis';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _temperatureExterieure = double.parse(value!);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Température intérieure (°C)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Obligatoire';
                              }
                              final number = double.tryParse(value);
                              if (number == null) {
                                return 'Nombre valide requis';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _temperatureInterieure = double.parse(value!);
                            },
                          ),
                        ),
                      ],
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
                        'Puissance de base : ${(_resultat!['puissanceBase'] as num?)?.toStringAsFixed(1) ?? '0.0'} W/m²',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Coefficient température : ${(_resultat!['coefficientTemperature'] as num?)?.toStringAsFixed(1) ?? '0.0'}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Puissance totale recommandée : ${(_resultat!['puissanceTotale'] as num?)?.toStringAsFixed(1) ?? '0.0'} kW',
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
