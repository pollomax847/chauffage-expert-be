// Be_chauffage_expert/lib/pages/be_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'be/volume_circuit_page.dart';

class BEPage extends ConsumerWidget {
  const BEPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bureau d\'Études',
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
                  _buildModuleCard(
                    context,
                    'Volume Circuit',
                    Icons.water_drop,
                    'Calculez le volume total du circuit de chauffage',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VolumeCircuitPage(),
                      ),
                    ),
                  ),
                  _buildModuleCard(
                    context,
                    'Pertes de Charge',
                    Icons.trending_down,
                    'Calculez les pertes de charge du réseau',
                    () {}, // À implémenter
                  ),
                  _buildModuleCard(
                    context,
                    'Chauffe ECS',
                    Icons.whatshot,
                    'Dimensionnez la production d\'eau chaude sanitaire',
                    () {}, // À implémenter
                  ),
                  _buildModuleCard(
                    context,
                    'Rendement Chaudière',
                    Icons.speed,
                    'Calculez le rendement de votre chaudière',
                    () {}, // À implémenter
                  ),
                  _buildModuleCard(
                    context,
                    'Condensation',
                    Icons.opacity,
                    'Estimez le taux de condensation',
                    () {}, // À implémenter
                  ),
                  _buildModuleCard(
                    context,
                    'Équilibrage',
                    Icons.balance,
                    'Équilibrez votre réseau de chauffage',
                    () {}, // À implémenter
                  ),
                  _buildModuleCard(
                    context,
                    'Sondes',
                    Icons.sensors,
                    'Convertissez les valeurs des sondes',
                    () {}, // À implémenter
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    String title,
    IconData icon,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
