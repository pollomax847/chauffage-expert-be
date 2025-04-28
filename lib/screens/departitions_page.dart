import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/be_departitions.dart';

class DepartitionsPage extends ConsumerStatefulWidget {
  const DepartitionsPage({super.key});

  @override
  ConsumerState<DepartitionsPage> createState() => _DepartitionsPageState();
}

class _DepartitionsPageState extends ConsumerState<DepartitionsPage> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _pieces = [];
  String _anneeConstruction = '2013-2020';
  double _temperatureExterieure = -8.0;
  int _dju = 2288;
  double _rendement = 0.85;
  bool _estNeuf = true;
  Map<String, dynamic>? _resultats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcul des Déperditions'),
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
                        'Paramètres généraux',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _anneeConstruction,
                        decoration: const InputDecoration(
                          labelText: 'Année de construction',
                        ),
                        items: BEDepartitions.coefficientsDep.keys
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _anneeConstruction = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Température extérieure de base (°C)',
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _temperatureExterieure.toString(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une température';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _temperatureExterieure = double.parse(value!);
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Degré jour unifié (DJU)',
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _dju.toString(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un DJU';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _dju = int.parse(value!);
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Rendement de l\'installation',
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _rendement.toString(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un rendement';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _rendement = double.parse(value!);
                        },
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        title: const Text('Bâtiment neuf'),
                        value: _estNeuf,
                        onChanged: (bool value) {
                          setState(() {
                            _estNeuf = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _ajouterPiece,
                child: const Text('Ajouter une pièce'),
              ),
              const SizedBox(height: 16),
              ..._pieces.map((piece) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            piece['nom'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Surface: ${piece['surface']} m²'),
                          Text('Hauteur: ${piece['hauteurSousPlafond']} m'),
                          Text(
                              'Température: ${piece['temperatureAmbiante']} °C'),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      _resultats = BEDepartitions.calculerDepPerditionsTotal(
                        pieces: _pieces,
                        temperatureExterieure: _temperatureExterieure,
                      );
                    });
                  }
                },
                child: const Text('Calculer'),
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
                        _buildResultat('Déperditions totales',
                            '${_resultats!['totalDeperditions']} W'),
                        ..._resultats!['pieces'].map<Widget>((piece) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  piece['nom'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _buildResultat('Déperditions',
                                    '${piece['deperditions']} W'),
                                _buildResultat(
                                    'Volume', '${piece['volume']} m³'),
                                _buildResultat(
                                    'Coefficient', piece['coefficient']),
                                _buildResultat('ΔT', '${piece['deltaT']} °C'),
                              ],
                            )),
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

  void _ajouterPiece() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle pièce'),
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nom de la pièce',
                ),
                onSaved: (value) {
                  _pieces.add({
                    'nom': value,
                    'anneeConstruction': _anneeConstruction,
                    'surface': double.parse(_surfaceController.text),
                    'hauteurSousPlafond': double.parse(_hauteurController.text),
                    'temperatureAmbiante':
                        double.parse(_temperatureController.text),
                  });
                },
              ),
              TextFormField(
                controller: _surfaceController,
                decoration: const InputDecoration(
                  labelText: 'Surface (m²)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _hauteurController,
                decoration: const InputDecoration(
                  labelText: 'Hauteur sous plafond (m)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _temperatureController,
                decoration: const InputDecoration(
                  labelText: 'Température ambiante (°C)',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              if (_surfaceController.text.isNotEmpty &&
                  _hauteurController.text.isNotEmpty &&
                  _temperatureController.text.isNotEmpty) {
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  final _surfaceController = TextEditingController();
  final _hauteurController = TextEditingController();
  final _temperatureController = TextEditingController();

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
