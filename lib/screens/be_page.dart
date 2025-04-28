// pages/be_page.dart
import 'package:flutter/material.dart';
// L'import de volume_circuit_page est supprimé car la classe est définie dans ce fichier

class BEPage extends StatelessWidget {
  const BEPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bureau d\'Études'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildModuleCard(
            context,
            'Volume de circuit',
            'Calcul des volumes d\'eau dans les installations',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const VolumeCircuitPage()),
            ),
          ),
          _buildModuleCard(
            context,
            'Pertes de charge',
            'Calcul des pertes de charge dans les réseaux',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PertesChargePage()),
            ),
          ),
          _buildModuleCard(
            context,
            'Chauffe ECS',
            'Dimensionnement des systèmes d\'eau chaude sanitaire',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChauffeECSPage()),
            ),
          ),
          _buildModuleCard(
            context,
            'Rendement chaudière',
            'Calcul du rendement des systèmes de chauffage',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RendementChaudierePage()),
            ),
          ),
          _buildModuleCard(
            context,
            'Estimation condensation',
            'Analyse des risques de condensation',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CondensationPage()),
            ),
          ),
          _buildModuleCard(
            context,
            'Équilibrage réseau',
            'Optimisation de l\'équilibrage des réseaux hydrauliques',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EquilibragePage()),
            ),
          ),
          _buildModuleCard(
            context,
            'Valeurs sondes',
            'Interprétation des mesures de sondes',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SondesPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, String title,
      String description, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4.0,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pages des différents modules
class VolumeCircuitPage extends StatelessWidget {
  const VolumeCircuitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volume Circuit'),
      ),
      body: const Center(child: Text('Volume Circuit - En développement')),
    );
  }
}

class PertesChargePage extends StatelessWidget {
  const PertesChargePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pertes de charge'),
      ),
      body: const Center(child: Text('Pertes de charge - En développement')),
    );
  }
}

class ChauffeECSPage extends StatelessWidget {
  const ChauffeECSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chauffe ECS'),
      ),
      body: const Center(child: Text('Chauffe ECS - En développement')),
    );
  }
}

class RendementChaudierePage extends StatelessWidget {
  const RendementChaudierePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rendement chaudière'),
      ),
      body: const Center(child: Text('Rendement chaudière - En développement')),
    );
  }
}

class CondensationPage extends StatelessWidget {
  const CondensationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estimation condensation'),
      ),
      body: const Center(
          child: Text('Estimation condensation - En développement')),
    );
  }
}

class EquilibragePage extends StatelessWidget {
  const EquilibragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Équilibrage réseau'),
      ),
      body: const Center(child: Text('Équilibrage réseau - En développement')),
    );
  }
}

class SondesPage extends StatelessWidget {
  const SondesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Valeurs sondes'),
      ),
      body: const Center(child: Text('Valeurs sondes - En développement')),
    );
  }
}
