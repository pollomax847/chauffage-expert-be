// widgets/rapport_thermique_widget.dart
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../models/radiateur.dart';
import '../services/analyse_thermique_service.dart';
import '../services/pdf_service.dart';

class RapportThermiqueWidget extends StatelessWidget {
  final List<Radiateur> radiateurs;

  const RapportThermiqueWidget({Key? key, required this.radiateurs})
      : super(key: key);

  Future<void> _genererEtTelechargerPDF(BuildContext context) async {
    try {
      final entreprise = {
        'nom': 'Chauffage Expert',
        'siret': '123 456 789 00001',
        'tel': '01 23 45 67 89',
      };

      final client = {
        'nom': 'Client Test',
        'adresse': '1 rue du Test, 75000 Paris',
        'date': DateTime.now().toLocal().toString().split(' ')[0],
      };

      final pdf = await PDFService.genererRapportThermiquePDF(
        radiateurs: radiateurs,
        entreprise: entreprise,
        client: client,
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'rapport_thermique.pdf',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la génération du PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final rapportGlobal = AnalyseThermiqueService.genererRapportGlobal(
      radiateurs,
    );
    final synthese = rapportGlobal['synthese'] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rapport d\'analyse thermique',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _genererEtTelechargerPDF(context),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Générer PDF'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSynthese(synthese),
          const SizedBox(height: 24),
          _buildTauxConformite(rapportGlobal),
          const SizedBox(height: 24),
          _buildListeRadiateurs(rapportGlobal['rapportsDetaille'] as List),
        ],
      ),
    );
  }

  Widget _buildSynthese(Map<String, dynamic> synthese) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Synthèse de l\'installation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Puissance totale',
              '${synthese['puissanceTotale'].toStringAsFixed(2)} W',
            ),
            _buildInfoRow(
              'Besoin total',
              '${synthese['besoinTotal'].toStringAsFixed(2)} W',
            ),
            _buildInfoRow(
              'Marge totale',
              '${synthese['margeTotale'].toStringAsFixed(2)} W',
            ),
            _buildInfoRow(
              'Nombre de non-conformités',
              synthese['nombreNonConformes'].toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTauxConformite(Map<String, dynamic> rapport) {
    final taux = double.parse(rapport['tauxConformite']);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Taux de conformité',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CircularProgressIndicator(
              value: taux / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                taux >= 80 ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${taux.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: taux >= 80 ? Colors.green : Colors.orange,
              ),
            ),
            Text(
              '${rapport['nombreConformes']} / ${rapport['nombreRadiateurs']} radiateurs conformes',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListeRadiateurs(List<dynamic> rapports) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Détail des radiateurs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...rapports.map((rapport) => _buildRadiateurCard(rapport)).toList(),
      ],
    );
  }

  Widget _buildRadiateurCard(Map<String, dynamic> rapport) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  rapport['reference'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  rapport['puissanceSuffisante'] && rapport['materiauAdapte']
                      ? Icons.check_circle
                      : Icons.warning,
                  color: rapport['puissanceSuffisante'] &&
                          rapport['materiauAdapte']
                      ? Colors.green
                      : Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Modèle', rapport['modele']),
            _buildInfoRow('Dimensions', rapport['dimensions']),
            _buildInfoRow(
              'Puissance',
              '${rapport['puissance'].toStringAsFixed(2)} W',
            ),
            _buildInfoRow(
              'Besoin thermique',
              '${rapport['besoinThermique'].toStringAsFixed(2)} W',
            ),
            _buildInfoRow(
              'Marge',
              '${rapport['margePuissance'].toStringAsFixed(2)} W',
            ),
            _buildInfoRow('Matériau', rapport['materiauTuyauterie']),
            const SizedBox(height: 8),
            ...(rapport['recommandations'] as List)
                .map(
                  (recommandation) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $recommandation',
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
