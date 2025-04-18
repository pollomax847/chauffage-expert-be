// Be_chauffage_expert/lib/pages/dimensionnement_page.dart
import 'package:flutter/material.dart';

class DimensionnementPage extends StatelessWidget {
  const DimensionnementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calcul de puissance',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                children: [
                  _buildMenuCard(
                    context,
                    'Gestion des Pièces',
                    Icons.room,
                    'Ajoutez et configurez les pièces de votre projet',
                  ),
                  _buildMenuCard(
                    context,
                    'Configuration Isolation',
                    Icons.house_siding,
                    'Définissez les paramètres d\'isolation',
                  ),
                  _buildMenuCard(
                    context,
                    'Fenêtres & Ventilation',
                    Icons.window,
                    'Configurez les ouvertures et la ventilation',
                  ),
                  _buildMenuCard(
                    context,
                    'Résumé Final',
                    Icons.summarize,
                    'Visualisez le résumé de votre calcul',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implémenter l'export PDF
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Exporter PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    String description,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Implémenter la navigation vers les sous-pages
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
