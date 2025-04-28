// Be_chauffage_expert/lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tableau de bord',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: const [
              DashboardCard(
                icon: Icons.construction,
                title: 'Interventions aujourd\'hui',
                value: '12',
                color: Colors.orange,
              ),
              DashboardCard(
                icon: Icons.engineering,
                title: 'Techniciens actifs',
                value: '8',
                color: Colors.blue,
              ),
              DashboardCard(
                icon: Icons.folder,
                title: 'Dossiers en attente',
                value: '5',
                color: Colors.red,
              ),
              DashboardCard(
                icon: Icons.description,
                title: 'Derniers rapports',
                value: '3',
                color: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Derniers rapports',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.description),
                        title: Text('Rapport ${index + 1}'),
                        subtitle: Text(
                            'Client ${index + 1} - ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}'),
                        trailing: const Icon(Icons.chevron_right),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
