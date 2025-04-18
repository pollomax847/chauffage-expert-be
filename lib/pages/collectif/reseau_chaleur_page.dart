import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/collectif_service.dart';

class ReseauChaleurPage extends ConsumerStatefulWidget {
  const ReseauChaleurPage({super.key});

  @override
  ConsumerState<ReseauChaleurPage> createState() => _ReseauChaleurPageState();
}

class _ReseauChaleurPageState extends ConsumerState<ReseauChaleurPage> {
  final _formKey = GlobalKey<FormState>();
  double _puissanceThermique = 0;
  double _longueurReseau = 0;
  double _temperatureDepart = 0;
  double _temperatureRetour = 0;
  double _pertesLineaires = 0;
  Map<String, double>? _resultat;

  void _calculer() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _resultat = CollectifService.dimensionnerReseau(
          puissanceThermique: _puissanceThermique,
          longueurReseau: _longueurReseau,
          temperatureDepart: _temperatureDepart,
          temperatureRetour: _temperatureRetour,
          pertesLineaires: _pertesLineaires,
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
                      'Dimensionnement du réseau de chaleur',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Puissance thermique (kW)',
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
                        _puissanceThermique = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Longueur du réseau (m)',
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
                        _longueurReseau = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Température départ (°C)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Obligatoire';
                              }
                              final number = double.tryParse(value);
                              if (number == null || number <= 0) {
                                return 'Température positive requise';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _temperatureDepart = double.parse(value!);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Température retour (°C)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Obligatoire';
                              }
                              final number = double.tryParse(value);
                              if (number == null || number <= 0) {
                                return 'Température positive requise';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _temperatureRetour = double.parse(value!);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Pertes linéaires (W/m)',
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
                        _pertesLineaires = double.parse(value!);
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
                        'Débit volumique : ${_resultat!['debitVolumique']?.toStringAsFixed(1) ?? '0'} m³/h',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Diamètre nominal : ${_resultat!['diametreNominal']?.toStringAsFixed(1) ?? '0'} mm',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pertes de charge linéaires : ${_resultat!['pertesChargeLineaires']?.toStringAsFixed(1) ?? '0'} bar',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pertes thermiques : ${_resultat!['pertesThermiques']?.toStringAsFixed(1) ?? '0'} kW',
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
