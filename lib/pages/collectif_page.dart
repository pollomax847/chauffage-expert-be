import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'collectif/ballon_solaire_page.dart';
import 'collectif/chaudiere_page.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
