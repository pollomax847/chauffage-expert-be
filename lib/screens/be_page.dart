// pages/be_page.dart
import 'package:flutter/material.dart';
import 'be/volume_circuit_page.dart';

class BEPage extends StatelessWidget {
  const BEPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bureau d\'Études'),
      ),
      body: const Center(
        child: Text('Page Bureau d\'Études - En développement'),
      ),
    );
  }
}

// Pages des différents modules
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
