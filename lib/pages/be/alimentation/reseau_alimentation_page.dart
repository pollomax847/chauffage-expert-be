import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/be_alimentation.dart';

class ReseauAlimentationPage extends ConsumerStatefulWidget {
  const ReseauAlimentationPage({super.key});

  @override
  ConsumerState<ReseauAlimentationPage> createState() =>
      _ReseauAlimentationPageState();
}

class _ReseauAlimentationPageState
    extends ConsumerState<ReseauAlimentationPage> {
  final _formKey = GlobalKey<FormState>();
  final _longueurController = TextEditingController();
  final _pressionEntreeController = TextEditingController();
  final _pressionMinimaleController = TextEditingController();
  final _nombreLogementsController = TextEditingController();
  final _nombreEtagesController = TextEditingController();
  final _hauteurEtageController = TextEditingController();
  final Map<String, int> _appareils = {
    'lavabo': 0,
    'evier': 0,
    'douche': 0,
    'baignoire': 0,
    'wc': 0,
    'lave_linge': 0,
    'lave_vaisselle': 0,
    'bidet': 0,
  };
  Map<String, dynamic>? _resultats;

  @override
  void dispose() {
    _longueurController.dispose();
    _pressionEntreeController.dispose();
    _pressionMinimaleController.dispose();
    _nombreLogementsController.dispose();
    _nombreEtagesController.dispose();
    _hauteurEtageController.dispose();
    super.dispose();
  }

  void _calculer() {
    if (_formKey.currentState!.validate()) {
      final resultats = BEAlimentation.dimensionnerReseau(
        appareils: _appareils,
        longueur: double.parse(_longueurController.text),
        pressionEntree: double.parse(_pressionEntreeController.text),
        pressionMinimale: double.parse(_pressionMinimaleController.text),
        nombreLogements: int.parse(_nombreLogementsController.text),
        nombreEtages: int.parse(_nombreEtagesController.text),
        hauteurEtage: double.parse(_hauteurEtageController.text),
      );
      setState(() => _resultats = resultats);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réseau d\'Alimentation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Configuration du réseau :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _longueurController,
                decoration: const InputDecoration(
                  labelText: 'Longueur du réseau (m)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une longueur';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pressionEntreeController,
                decoration: const InputDecoration(
                  labelText: 'Pression d\'entrée (bar)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une pression';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pressionMinimaleController,
                decoration: const InputDecoration(
                  labelText: 'Pression minimale requise (bar)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une pression minimale';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreLogementsController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de logements',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nombre de logements';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreEtagesController,
                decoration: const InputDecoration(
                  labelText: 'Nombre d\'étages',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nombre d\'étages';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hauteurEtageController,
                decoration: const InputDecoration(
                  labelText: 'Hauteur d\'étage (m)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la hauteur d\'étage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Nombre d\'appareils par logement :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              ..._appareils.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.key.replaceAll('_', ' ').toUpperCase(),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          initialValue: entry.value.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _appareils[entry.key] = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'Calculer',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              if (_resultats != null) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Résultats :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Divider(),
                        _buildResultRow(
                          'Débit total',
                          '${_resultats!['debitTotal']} L/s',
                        ),
                        _buildResultRow(
                          'Diamètre théorique',
                          '${_resultats!['diametreTheorique']} mm',
                        ),
                        _buildResultRow(
                          'Pertes de charge',
                          '${_resultats!['pertesCharge']} bar',
                        ),
                        _buildResultRow(
                          'Pression minimale requise',
                          '${_resultats!['pressionMinimaleRequise']} bar',
                        ),
                        _buildResultRow(
                          'Pression disponible',
                          '${_resultats!['pressionDisponible']} bar',
                        ),
                        _buildResultRow(
                          'Vitesse d\'écoulement',
                          '${_resultats!['vitesse']} m/s',
                        ),
                        _buildResultRow(
                          'Hauteur totale',
                          '${_resultats!['hauteurTotale']} m',
                        ),
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

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
