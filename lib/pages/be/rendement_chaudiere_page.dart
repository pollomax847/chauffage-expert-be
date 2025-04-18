import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/be_service.dart';

class RendementChaudierePage extends ConsumerStatefulWidget {
  const RendementChaudierePage({super.key});

  @override
  ConsumerState<RendementChaudierePage> createState() =>
      _RendementChaudierePageState();
}

class _RendementChaudierePageState
    extends ConsumerState<RendementChaudierePage> {
  final _formKey = GlobalKey<FormState>();
  String _typeChaudiere = 'gaz';
  double _puissanceNominale = 0;
  double _puissanceUtile = 0;
  double _temperatureFumee = 0;
  double _temperatureExterieure = 0;
  double? _resultat;

  final List<String> _typesChaudiere = ['gaz', 'fioul', 'bois'];

  void _calculer() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _resultat = BEService.calculerRendement(
          typeChaudiere: _typeChaudiere,
          puissanceNominale: _puissanceNominale,
          puissanceUtile: _puissanceUtile,
          temperatureFumee: _temperatureFumee,
          temperatureExterieure: _temperatureExterieure,
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
                      'Calcul du rendement de la chaudière',
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
                        labelText: 'Puissance nominale (kW)',
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
                        _puissanceNominale = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Puissance utile (kW)',
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
                        _puissanceUtile = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Température des fumées (°C)',
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
                        _temperatureFumee = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Température extérieure (°C)',
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
                        _temperatureExterieure = double.parse(value!);
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
                        'Résultat',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rendement de la chaudière : ${_resultat!.toStringAsFixed(1)} %',
                        style: Theme.of(context).textTheme.bodyLarge,
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
