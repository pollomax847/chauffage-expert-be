import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/be_service.dart';

class EquilibragePage extends ConsumerStatefulWidget {
  const EquilibragePage({super.key});

  @override
  ConsumerState<EquilibragePage> createState() => _EquilibragePageState();
}

class _EquilibragePageState extends ConsumerState<EquilibragePage> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _radiateurs = [];
  final List<Map<String, dynamic>> _planchers = [];
  Map<String, dynamic>? _resultat;

  void _ajouterRadiateur() {
    setState(() {
      _radiateurs.add({
        'puissance': 0.0,
        'deltaT': 0.0,
        'typeTube': 'cuivre',
        'longueur': 0.0,
        'nombreCoudes': 0,
      });
    });
  }

  void _ajouterPlancher() {
    setState(() {
      _planchers.add({
        'puissance': 0.0,
        'deltaT': 0.0,
        'typeTube': 'per',
        'longueur': 0.0,
        'nombreCoudes': 0,
      });
    });
  }

  void _calculer() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _resultat = BEService.calculerEquilibrage(
          radiateurs: _radiateurs,
          planchers: _planchers,
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
        child: SingleChildScrollView(
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
                        'Équilibrage du réseau',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Radiateurs',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ..._radiateurs.asMap().entries.map((entry) {
                        final index = entry.key;
                        final radiateur = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Radiateur ${index + 1}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Puissance (kW)',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Obligatoire';
                                        }
                                        final number = double.tryParse(value);
                                        if (number == null || number <= 0) {
                                          return 'Valeur positive requise';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _radiateurs[index]['puissance'] =
                                            double.parse(value!);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'ΔT (°C)',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Obligatoire';
                                        }
                                        final number = double.tryParse(value);
                                        if (number == null || number <= 0) {
                                          return 'Valeur positive requise';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _radiateurs[index]['deltaT'] =
                                            double.parse(value!);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: radiateur['typeTube'],
                                      decoration: const InputDecoration(
                                        labelText: 'Type de tube',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: ['cuivre', 'per', 'acier']
                                          .map((type) {
                                        return DropdownMenuItem(
                                          value: type,
                                          child: Text(type.toUpperCase()),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _radiateurs[index]['typeTube'] =
                                              value!;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Longueur (m)',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Obligatoire';
                                        }
                                        final number = double.tryParse(value);
                                        if (number == null || number <= 0) {
                                          return 'Valeur positive requise';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _radiateurs[index]['longueur'] =
                                            double.parse(value!);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Nombre de coudes',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Obligatoire';
                                  }
                                  final number = int.tryParse(value);
                                  if (number == null || number < 0) {
                                    return 'Nombre positif requis';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _radiateurs[index]['nombreCoudes'] =
                                      int.parse(value!);
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _ajouterRadiateur,
                        child: const Text('Ajouter un radiateur'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Planchers chauffants',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ..._planchers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final plancher = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Plancher ${index + 1}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Puissance (kW)',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Obligatoire';
                                        }
                                        final number = double.tryParse(value);
                                        if (number == null || number <= 0) {
                                          return 'Valeur positive requise';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _planchers[index]['puissance'] =
                                            double.parse(value!);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'ΔT (°C)',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Obligatoire';
                                        }
                                        final number = double.tryParse(value);
                                        if (number == null || number <= 0) {
                                          return 'Valeur positive requise';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _planchers[index]['deltaT'] =
                                            double.parse(value!);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: plancher['typeTube'],
                                      decoration: const InputDecoration(
                                        labelText: 'Type de tube',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: ['cuivre', 'per', 'acier']
                                          .map((type) {
                                        return DropdownMenuItem(
                                          value: type,
                                          child: Text(type.toUpperCase()),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _planchers[index]['typeTube'] =
                                              value!;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Longueur (m)',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Obligatoire';
                                        }
                                        final number = double.tryParse(value);
                                        if (number == null || number <= 0) {
                                          return 'Valeur positive requise';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _planchers[index]['longueur'] =
                                            double.parse(value!);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Nombre de coudes',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Obligatoire';
                                  }
                                  final number = int.tryParse(value);
                                  if (number == null || number < 0) {
                                    return 'Nombre positif requis';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _planchers[index]['nombreCoudes'] =
                                      int.parse(value!);
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _ajouterPlancher,
                        child: const Text('Ajouter un plancher'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculer,
                child: const Text('Calculer l\'équilibrage'),
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
                          'Radiateurs',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        ...(_resultat!['radiateurs'] as List)
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final resultat = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Radiateur ${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Débit : ${resultat['debit'].toStringAsFixed(2)} m³/h',
                                ),
                                Text(
                                  'Pertes de charge : ${resultat['pertesCharge'].toStringAsFixed(2)} kPa',
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                        Text(
                          'Planchers chauffants',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        ...(_resultat!['planchers'] as List)
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final resultat = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Plancher ${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Débit : ${resultat['debit'].toStringAsFixed(2)} m³/h',
                                ),
                                Text(
                                  'Pertes de charge : ${resultat['pertesCharge'].toStringAsFixed(2)} kPa',
                                ),
                              ],
                            ),
                          );
                        }),
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
