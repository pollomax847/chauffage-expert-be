import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/be_ecs.dart';

class ECSPage extends ConsumerStatefulWidget {
  const ECSPage({super.key});

  @override
  ConsumerState<ECSPage> createState() => _ECSPageState();
}

class _ECSPageState extends ConsumerState<ECSPage> {
  final _formKey = GlobalKey<FormState>();
  int _nombreLogements = 0;
  int _nombreEtages = 0;
  int _nombrePointsEau = 0;
  Map<String, dynamic>? _resultats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculs Eau Chaude Sanitaire'),
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
                          labelText: 'Nombre de logements',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nombre';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _nombreLogements = int.parse(value!);
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nombre d\'étages',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nombre';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _nombreEtages = int.parse(value!);
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nombre de points d\'eau par logement',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nombre';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _nombrePointsEau = int.parse(value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _resultats = BEECS.calculerDebitTotal(
                                nombreLogements: _nombreLogements,
                                nombreEtages: _nombreEtages,
                                nombrePointsEau: _nombrePointsEau,
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
                        _buildResultat(
                            'Débit total', '${_resultats!['debitTotal']} L/s'),
                        _buildResultat('Diamètre recommandé',
                            '${_resultats!['diametre']} mm'),
                        _buildResultat('Coefficient de simultanéité',
                            _resultats!['coefficientSimultaneite']),
                        _buildResultat('Nombre total de points d\'eau',
                            _resultats!['nombrePointsTotal']),
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
