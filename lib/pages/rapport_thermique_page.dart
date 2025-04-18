import 'package:flutter/material.dart';
import '../widgets/rapport_thermique_widget.dart';
import '../models/radiateur.dart';

class RapportThermiquePage extends StatelessWidget {
  final List<Radiateur> radiateurs;

  const RapportThermiquePage({Key? key, required this.radiateurs})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapport d\'analyse thermique'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RapportThermiqueWidget(radiateurs: radiateurs),
    );
  }
}
