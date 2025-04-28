import 'package:flutter/material.dart';
import '../data/radiateurs_test.dart';
import '../widgets/rapport_thermique_widget.dart';

class RadiateursPage extends StatelessWidget {
  const RadiateursPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Extraction des données nécessaires pour RapportThermiqueWidget
    final besoinsThermiques =
        radiateursTest.map((r) => r.besoinThermique).toList();
    final materiauxTuyauterie =
        radiateursTest.map((r) => r.materiauTuyauterie).toList();
    final identifications =
        radiateursTest.map((r) => r.identification).toList();
    final modeles = radiateursTest.map((r) => r.modele).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Radiateurs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Liste des radiateurs de test',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: radiateursTest.length,
              itemBuilder: (context, index) {
                final radiateur = radiateursTest[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(
                        '${radiateur.modele} - ${radiateur.identification}'),
                    subtitle: Text(
                      'Puissance: ${radiateur.puissance} W - Besoin: ${radiateur.besoinThermique} W',
                    ),
                    trailing: Icon(
                      radiateur.puissance >= radiateur.besoinThermique
                          ? Icons.check_circle
                          : Icons.warning,
                      color: radiateur.puissance >= radiateur.besoinThermique
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: const Text('Rapport Thermique')),
                      body: RapportThermiqueWidget(
                        radiateurs: radiateursTest,
                        besoinsThermiques: besoinsThermiques,
                        materiauxTuyauterie: materiauxTuyauterie,
                        identifications: identifications,
                        modeles: modeles,
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Voir le rapport thermique'),
            ),
          ),
        ],
      ),
    );
  }
}
