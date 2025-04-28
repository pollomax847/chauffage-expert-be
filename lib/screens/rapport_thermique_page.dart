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
        besoinsThermiques: const [], // Provide appropriate data
        materiauxTuyauterie: const [], // Provide appropriate data
        identifications: const [], // Provide appropriate data
        modeles: const [], // Provide appropriate data
      ),
    );
  }
}
