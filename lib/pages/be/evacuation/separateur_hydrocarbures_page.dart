import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/be_evacuation.dart';

class SeparateurHydrocarburesPage extends ConsumerStatefulWidget {
  const SeparateurHydrocarburesPage({super.key});

  @override
  ConsumerState<SeparateurHydrocarburesPage> createState() =>
      _SeparateurHydrocarburesPageState();
}

class _SeparateurHydrocarburesPageState
    extends ConsumerState<SeparateurHydrocarburesPage> {
  final _formKey = GlobalKey<FormState>();
  final _debitController = TextEditingController();
  String _typeInstallation = 'parking';
  Map<String, dynamic>? _resultats;

  @override
  void dispose() {
    _debitController.dispose();
    super.dispose();
  }

  void _calculer() {
    if (_formKey.currentState!.validate()) {
      final resultats = BEEvacuation.dimensionnerSeparateur(
        debit: double.parse(_debitController.text),
        typeInstallation: _typeInstallation,
      );
      setState(() => _resultats = resultats);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dimensionnement Séparateur d\'Hydrocarbures'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _debitController,
                decoration: const InputDecoration(
                  labelText: 'Débit (L/s)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Le débit doit être positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _typeInstallation,
                decoration: const InputDecoration(
                  labelText: 'Type d\'installation',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'parking',
                    child: Text('Parking'),
                  ),
                  DropdownMenuItem(
                    value: 'station_service',
                    child: Text('Station service'),
                  ),
                  DropdownMenuItem(
                    value: 'zone_industrielle',
                    child: Text('Zone industrielle'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _typeInstallation = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculer,
                child: const Text('Calculer'),
              ),
              if (_resultats != null) ...[
                const SizedBox(height: 24),
                const Text(
                  'Résultats :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _ResultatItem(
                  label: 'Volume de rétention',
                  valeur: '${_resultats!['volumeRetention']} m³',
                ),
                _ResultatItem(
                  label: 'Volume du séparateur',
                  valeur: '${_resultats!['volumeSeparateur']} m³',
                ),
                _ResultatItem(
                  label: 'Surface de séparation',
                  valeur: '${_resultats!['surfaceSeparation']} m²',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultatItem extends StatelessWidget {
  final String label;
  final String valeur;

  const _ResultatItem({
    required this.label,
    required this.valeur,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            valeur,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
