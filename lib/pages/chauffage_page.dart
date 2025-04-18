// pages/chauffage_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/be_chauffage.dart';

class ChauffagePage extends ConsumerStatefulWidget {
  const ChauffagePage({super.key});

  @override
  ConsumerState<ChauffagePage> createState() => _ChauffagePageState();
}

class _ChauffagePageState extends ConsumerState<ChauffagePage> {
  final _formKey = GlobalKey<FormState>();
  double _surface = 0;
  double _hauteurSousPlafond = 2.5;
  double _coefficientIsolation = 1.0;
  Map<String, dynamic>? _resultats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculs Chauffage'),
      ),
      body: SingleChildScrollView(
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
                      const Text(
                        'Paramètres de base',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Surface par logement (m²)',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une surface';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _surface = double.parse(value!);
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Hauteur sous plafond (m)',
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: '2.5',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une hauteur';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _hauteurSousPlafond = double.parse(value!);
                        },
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<double>(
                        decoration: const InputDecoration(
                          labelText: 'Coefficient d\'isolation',
                        ),
                        value: _coefficientIsolation,
                        items: const [
                          DropdownMenuItem(
                            value: 1.0,
                            child: Text('Bonne isolation'),
                          ),
                          DropdownMenuItem(
                            value: 1.2,
                            child: Text('Isolation moyenne'),
                          ),
                          DropdownMenuItem(
                            value: 1.5,
                            child: Text('Mauvaise isolation'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _coefficientIsolation = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _resultats = BEChauffage.calculerPuissance(
                                deperditions:
                                    _surface * _coefficientIsolation * 100,
                                coefficientSecurite: 1.2,
                              );
                            });
                          }
                        },
                        child: const Text('Calculer'),
                      ),
                    ],
                  ),
                ),
              ),
              if (_resultats != null) ...[
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Résultats',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildResultat('Puissance nécessaire',
                            '${_resultats!['puissance']} W'),
                        _buildResultat('Type de générateur',
                            _resultats!['typeGenerateur']),
                        _buildResultat('Surface totale',
                            '${_resultats!['surfaceTotale']} m²'),
                        _buildResultat('Hauteur sous plafond',
                            '${_resultats!['hauteurSousPlafond']} m'),
                        _buildResultat('Coefficient d\'isolation',
                            _resultats!['coefficientIsolation']),
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

  Widget _buildResultat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
