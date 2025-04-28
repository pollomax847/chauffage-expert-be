import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chauffage Expert BE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Ouvrir les préférences
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenue dans Chauffage Expert BE',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Menu principal
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: [
                _buildMenuCard(
                  context,
                  'Clients',
                  Icons.people,
                  () => context.go('/clients'),
                ),
                _buildMenuCard(
                  context,
                  'Calculs Chauffage',
                  Icons.whatshot,
                  () {
                    // Ouvrir l'écran de calcul chauffage
                  },
                ),
                _buildMenuCard(
                  context,
                  'Calculs ECS',
                  Icons.water_drop,
                  () {
                    // Ouvrir l'écran de calcul ECS
                  },
                ),
                _buildMenuCard(
                  context,
                  'Calculs VMC',
                  Icons.air,
                  () {
                    // Ouvrir l'écran de calcul VMC
                  },
                ),
                _buildMenuCard(
                  context,
                  'Génération PDF',
                  Icons.picture_as_pdf,
                  () => context.go('/pdf'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Projets récents
            const Text(
              'Projets récents',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Liste de projets récents
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Projet ${index + 1}'),
                  subtitle: Text('Client ${index + 1}'),
                  leading: const Icon(Icons.folder),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Ouvrir le projet
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Créer un nouveau projet
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
