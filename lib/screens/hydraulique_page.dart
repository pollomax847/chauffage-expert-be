import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/be_hydraulique.dart';

class HydrauliquePage extends ConsumerStatefulWidget {
  const HydrauliquePage({super.key});

  @override
  ConsumerState<HydrauliquePage> createState() => _HydrauliquePageState();
}

class _HydrauliquePageState extends ConsumerState<HydrauliquePage> {
  final _formKey = GlobalKey<FormState>();
  String _typeBatiment = 'maison_individuelle';
  final Map<String, int> _appareils = {};
  double _vitesseMaximale = 1.5;
  double _longueur = 10.0;
  int _nombreCoudes = 2;
  double _rugosite = 0.1;
  Map<String, dynamic>? _resultatsDebit;
  Map<String, dynamic>? _resultatsDiametre;
  Map<String, dynamic>? _resultatsPertes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcul Hydraulique'),
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
                        value: _typeBatiment,
                        decoration: const InputDecoration(
                          labelText: 'Type de bâtiment',
                        ),
                        items: BEHydraulique.coefficientsSimultaneite.keys
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.replaceAll('_', ' ')),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _typeBatiment = newValue!;
                          });
                        },
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
                      const Text(
                        'Appareils sanitaires',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...BEHydraulique.debitsUnitaires.keys.map((appareil) {
                        return Row(
                          children: [
                            Expanded(
                              child: Text(appareil.replaceAll('_', ' ')),
                            ),
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Nombre',
                                ),
                                keyboardType: TextInputType.number,
                                initialValue:
                                    _appareils[appareil]?.toString() ?? '0',
                                onChanged: (value) {
                                  _appareils[appareil] =
                                      int.tryParse(value) ?? 0;
                                },
                              ),
                            ),
                          ],
                        );
                      }),
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
                      const Text(
                        'Paramètres de calcul',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Vitesse maximale (m/s)',
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _vitesseMaximale.toString(),
                        onChanged: (value) {
                          _vitesseMaximale = double.tryParse(value) ?? 1.5;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Longueur de la canalisation (m)',
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _longueur.toString(),
                        onChanged: (value) {
                          _longueur = double.tryParse(value) ?? 10.0;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nombre de coudes',
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _nombreCoudes.toString(),
                        onChanged: (value) {
                          _nombreCoudes = int.tryParse(value) ?? 2;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Rugosité (mm)',
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _rugosite.toString(),
                        onChanged: (value) {
                          _rugosite = double.tryParse(value) ?? 0.1;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculer,
                child: const Text('Calculer'),
              ),
              if (_resultatsDebit != null) ...[
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Résultats du débit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildResultat('Débit probable',
                            '${_resultatsDebit!['debitProbable']} l/s'),
                        _buildResultat('Coefficient de simultanéité',
                            _resultatsDebit!['coefficientSimultaneite']),
                        _buildResultat('Somme des débits unitaires',
                            '${_resultatsDebit!['sommeDebitsUnitaires']} l/s'),
                      ],
                    ),
                  ),
                ),
              ],
              if (_resultatsDiametre != null) ...[
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Résultats du diamètre',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildResultat('Diamètre intérieur',
                            '${_resultatsDiametre!['diametreInterieur']} mm'),
                        _buildResultat('Diamètre nominal',
                            '${_resultatsDiametre!['diametreNominal']} mm'),
                        _buildResultat(
                            'Section', '${_resultatsDiametre!['section']} m²'),
                        _buildResultat(
                            'Vitesse', '${_resultatsDiametre!['vitesse']} m/s'),
                      ],
                    ),
                  ),
                ),
              ],
              if (_resultatsPertes != null) ...[
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Résultats des pertes de charge',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildResultat('Pertes linéaires',
                            '${_resultatsPertes!['pertesLineaires']} mCE'),
                        _buildResultat('Pertes singulières',
                            '${_resultatsPertes!['pertesSingulieres']} mCE'),
                        _buildResultat('Pertes totales',
                            '${_resultatsPertes!['pertesTotales']} mCE'),
                        _buildResultat(
                            'Vitesse', '${_resultatsPertes!['vitesse']} m/s'),
                        _buildResultat('Nombre de Reynolds',
                            _resultatsPertes!['reynolds']),
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

  void _calculer() {
    setState(() {
      _resultatsDebit = BEHydraulique.calculerDebitProbable(
        typeBatiment: _typeBatiment,
        appareils: _appareils,
      );

      final debit = double.parse(_resultatsDebit!['debitProbable']);
      _resultatsDiametre = BEHydraulique.calculerDiametre(
        debit: debit,
        vitesseMaximale: _vitesseMaximale,
      );

      final diametre = double.parse(_resultatsDiametre!['diametreNominal']);
      _resultatsPertes = BEHydraulique.calculerPertesCharge(
        debit: debit,
        diametre: diametre,
        longueur: _longueur,
        nombreCoudes: _nombreCoudes,
        rugosite: _rugosite,
      );
    });
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
