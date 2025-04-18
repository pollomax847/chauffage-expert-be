import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/collectif_service.dart';

class EmetteursPage extends ConsumerStatefulWidget {
  const EmetteursPage({super.key});

  @override
  ConsumerState<EmetteursPage> createState() => _EmetteursPageState();
}

class _EmetteursPageState extends ConsumerState<EmetteursPage> {
  final _formKey = GlobalKey<FormState>();
  double _puissanceThermique = 0;
  double _temperatureDepart = 0;
  double _temperatureRetour = 0;
  double _temperatureAmbiance = 0;
  String _typeEmetteur = 'radiateur';
  Map<String, double>? _resultat;

  final List<String> _typesEmetteurs = [
    'radiateur',
    'plancherChauffant',
    'ventiloConvecteur',
  ];

  void _calculer() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _resultat = CollectifService.dimensionnerEmetteurs(
          puissanceThermique: _puissanceThermique,
          temperatureDepart: _temperatureDepart,
          temperatureRetour: _temperatureRetour,
          temperatureAmbiance: _temperatureAmbiance,
          typeEmetteur: _typeEmetteur,
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
                      'Dimensionnement des émetteurs de chaleur',
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
                    DropdownButtonFormField<String>(
                      value: _typeEmetteur,
                      decoration: const InputDecoration(
                        labelText: 'Type d\'émetteur',
                        border: OutlineInputBorder(),
                      ),
                      items: _typesEmetteurs.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _typeEmetteur = value!;
                        });
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
                              if (number == null) {
                                return 'Nombre valide requis';
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
                              if (number == null) {
                                return 'Nombre valide requis';
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
                        labelText: 'Température ambiance souhaitée (°C)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une valeur';
                        }
                        final number = double.tryParse(value);
                        if (number == null) {
                          return 'Nombre valide requis';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _temperatureAmbiance = double.parse(value!);
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
                        'Puissance corrigée : ${_resultat!['puissanceCorrigee']?.toStringAsFixed(1) ?? '0'} kW',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Température moyenne de l\'eau : ${_resultat!['temperatureMoyenne']?.toStringAsFixed(1) ?? '0'} °C',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Écart de température : ${_resultat!['deltaT']?.toStringAsFixed(1) ?? '0'} °C',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Surface d\'émission nécessaire : ${_resultat!['surfaceEmission']?.toStringAsFixed(1) ?? '0'} m²',
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
