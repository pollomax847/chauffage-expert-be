import 'package:flutter/material.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedTemplate = 'rapport_chauffage';
  String _title = '';
  String _clientName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Génération PDF'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sélection du modèle
              const Text(
                'Sélectionner un modèle',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedTemplate,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'rapport_chauffage',
                    child: Text('Rapport de chauffage'),
                  ),
                  DropdownMenuItem(
                    value: 'rapport_ecs',
                    child: Text('Rapport ECS'),
                  ),
                  DropdownMenuItem(
                    value: 'rapport_vmc',
                    child: Text('Rapport VMC'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedTemplate = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Titre du rapport
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Titre du rapport',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Nom du client
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nom du client',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom de client';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _clientName = value;
                  });
                },
              ),

              const Spacer(),

              // Bouton de génération
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Générer le PDF
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Générer PDF'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
