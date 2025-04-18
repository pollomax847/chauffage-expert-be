// widgets/configuration_widget.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/configuration_service.dart';

class ConfigurationWidget extends StatefulWidget {
  const ConfigurationWidget({super.key});

  @override
  State<ConfigurationWidget> createState() => _ConfigurationWidgetState();
}

class _ConfigurationWidgetState extends State<ConfigurationWidget> {
  final _configurationService = GetIt.instance<ConfigurationService>();
  late double _margeChauffage;
  late double _margeECS;
  late double _margeVMC;
  late String _uniteTemperature;
  late String _unitePuissance;
  late String _uniteDebit;
  late String _theme;
  late double _taillePolice;
  late String _langue;
  late int _precision;
  late String _formatNombre;
  late bool _arrondi;

  @override
  void initState() {
    super.initState();
    _chargerConfigurations();
  }

  void _chargerConfigurations() {
    setState(() {
      _margeChauffage = _configurationService.margeChauffage;
      _margeECS = _configurationService.margeECS;
      _margeVMC = _configurationService.margeVMC;
      _uniteTemperature = _configurationService.uniteTemperature;
      _unitePuissance = _configurationService.unitePuissance;
      _uniteDebit = _configurationService.uniteDebit;
      _theme = _configurationService.theme;
      _taillePolice = _configurationService.taillePolice;
      _langue = _configurationService.langue;
      _precision = _configurationService.precision;
      _formatNombre = _configurationService.formatNombre;
      _arrondi = _configurationService.arrondi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Configuration des marges',
            [
              _buildSliderMarge(
                'Marge chauffage',
                _margeChauffage,
                (value) => _margeChauffage = value,
                () => _configurationService.setMargeChauffage(_margeChauffage),
              ),
              _buildSliderMarge(
                'Marge ECS',
                _margeECS,
                (value) => _margeECS = value,
                () => _configurationService.setMargeECS(_margeECS),
              ),
              _buildSliderMarge(
                'Marge VMC',
                _margeVMC,
                (value) => _margeVMC = value,
                () => _configurationService.setMargeVMC(_margeVMC),
              ),
            ],
          ),
          _buildSection(
            'Unités de mesure',
            [
              _buildDropdownUnite(
                'Température',
                _uniteTemperature,
                ConfigurationService.unitesTemperature,
                (value) => _configurationService.setUniteTemperature(value!),
              ),
              _buildDropdownUnite(
                'Puissance',
                _unitePuissance,
                ConfigurationService.unitesPuissance,
                (value) => _configurationService.setUnitePuissance(value!),
              ),
              _buildDropdownUnite(
                'Débit',
                _uniteDebit,
                ConfigurationService.unitesDebit,
                (value) => _configurationService.setUniteDebit(value!),
              ),
            ],
          ),
          _buildSection(
            'Apparence',
            [
              _buildDropdownUnite(
                'Thème',
                _theme,
                ConfigurationService.themes,
                (value) => _configurationService.setTheme(value!),
              ),
              _buildDropdownUnite(
                'Taille de la police',
                _taillePolice.toString(),
                ConfigurationService.taillesPolice
                    .map((e) => e.toString())
                    .toList(),
                (value) =>
                    _configurationService.setTaillePolice(double.parse(value!)),
              ),
              _buildDropdownUnite(
                'Langue',
                _langue,
                ConfigurationService.langues,
                (value) => _configurationService.setLangue(value!),
              ),
            ],
          ),
          _buildSection(
            'Calculs',
            [
              _buildDropdownUnite(
                'Précision',
                _precision.toString(),
                ConfigurationService.precisions
                    .map((e) => e.toString())
                    .toList(),
                (value) =>
                    _configurationService.setPrecision(int.parse(value!)),
              ),
              _buildDropdownUnite(
                'Format des nombres',
                _formatNombre,
                ConfigurationService.formatsNombre,
                (value) => _configurationService.setFormatNombre(value!),
              ),
              SwitchListTile(
                title: const Text('Arrondi automatique'),
                value: _arrondi,
                onChanged: (value) {
                  setState(() {
                    _arrondi = value;
                  });
                  _configurationService.setArrondi(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String titre, List<Widget> enfants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titre,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...enfants,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSliderMarge(
    String label,
    double value,
    void Function(double) onChanged,
    Future<void> Function() onChangedEnd,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(2)}'),
        Slider(
          value: value,
          min: 1.0,
          max: 2.0,
          divisions: 20,
          label: value.toStringAsFixed(2),
          onChanged: onChanged,
          onChangeEnd: (_) => onChangedEnd(),
        ),
      ],
    );
  }

  Widget _buildDropdownUnite(
    String label,
    String value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: value,
        items: items.map((unite) {
          return DropdownMenuItem(
            value: unite,
            child: Text(unite),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
