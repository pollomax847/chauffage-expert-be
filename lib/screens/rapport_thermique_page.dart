import 'package:flutter/material.dart';
import '../widgets/rapport_thermique_widget.dart';
import '../models/radiateur.dart';

class RapportThermiquePage extends StatelessWidget {
  final List<Radiateur> radiateurs;

  const RapportThermiquePage({super.key, required this.radiateurs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapport d\'analyse thermique'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RapportThermiqueWidget(
        radiateurs: radiateurs,
        besoinsThermiques: [], // Provide appropriate data
        materiauxTuyauterie: [], // Provide appropriate data
        identifications: [], // Provide appropriate data
        modeles: [], // Provide appropriate data
      ),
    );
  }
}
