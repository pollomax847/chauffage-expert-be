import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/be_vmc.dart';

class VMCPage extends ConsumerStatefulWidget {
  const VMCPage({super.key});

  @override
  ConsumerState<VMCPage> createState() => _VMCPageState();
}

class _VMCPageState extends ConsumerState<VMCPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, int> _locaux = {
    'sejour': 0,
    'chambre': 0,
    'cuisine': 0,
    'salle_de_bain': 0,
    'wc': 0,
    'buanderie': 0,
    'garage': 0,
  };
  double _longueur = 0;
  double _diametre = 0;
  int _nombreCoudes = 0;
  double _rendement = 0.7;
  int _nombreLogements = 0;
  double _tauxOccupation = 0.7;
  String _typeVMC = 'simple flux';
  bool _avecBallonThermodynamique = false;
  Map<String, dynamic>? _resultatDebit;
  Map<String, dynamic>? _resultatPertes;
  Map<String, dynamic>? _resultatPuissance;
  Map<String, dynamic>? _resultatCaisson;

  void _calculer() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _resultatDebit = BEVMC.calculerDebitTotal(locaux: _locaux);
        if (_resultatDebit != null) {
          final debitTotal = double.parse(_resultatDebit!['debitTotal']);
          _resultatPertes = BEVMC.calculerPertesCharge(
            debit: debitTotal,
            longueur: _longueur,
            diametre: _diametre,
            nombreCoudes: _nombreCoudes,
          );
          if (_resultatPertes != null) {
            final pertesTotales =
                double.parse(_resultatPertes!['pertesTotales']);
            _resultatPuissance = BEVMC.calculerPuissanceVentilateur(
              debit: debitTotal,
              pertesCharge: pertesTotales,
              rendement: _rendement,
            );
          }
        }
        _resultatCaisson = BEVMC.recommanderDebitCaisson(
          nombreLogements: _nombreLogements,
          tauxOccupation: _tauxOccupation,
          typeVMC: _typeVMC,
          avecBallonThermodynamique: _avecBallonThermodynamique,
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
                      'Dimensionnement de la VMC',
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
                        labelText: 'Taux d\'occupation (0-1)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une valeur';
                        }
                        final number = double.tryParse(value);
                        if (number == null || number <= 0 || number > 1) {
                          return 'Veuillez entrer un nombre entre 0 et 1';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _tauxOccupation = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Type de VMC',
                        border: OutlineInputBorder(),
                      ),
                      value: _typeVMC,
                      items: const [
                        DropdownMenuItem(
                          value: 'simple flux',
                          child: Text('Simple flux'),
                        ),
                        DropdownMenuItem(
                          value: 'double flux',
                          child: Text('Double flux'),
                        ),
                        DropdownMenuItem(
                          value: 'hygroréglable',
                          child: Text('Hygroréglable'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _typeVMC = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Avec ballon thermodynamique'),
                      value: _avecBallonThermodynamique,
                      onChanged: (value) {
                        setState(() {
                          _avecBallonThermodynamique = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ..._locaux.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText:
                                'Nombre de ${entry.key.replaceAll('_', ' ')}',
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer une valeur';
                            }
                            final number = int.tryParse(value);
                            if (number == null || number < 0) {
                              return 'Veuillez entrer un nombre positif';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _locaux[entry.key] = int.parse(value!);
                          },
                        ),
                      );
                    }).toList(),
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
                        _longueur = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Diamètre du réseau (mm)',
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
                        _diametre = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nombre de coudes',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une valeur';
                        }
                        final number = int.tryParse(value);
                        if (number == null || number < 0) {
                          return 'Veuillez entrer un nombre positif';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _nombreCoudes = int.parse(value!);
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
            if (_resultatDebit != null &&
                _resultatPertes != null &&
                _resultatPuissance != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Résultats du réseau',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Débit total : ${_resultatDebit!['debitTotal']} m³/h',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pertes de charge linéaires : ${_resultatPertes!['pertesLineaires']} Pa',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pertes de charge singulières : ${_resultatPertes!['pertesSingulieres']} Pa',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pertes de charge totales : ${_resultatPertes!['pertesTotales']} Pa',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Vitesse d\'écoulement : ${_resultatPertes!['vitesse']} m/s',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Puissance du ventilateur : ${_resultatPuissance!['puissance']} W',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rendement : ${_resultatPuissance!['rendement']}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (_resultatCaisson != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommandation du caisson VMC',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Débit de base : ${_resultatCaisson!['debitBase']} m³/h/logement',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Débit total recommandé : ${_resultatCaisson!['debitTotal']} m³/h',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Puissance recommandée : ${_resultatCaisson!['puissance']} W',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Consommation annuelle VMC : ${_resultatCaisson!['consommationAnnuelle']} kWh',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      if (_resultatCaisson!['avecBallonThermodynamique']) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Puissance du ballon : ${_resultatCaisson!['puissanceBallon']} W',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'COP du ballon : ${_resultatCaisson!['copBallon']}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Consommation du ballon : ${_resultatCaisson!['consommationBallon']} kWh/an',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Consommation totale : ${_resultatCaisson!['consommationTotale']} kWh/an',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
