// Be_chauffage_expert/lib/pages/be_page.dart
import 'package:flutter/material.dart';

class BEPage extends StatelessWidget {
  const BEPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('Chargement de la page BE');
    return Scaffold(
      body: const Center(
        child: Text('Page BE'),
      ),
    );
  }
}
