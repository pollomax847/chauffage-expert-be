// pages/gestion_donnees_page.dart
import 'package:flutter/material.dart';
import '../features/gestion_donnees/presentation/widgets/gestion_donnees_widget.dart';

class GestionDonneesPage extends StatelessWidget {
  const GestionDonneesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Données'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: GestionDonneesWidget(),
      ),
    );
  }
}
