import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/be_alimentation.dart';

class ReseauPage extends ConsumerStatefulWidget {
  const ReseauPage({super.key});

  @override
  ConsumerState<ReseauPage> createState() => _ReseauPageState();
}

class _ReseauPageState extends ConsumerState<ReseauPage> {
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
        title: const Text('Dimensionnement Réseau'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Nombre d\'appareils par logement :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._appareils.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(entry.key.replaceAll('_', ' ')),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          initialValue: entry.value.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _appareils[entry.key] = int.tryParse(value) ?? 0;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '0';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Nombre invalide';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              TextFormField(
                controller: _longueurController,
                decoration: const InputDecoration(
                  labelText: 'Longueur du réseau (m)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (double.parse(value) <= 0) {
                    return 'La longueur doit être positive';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pressionEntreeController,
                decoration: const InputDecoration(
                  labelText: 'Pression d\'entrée (bar)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (double.parse(value) <= 0) {
                    return 'La pression doit être positive';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pressionMinimaleController,
                decoration: const InputDecoration(
                  labelText: 'Pression minimale (bar)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (double.parse(value) <= 0) {
                    return 'La pression doit être positive';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreLogementsController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de logements',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Le nombre doit être positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreEtagesController,
                decoration: const InputDecoration(
                  labelText: 'Nombre d\'étages',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Le nombre doit être positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hauteurEtageController,
                decoration: const InputDecoration(
                  labelText: 'Hauteur d\'étage (m)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (double.parse(value) <= 0) {
                    return 'La hauteur doit être positive';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculer,
                child: const Text('Calculer'),
              ),
              if (_resultats != null) ...[
                const SizedBox(height: 24),
                const Text(
                  'Résultats :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _ResultatItem(
                  label: 'Débit total',
                  valeur: '${_resultats!['debitTotal']} L/s',
                ),
                _ResultatItem(
                  label: 'Diamètre théorique',
                  valeur: '${_resultats!['diametreTheorique']} mm',
                ),
                _ResultatItem(
                  label: 'Pertes de charge',
                  valeur: '${_resultats!['pertesCharge']} bar',
                ),
                _ResultatItem(
                  label: 'Pression minimale requise',
                  valeur: '${_resultats!['pressionMinimaleRequise']} bar',
                ),
                _ResultatItem(
                  label: 'Pression disponible',
                  valeur: '${_resultats!['pressionDisponible']} bar',
                ),
                _ResultatItem(
                  label: 'Vitesse d\'écoulement',
                  valeur: '${_resultats!['vitesse']} m/s',
                ),
                _ResultatItem(
                  label: 'Hauteur totale',
                  valeur: '${_resultats!['hauteurTotale']} m',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Débits par appareil :',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...(_resultats!['debitsParAppareil'] as Map<String, double>)
                    .entries
                    .map((entry) => _ResultatItem(
                          label: entry.key.replaceAll('_', ' '),
                          valeur: '${entry.value.toStringAsFixed(2)} L/s',
                        ))
                    ,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultatItem extends StatelessWidget {
  final String label;
  final String valeur;

  const _ResultatItem({
    required this.label,
    required this.valeur,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            valeur,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
