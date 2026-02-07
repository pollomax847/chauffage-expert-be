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
                  title: 'Dashboard',
                  icon: Icons.dashboard,
                  description: 'Tableau de bord et statistiques',
                  onTap: () => context.go('/dashboard'),
                ),
                ThemeCard(
                  title: '3CEP',
                  icon: Icons.assessment,
                  description:
                      'Calculs Chauffage, ECS, EUEV et VMC complets',
                  onTap: () => context.go('/3cep'),
                ),
                ThemeCard(
                  title: 'Déperditions',
                  icon: Icons.thermostat,
                  description: 'Calcul des déperditions thermiques',
                  onTap: () => context.go('/deperditions'),
                ),
                ThemeCard(
                  title: 'Chauffage',
                  icon: Icons.local_fire_department,
                  description: 'Dimensionnement système de chauffage',
                  onTap: () => context.go('/chauffage'),
                ),
                ThemeCard(
                  title: 'ECS',
                  icon: Icons.water_drop,
                  description: 'Eau Chaude Sanitaire',
                  onTap: () => context.go('/ecs'),
                ),
                ThemeCard(
                  title: 'EUEV',
                  icon: Icons.water_damage,
                  description: 'Eaux Usées et Eaux Vannes',
                  onTap: () => context.go('/euev'),
                ),
                ThemeCard(
                  title: 'Hydraulique',
                  icon: Icons.plumbing,
                  description: 'Calculs hydrauliques et réseaux',
                  onTap: () => context.go('/hydraulique'),
                ),
                ThemeCard(
                  title: 'Dimensionnement',
                  icon: Icons.calculate,
                  description:
                      'Calculs de puissance et dimensionnement des installations',
                  onTap: () => context.go('/dimensionnement'),
                ),
                ThemeCard(
                  title: 'Installations Collectives',
                  icon: Icons.apartment,
                  description: 'Installations pour bâtiments collectifs',
                  onTap: () => context.go('/collectif'),
                ),
                ThemeCard(
                  title: 'Bureau d\'Étude',
                  icon: Icons.engineering,
                  description: 'Études techniques et calculs détaillés',
                  onTap: () => context.go('/bureau-etude'),
                ),
                ThemeCard(
                  title: 'Radiateurs',
                  icon: Icons.heat_pump,
                  description: 'Dimensionnement et gestion radiateurs',
                  onTap: () => context.go('/radiateurs'),
                ),
                ThemeCard(
                  title: 'Calculs',
                  icon: Icons.calculate_outlined,
                  description: 'Calculs techniques divers',
                  onTap: () => context.go('/calcul'),
                ),
                ThemeCard(
                  title: 'Rapports',
                  icon: Icons.description,
                  description: 'Gestion et génération des rapports',
                  onTap: () => context.go('/rapport'),
                ),
                ThemeCard(
                  title: 'Rapport Thermique',
                  icon: Icons.article,
                  description: 'Rapports thermiques réglementaires',
                  onTap: () => context.go('/rapport-thermique'),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
