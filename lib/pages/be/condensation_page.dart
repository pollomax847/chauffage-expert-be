import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/be_service.dart';

class CondensationPage extends ConsumerStatefulWidget {
  const CondensationPage({super.key});

  @override
  ConsumerState<CondensationPage> createState() => _CondensationPageState();
}

class _CondensationPageState extends ConsumerState<CondensationPage> {
  final _formKey = GlobalKey<FormState>();
  String _typeChaudiere = 'gaz';
  double _temperatureRetour = 0;
  double _humiditeRelative = 50;
  Map<String, dynamic>? _resultat;

  final List<String> _typesChaudiere = ['gaz', 'fioul', 'bois'];

  void _calculer() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _resultat = BEService.estimerCondensation(
          temperatureRetour: _temperatureRetour,
          typeChaudiere: _typeChaudiere,
          humiditeRelative: _humiditeRelative,
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
                      'Estimation du risque de condensation',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _typeChaudiere,
                      decoration: const InputDecoration(
                        labelText: 'Type de chaudière',
                        border: OutlineInputBorder(),
                      ),
                      items: _typesChaudiere.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _typeChaudiere = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Température de retour (°C)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une valeur';
                        }
                        final number = double.tryParse(value);
                        if (number == null) {
                          return 'Veuillez entrer un nombre valide';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _temperatureRetour = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Humidité relative (%)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _humiditeRelative.toString(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une valeur';
                        }
                        final number = double.tryParse(value);
                        if (number == null || number < 0 || number > 100) {
                          return 'Veuillez entrer un pourcentage entre 0 et 100';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _humiditeRelative = double.parse(value!);
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
                        'Point de rosée : ${_resultat!['pointRosee'].toStringAsFixed(1)} °C',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Taux de condensation : ${_resultat!['tauxCondensation'].toStringAsFixed(1)} %',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Risque de condensation : ${_resultat!['condensationPossible'] ? 'OUI' : 'NON'}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _resultat!['condensationPossible']
                              ? Colors.red
                              : Colors.green,
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
