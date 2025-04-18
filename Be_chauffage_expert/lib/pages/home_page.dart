// Be_chauffage_expert/lib/pages/home_page.dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenue sur Chauffage Expert',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildFeatureCard(
                context,
                'Dimensionnement',
                Icons.calculate,
                'Calculez et dimensionnez vos installations',
                Colors.blue,
                () => Navigator.of(context).pushNamed('/dimensionnement'),
              ),
              _buildFeatureCard(
                context,
                'Bureau d\'Étude',
                Icons.business,
                'Accédez aux études techniques',
                Colors.green,
                () => Navigator.of(context).pushNamed('/be'),
              ),
              _buildFeatureCard(
                context,
                'Réglementation',
                Icons.description,
                'Consultez les normes en vigueur',
                Colors.orange,
                () => Navigator.of(context).pushNamed('/reglementation'),
              ),
              _buildFeatureCard(
                context,
                'Aide',
                Icons.help,
                'Centre d\'aide et documentation',
                Colors.purple,
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    String description,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
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
