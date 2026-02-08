// pages/be_page.dart
import 'package:flutter/material.dart';
import 'be/volume_circuit_page.dart';
import 'be/pertes_charge_page.dart';
import 'be/chauffe_ecs_page.dart';
import 'be/rendement_chaudiere_page.dart';
import 'be/condensation_page.dart';
import 'be/equilibrage_page.dart';
import 'be/alimentation/reseau_page.dart';
import 'be/alimentation/reseau_alimentation_page.dart';
import 'be/alimentation/colonne_montante_page.dart';
import 'be/alimentation/surpresseur_page.dart';
import 'be/alimentation/retour_boucle_page.dart';
import 'be/evacuation/reseau_evacuation_page.dart';
import 'be/evacuation/poste_relevage_page.dart';
import 'be/evacuation/separateur_hydrocarbures_page.dart';
import 'be/geothermie/pac_geothermique_page.dart';
import 'be/geothermie/pompes_circulation_page.dart';
import 'be/geothermie/sondes_geothermiques_page.dart';

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
          // Section: Calculs de base
          _buildSectionHeader(context, 'Calculs de base'),
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
          
          // Section: Alimentation
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Alimentation en eau'),
          _buildModuleCard(
            context,
            'Réseau d\'alimentation',
            'Dimensionnement réseau alimentation eau potable',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ReseauAlimentationPage()),
            ),
          ),
          _buildModuleCard(
            context,
            'Réseau général',
            'Calculs réseau général d\'eau',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReseauPage()),
            ),
          ),
          _buildModuleCard(
            context,
            'Colonne montante',
            'Dimensionnement colonnes montantes',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ColonneMontantePage()),
            ),
          ),
          _buildModuleCard(
            context,
            'Surpresseur',
            'Calcul et dimensionnement surpresseur',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SurpresseurPage()),
            ),
          ),
          _buildModuleCard(
            context,
            'Retour en boucle',
            'Dimensionnement boucle eau chaude sanitaire',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RetourBouclePage()),
            ),
          ),
          
          // Section: Évacuation
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Évacuation des eaux'),
          _buildModuleCard(
            context,
            'Réseau d\'évacuation',
            'Dimensionnement réseau évacuation eaux usées',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ReseauEvacuationPage()),
            ),
          ),
          _buildModuleCard(
            context,
            'Poste de relevage',
            'Calcul et choix poste de relevage',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PosteRelevagePage()),
            ),
          ),
          _buildModuleCard(
            context,
            'Séparateur hydrocarbures',
            'Dimensionnement séparateur à hydrocarbures',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SeparateurHydrocarburesPage()),
            ),
          ),
          
          // Section: Géothermie
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Géothermie'),
          _buildModuleCard(
            context,
            'PAC Géothermique',
            'Dimensionnement pompe à chaleur géothermique',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PACGeothermiquePage()),
            ),
          ),
          _buildModuleCard(
            context,
            'Pompes de circulation',
            'Calcul pompes de circulation géothermie',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PompesCirculationPage()),
            ),
          ),
          _buildModuleCard(
            context,
            'Sondes géothermiques',
            'Dimensionnement sondes géothermiques',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SondesGeothermiquesPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
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

// Placeholder pages for modules defined inline (will be replaced with actual implementations)
class VolumeCircuitPage extends StatelessWidget {
  const VolumeCircuitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Volume Circuit'));
  }
}

class PertesChargePage extends StatelessWidget {
  const PertesChargePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Pertes de charge'));
  }
}

class ChauffeECSPage extends StatelessWidget {
  const ChauffeECSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Chauffe ECS'));
  }
}

class RendementChaudierePage extends StatelessWidget {
  const RendementChaudierePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Rendement chaudière'));
  }
}

class CondensationPage extends StatelessWidget {
  const CondensationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Estimation condensation'));
  }
}

class EquilibragePage extends StatelessWidget {
  const EquilibragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Équilibrage réseau'));
  }
}

class SondesPage extends StatelessWidget {
  const SondesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Valeurs sondes'));
  }
}

