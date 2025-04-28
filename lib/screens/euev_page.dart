import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/be_euev.dart';

class EUEVPage extends ConsumerStatefulWidget {
  const EUEVPage({super.key});

  @override
  ConsumerState<EUEVPage> createState() => _EUEVPageState();
}

class _EUEVPageState extends ConsumerState<EUEVPage> {
  final _formKey = GlobalKey<FormState>();
  int _nombreEquipements = 0;
  double _pente = 0;
  double _diametre = 0;
  Map<String, dynamic>? _resultats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculs Eaux Usées et Vannes'),
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
                          labelText: 'Nombre d\'équipements',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nombre';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _nombreEquipements = int.parse(value!);
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Pente (%)',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une pente';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _pente = double.parse(value!);
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Diamètre (mm)',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un diamètre';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _diametre = double.parse(value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _resultats = BEEUEV.calculerDebitMax(
                                nombreEquipements: _nombreEquipements,
                                pente: _pente,
                                diametre: _diametre,
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
                            'Débit maximal', '${_resultats!['debitMax']} L/s'),
                        _buildResultat(
                            'Conformité',
                            _resultats!['conforme']
                                ? '✅ Conforme'
                                : '❌ Non conforme'),
                        _buildResultat(
                            'Pente minimale', '${_resultats!['penteMin']}%'),
                        _buildResultat('Diamètre minimal',
                            '${_resultats!['diametreMin']}mm'),
                        if (_resultats!['recommandation'].isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Recommandations:',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(_resultats!['recommandation']),
                        ],
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
