// features/gestion_donnees/presentation/widgets/logo_settings_widget.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_it/get_it.dart';
import '../../domain/repositories/donnees_repository.dart';
import 'dart:io';

class LogoSettingsWidget extends StatefulWidget {
  const LogoSettingsWidget({super.key});

  @override
  State<LogoSettingsWidget> createState() => _LogoSettingsWidgetState();
}

class _LogoSettingsWidgetState extends State<LogoSettingsWidget> {
  final _repository = GetIt.instance<DonneesRepository>();
  String? _logoPath;

  @override
  void initState() {
    super.initState();
    _loadLogo();
  }

  Future<void> _loadLogo() async {
    final path = await _repository.getLogoPath();
    setState(() {
      _logoPath = path;
    });
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _repository.setLogoPath(pickedFile.path);
      await _loadLogo();
    }
  }

  Future<void> _removeLogo() async {
    await _repository.removeLogo();
    await _loadLogo();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Logo de l\'entreprise',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_logoPath != null) ...[
              Image.file(
                File(_logoPath!),
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _removeLogo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Supprimer le logo'),
              ),
            ] else
              ElevatedButton(
                onPressed: _pickLogo,
                child: const Text('Choisir un logo'),
              ),
          ],
        ),
      ),
    );
  }
}
