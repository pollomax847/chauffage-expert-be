import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/be_3cep.dart';

class TroisCEPPage extends ConsumerStatefulWidget {
  const TroisCEPPage({super.key});

  @override
  ConsumerState<TroisCEPPage> createState() => _TroisCEPPageState();
}

class _TroisCEPPageState extends ConsumerState<TroisCEPPage> {
  // Contrôleurs pour les champs de saisie
  final _typeBatimentController = TextEditingController();
  final _nombrePersonnesController = TextEditingController();
  final _zoneClimatiqueController = TextEditingController();
  final _temperatureInterieureController = TextEditingController();
  final _coefficientSecuriteController = TextEditingController();
  final _coefficientSimultaneiteECSController = TextEditingController();
  final _tempsRechauffementController = TextEditingController();
  final _penteEUEVController = TextEditingController();

  // Valeurs par défaut pour les surfaces
  final Map<String, double> _surfaces = {
    'murs': 0,
    'plafond': 0,
    'plancher': 0,
    'fenetres': 0,
    'portes': 0,
  };

  // Valeurs par défaut pour les appareils sanitaires
  final Map<String, int> _appareilsSanitaires = {
    'lavabo': 0,
    'evier': 0,
    'bain': 0,
    'douche': 0,
    'wc': 0,
  };

  // Valeurs par défaut pour les locaux
  final Map<String, int> _locaux = {
    'sejour': 0,
    'chambre': 0,
    'cuisine': 0,
    'salle_de_bain': 0,
    'wc': 0,
  };

  // Résultats du calcul
  Map<String, dynamic>? _resultats;

  @override
  void dispose() {
    _typeBatimentController.dispose();
    _nombrePersonnesController.dispose();
    _zoneClimatiqueController.dispose();
    _temperatureInterieureController.dispose();
    _coefficientSecuriteController.dispose();
    _coefficientSimultaneiteECSController.dispose();
    _tempsRechauffementController.dispose();
    _penteEUEVController.dispose();
    super.dispose();
  }

  void _calculer() {
    setState(() {
      _resultats = BE3CEP.calculerInstallation(
        typeBatiment: _typeBatimentController.text,
        nombrePersonnes: int.parse(_nombrePersonnesController.text),
        zoneClimatique: _zoneClimatiqueController.text,
        temperatureInterieure:
            double.parse(_temperatureInterieureController.text),
        surfaces: _surfaces,
        coefficientSecurite: double.parse(_coefficientSecuriteController.text),
        coefficientSimultaneiteECS:
            double.parse(_coefficientSimultaneiteECSController.text),
        tempsRechauffement: double.parse(_tempsRechauffementController.text),
        appareilsSanitaires: _appareilsSanitaires,
        penteEUEV: double.parse(_penteEUEVController.text),
        locaux: _locaux,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Module 3CEP'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section Paramètres Généraux
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Paramètres Généraux',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _typeBatimentController,
                      decoration: const InputDecoration(
                        labelText: 'Type de bâtiment',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nombrePersonnesController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de personnes',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _zoneClimatiqueController,
                      decoration: const InputDecoration(
                        labelText: 'Zone climatique',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _temperatureInterieureController,
                      decoration: const InputDecoration(
                        labelText: 'Température intérieure (°C)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Section Surfaces
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Surfaces (m²)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._surfaces.keys.map((key) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: key,
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _surfaces[key] = double.tryParse(value) ?? 0;
                            },
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Section Appareils Sanitaires
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appareils Sanitaires',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._appareilsSanitaires.keys.map((key) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: key,
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _appareilsSanitaires[key] =
                                  int.tryParse(value) ?? 0;
                            },
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Section Locaux
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Locaux',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._locaux.keys.map((key) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: key,
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _locaux[key] = int.tryParse(value) ?? 0;
                            },
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Section Paramètres de Calcul
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Paramètres de Calcul',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _coefficientSecuriteController,
                      decoration: const InputDecoration(
                        labelText: 'Coefficient de sécurité',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _coefficientSimultaneiteECSController,
                      decoration: const InputDecoration(
                        labelText: 'Coefficient de simultanéité ECS',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _tempsRechauffementController,
                      decoration: const InputDecoration(
                        labelText: 'Temps de réchauffement (h)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _penteEUEVController,
                      decoration: const InputDecoration(
                        labelText: 'Pente EUEV (%)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bouton de calcul
            ElevatedButton(
              onPressed: _calculer,
              child: const Text('Calculer'),
            ),
            const SizedBox(height: 16),

            // Affichage des résultats
            if (_resultats != null) ...[
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
                      // Résultats Chauffage
                      _buildResultSection(
                        'Chauffage',
                        _resultats!['chauffage'],
                      ),
                      const SizedBox(height: 16),
                      // Résultats ECS
                      _buildResultSection(
                        'ECS',
                        _resultats!['ecs'],
                      ),
                      const SizedBox(height: 16),
                      // Résultats EUEV
                      _buildResultSection(
                        'EUEV',
                        _resultats!['euev'],
                      ),
                      const SizedBox(height: 16),
                      // Résultats VMC
                      _buildResultSection(
                        'VMC',
                        _resultats!['vmc'],
                      ),
                      const SizedBox(height: 16),
                      // Recommandations
                      if (_resultats!['recommandations'] != null)
                        _buildRecommandations(
                          _resultats!['recommandations'],
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

  Widget _buildResultSection(String title, Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...data.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text('${entry.key}: ${entry.value}'),
            )),
      ],
    );
  }

  Widget _buildRecommandations(Map<String, dynamic> recommandations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommandations',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...(recommandations['liste'] as List<String>)
            .map((recommandation) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text('• $recommandation'),
                )),
      ],
    );
  }
}
