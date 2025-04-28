import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/app_drawer.dart';

class DimensionnementPage extends ConsumerStatefulWidget {
  const DimensionnementPage({super.key});

  @override
  ConsumerState<DimensionnementPage> createState() =>
      _DimensionnementPageState();
}

class _DimensionnementPageState extends ConsumerState<DimensionnementPage> {
  String _currentSection = 'puissance';

  final List<DrawerItem> _menuItems = [
    const DrawerItem(
      id: 'puissance',
      title: 'Puissance',
      icon: Icons.power,
      subItems: [
        DrawerSubItem(id: 'puissance', title: 'Calcul de puissance'),
        DrawerSubItem(id: 'deperditions', title: 'Déperditions'),
      ],
    ),
    const DrawerItem(
      id: 'isolation',
      title: 'Isolation',
      icon: Icons.thermostat,
      subItems: [
        DrawerSubItem(id: 'isolation', title: 'Calcul isolation'),
        DrawerSubItem(id: 'ponts_thermiques', title: 'Ponts thermiques'),
      ],
    ),
    const DrawerItem(
      id: 'ventilation',
      title: 'Ventilation',
      icon: Icons.air,
      subItems: [
        DrawerSubItem(id: 'ventilation', title: 'Dimensionnement VMC'),
        DrawerSubItem(id: 'conduits', title: 'Conduits'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dimensionnement'),
      ),
      drawer: AppDrawer(
        currentModule: _currentSection,
        items: _menuItems,
        onItemSelected: (section) {
          setState(() {
            _currentSection = section;
          });
          Navigator.pop(context); // Fermer le drawer
        },
      ),
      body: Row(
        children: [
          // Menu latéral (visible uniquement sur desktop)
          if (MediaQuery.of(context).size.width > 1200)
            SizedBox(
              width: 300,
              child: AppDrawer(
                currentModule: _currentSection,
                items: _menuItems,
                onItemSelected: (section) {
                  setState(() {
                    _currentSection = section;
                  });
                },
              ),
            ),
          // Zone de contenu
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_currentSection) {
      case 'puissance':
        return const Center(child: Text('Calcul de puissance'));
      case 'deperditions':
        return const Center(child: Text('Calcul des déperditions'));
      case 'isolation':
        return const Center(child: Text('Calcul isolation'));
      case 'ponts_thermiques':
        return const Center(child: Text('Ponts thermiques'));
      case 'ventilation':
        return const Center(child: Text('Dimensionnement VMC'));
      case 'conduits':
        return const Center(child: Text('Dimensionnement conduits'));
      default:
        return const Center(child: Text('Section non trouvée'));
    }
  }
}
