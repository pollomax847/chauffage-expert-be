import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectifPage extends ConsumerStatefulWidget {
  const CollectifPage({super.key});

  @override
  ConsumerState<CollectifPage> createState() => _CollectifPageState();
}

class _CollectifPageState extends ConsumerState<CollectifPage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Ballon solaire',
      'icon': Icons.water_drop,
      'page': const BallonSolairePage(),
    },
    {
      'title': 'Chaudière collective',
      'icon': Icons.heat_pump,
      'page': const ChaudierePage(),
    },
    {
      'title': 'VMC collective',
      'icon': Icons.air,
      'page': const VMCPage(),
    },
    {
      'title': 'Pompes de circulation',
      'icon': Icons.water_damage,
      'page': const PompeCirculationPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installations Collectives'),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: _menuItems.map((item) {
              return NavigationRailDestination(
                icon: Icon(item['icon']),
                label: Text(item['title']),
              );
            }).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _menuItems[_selectedIndex]['page'],
          ),
        ],
      ),
    );
  }
}

// Widgets de page intégrés temporairement en attendant leur création en fichiers séparés
class BallonSolairePage extends StatelessWidget {
  const BallonSolairePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dimensionnement Ballon Solaire',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Cette page permettra de dimensionner un ballon solaire pour une installation collective.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
          Text('Fonctionnalités à venir :'),
          SizedBox(height: 8),
          Text('• Calcul du volume de stockage'),
          Text('• Dimensionnement des capteurs'),
          Text('• Calcul du taux de couverture'),
          Text('• Estimation des économies d\'énergie'),
          SizedBox(height: 24),
          Text('Page en cours de développement'),
        ],
      ),
    );
  }
}

class ChaudierePage extends StatelessWidget {
  const ChaudierePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chaudière Collective',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Cette page permettra de dimensionner une chaudière pour une installation collective.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
          Text('Fonctionnalités à venir :'),
          SizedBox(height: 8),
          Text('• Calcul de puissance'),
          Text('• Dimensionnement des accessoires'),
          Text('• Calcul du rendement'),
          Text('• Estimation de la consommation'),
          SizedBox(height: 24),
          Text('Page en cours de développement'),
        ],
      ),
    );
  }
}

class VMCPage extends StatelessWidget {
  const VMCPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VMC Collective',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Cette page permettra de dimensionner une VMC pour une installation collective.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
          Text('Fonctionnalités à venir :'),
          SizedBox(height: 8),
          Text('• Calcul des débits'),
          Text('• Dimensionnement des conduits'),
          Text('• Calcul des pertes de charge'),
          Text('• Sélection du caisson'),
          SizedBox(height: 24),
          Text('Page en cours de développement'),
        ],
      ),
    );
  }
}

class PompeCirculationPage extends StatelessWidget {
  const PompeCirculationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pompes de Circulation',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Cette page permettra de dimensionner les pompes de circulation pour une installation collective.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
          Text('Fonctionnalités à venir :'),
          SizedBox(height: 8),
          Text('• Calcul des débits'),
          Text('• Calcul des pertes de charge'),
          Text('• Sélection de la pompe adaptée'),
          Text('• Évaluation de la consommation électrique'),
          SizedBox(height: 24),
          Text('Page en cours de développement'),
        ],
      ),
    );
  }
}
