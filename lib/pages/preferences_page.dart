// pages/preferences_page.dart
import 'package:flutter/material.dart';
import '../widgets/configuration_widget.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Préférences'),
      ),
      body: const ConfigurationWidget(),
    );
  }
} 