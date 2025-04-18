// Be_chauffage_expert/lib/main.dart
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';
import 'pages/dimensionnement_page.dart';
import 'pages/be_page.dart';
import 'pages/reglementation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHAUFFAGE EXPERT',
      theme: AppTheme.theme,
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const DimensionnementPage(),
    const BEPage(),
    const ReglementationPage(),
  ];

  final List<String> _titles = [
    'Accueil',
    'Dimensionnement',
    'Bureau d\'Étude (BE)',
    'Réglementation Gaz',
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.calculate,
    Icons.business,
    Icons.description,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF2D3139),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF2D3139),
                ),
                child: Text(
                  'CHAUFFAGE EXPERT',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              for (int i = 0; i < _titles.length; i++)
                ListTile(
                  leading: Icon(_icons[i],
                      color: _selectedIndex == i ? Colors.blue : Colors.white),
                  title: Text(
                    _titles[i],
                    style: TextStyle(
                      color: _selectedIndex == i ? Colors.blue : Colors.white,
                    ),
                  ),
                  selected: _selectedIndex == i,
                  onTap: () {
                    setState(() {
                      _selectedIndex = i;
                    });
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implémentation de la recherche à venir
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
