import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculPage extends ConsumerWidget {
  const CalculPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculs'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              title: 'Eau Chaude Sanitaire',
              child: _buildECSCalculator(),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Chauffage Collectif',
              child: _buildChauffageCalculator(),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'VMC et 3CEP',
              child: _buildVMCCalculator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildECSCalculator() {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Nombre de logements',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Nombre de points',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Température (°C)',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // TODO: Implémenter le calcul ECS
          },
          child: const Text('Calculer'),
        ),
      ],
    );
  }

  Widget _buildChauffageCalculator() {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Surface (m²)',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Nombre de logements',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // TODO: Implémenter le calcul chauffage
          },
          child: const Text('Calculer'),
        ),
      ],
    );
  }

  Widget _buildVMCCalculator() {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Nombre de logements',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Nombre de modules',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Type de VMC',
          ),
          items: ['Simple flux', 'Double flux'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {},
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text('3CEP'),
          value: false,
          onChanged: (value) {},
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text('Gaz B'),
          value: false,
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // TODO: Implémenter le calcul VMC
          },
          child: const Text('Calculer'),
        ),
      ],
    );
  }
}
