// pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/theme_card.dart';
import 'preferences_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chauffage Expert'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreferencesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bienvenue dans Chauffage Expert',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              'Sélectionnez une fonctionnalité :',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                ThemeCard(
                  title: 'Dimensionnement',
                  icon: Icons.calculate,
                  description:
                      'Calculs de puissance et dimensionnement des installations',
                  onTap: () => context.go('/dimensionnement'),
                ),
                ThemeCard(
                  title: 'Bureau d\'Étude',
                  icon: Icons.engineering,
                  description: 'Études techniques et calculs détaillés',
                  onTap: () => context.go('/bureau-etude'),
                ),
                ThemeCard(
                  title: 'Réglementation Gaz',
                  icon: Icons.safety_check,
                  description:
                      'Vérification des conformités et réglementations',
                  onTap: () => context.go('/reglementation'),
                ),
                ThemeCard(
                  title: 'Exportation PDF',
                  icon: Icons.picture_as_pdf,
                  description: 'Génération de rapports et documents techniques',
                  onTap: () => context.go('/export'),
                ),
                ThemeCard(
                  title: 'Gestion des Données',
                  icon: Icons.storage,
                  description: 'Gestion et sauvegarde des données techniques',
                  onTap: () => context.go('/gestion-donnees'),
                ),
                ThemeCard(
                  title: 'Radiateurs',
                  icon: Icons.heating,
                  description: 'Visualisation des radiateurs de test',
                  onTap: () => context.go('/radiateurs'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
