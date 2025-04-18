// services/be_schema_service.dart
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class BESchemaService {
  static const Map<String, Map<String, String>> _themes = {
    'classique': {
      'fond': '#FFFFFF',
      'texte': '#000000',
      'bordure': '#000000',
      'chaudiere': '#FF0000',
      'circuit': '#0000FF',
      'radiateur': '#FFA500',
      'retour': '#00FF00',
      'solaire': '#FFD700',
      'ventilation': '#00FFFF',
      'reservoir': '#0000FF',
      'pompe': '#FF00FF',
    },
    'sombre': {
      'fond': '#1E1E1E',
      'texte': '#FFFFFF',
      'bordure': '#FFFFFF',
      'chaudiere': '#FF3333',
      'circuit': '#3399FF',
      'radiateur': '#FF9933',
      'retour': '#33FF33',
      'solaire': '#FFE066',
      'ventilation': '#66FFFF',
      'reservoir': '#3399FF',
      'pompe': '#FF66FF',
    },
    'professionnel': {
      'fond': '#F5F5F5',
      'texte': '#333333',
      'bordure': '#666666',
      'chaudiere': '#CC0000',
      'circuit': '#0066CC',
      'radiateur': '#CC6600',
      'retour': '#00CC00',
      'solaire': '#CC9900',
      'ventilation': '#00CCCC',
      'reservoir': '#0066CC',
      'pompe': '#CC00CC',
    },
  };

  static Future<String> genererSchema({
    required String module,
    required Map<String, dynamic> resultats,
    bool useSVG = true,
    String theme = 'classique',
    Map<String, String>? stylePersonnalise,
    Map<String, double>? taillesPersonnalisees,
    Map<String, String>? policesPersonnalisees,
  }) async {
    final themeFinal = _fusionnerThemes(theme, stylePersonnalise);
    
    switch (module.toLowerCase()) {
      case 'chauffage':
        return _getSchemaChauffage(resultats, themeFinal);
      case '3cep':
        return _getSchema3CEP(resultats, themeFinal);
      case 'solaire':
        return _getSchemaSolaire(resultats, themeFinal);
      case 'vmc':
        return _getSchemaVMC(resultats, themeFinal);
      case 'hydraulique':
        return _getSchemaHydraulique(resultats, themeFinal);
      default:
        return _getSchemaParDefaut(module);
    }
  }

  static Map<String, String> _fusionnerThemes(String theme, Map<String, String>? stylePersonnalise) {
    final themeBase = Map<String, String>.from(_themes[theme] ?? _themes['classique']!);
    if (stylePersonnalise != null) {
      themeBase.addAll(stylePersonnalise);
    }
    return themeBase;
  }

  static String _getSchemaChauffage(Map<String, dynamic> resultats, Map<String, String> theme) {
    final puissance = resultats['puissance'] ?? 0;
    final temperatureDepart = resultats['temperature_depart'] ?? 0;
    final temperatureRetour = resultats['temperature_retour'] ?? 0;

    return '''
      <svg width="600" height="400" xmlns="http://www.w3.org/2000/svg">
        <rect width="100%" height="100%" fill="${theme['fond']}"/>
        <!-- Chaudière -->
        <rect x="50" y="150" width="100" height="100" fill="${theme['chaudiere']}" stroke="${theme['bordure']}" stroke-width="2"/>
        <text x="100" y="200" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          Chaudière ${puissance} kW
        </text>
        <!-- Circuit de distribution -->
        <path d="M150,200 L300,200" stroke="${theme['circuit']}" stroke-width="4" fill="none"/>
        <text x="225" y="190" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          ${temperatureDepart}°C
        </text>
        <!-- Radiateurs -->
        <rect x="300" y="100" width="50" height="100" fill="${theme['radiateur']}" stroke="${theme['bordure']}" stroke-width="2"/>
        <rect x="400" y="100" width="50" height="100" fill="${theme['radiateur']}" stroke="${theme['bordure']}" stroke-width="2"/>
        <!-- Circuit de retour -->
        <path d="M300,200 L150,200" stroke="${theme['retour']}" stroke-width="4" fill="none"/>
        <text x="225" y="210" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          ${temperatureRetour}°C
        </text>
      </svg>
    ''';
  }

  static String _getSchema3CEP(Map<String, dynamic> resultats, Map<String, String> theme) {
    final puissance = resultats['puissance'] ?? 0;
    final rendement = resultats['rendement'] ?? 0;
    final temperatureDepart = resultats['temperature_depart'] ?? 0;
    final temperatureRetour = resultats['temperature_retour'] ?? 0;

    return '''
      <svg width="600" height="400" xmlns="http://www.w3.org/2000/svg">
        <rect width="100%" height="100%" fill="${theme['fond']}"/>
        <!-- Chaudière 3CEP -->
        <rect x="50" y="150" width="100" height="100" fill="${theme['chaudiere']}" stroke="${theme['bordure']}" stroke-width="2"/>
        <text x="100" y="180" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          Chaudière 3CEP
        </text>
        <text x="100" y="200" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          ${puissance} kW (${rendement}%)
        </text>
        <!-- Circuit de distribution -->
        <path d="M150,200 L300,200" stroke="${theme['circuit']}" stroke-width="4" fill="none"/>
        <text x="225" y="190" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          ${temperatureDepart}°C
        </text>
        <!-- Radiateurs -->
        <rect x="300" y="100" width="50" height="100" fill="${theme['radiateur']}" stroke="${theme['bordure']}" stroke-width="2"/>
        <rect x="400" y="100" width="50" height="100" fill="${theme['radiateur']}" stroke="${theme['bordure']}" stroke-width="2"/>
        <!-- Circuit de retour -->
        <path d="M300,200 L150,200" stroke="${theme['retour']}" stroke-width="4" fill="none"/>
        <text x="225" y="210" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          ${temperatureRetour}°C
        </text>
      </svg>
    ''';
  }

  static String _getSchemaSolaire(Map<String, dynamic> resultats, Map<String, String> theme) {
    final puissance = resultats['puissance'] ?? 0;
    final temperatureDepart = resultats['temperature_depart'] ?? 0;
    final temperatureRetour = resultats['temperature_retour'] ?? 0;
    final surface = resultats['surface'] ?? 0;

    return '''
      <svg width="600" height="400" xmlns="http://www.w3.org/2000/svg">
        <rect width="100%" height="100%" fill="${theme['fond']}"/>
        <!-- Panneaux solaires -->
        <rect x="50" y="50" width="200" height="50" fill="${theme['solaire']}" stroke="${theme['bordure']}" stroke-width="2"/>
        <text x="150" y="80" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          Panneaux solaires (${surface} m²)
        </text>
        <!-- Circuit solaire -->
        <path d="M250,75 L350,75" stroke="${theme['circuit']}" stroke-width="4" fill="none"/>
        <text x="300" y="65" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          ${temperatureDepart}°C
        </text>
        <!-- Ballon de stockage -->
        <rect x="350" y="100" width="100" height="200" fill="${theme['reservoir']}" stroke="${theme['bordure']}" stroke-width="2"/>
        <text x="400" y="200" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          Ballon ${puissance} kW
        </text>
        <!-- Circuit de retour -->
        <path d="M350,75 L250,75" stroke="${theme['retour']}" stroke-width="4" fill="none"/>
        <text x="300" y="85" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          ${temperatureRetour}°C
        </text>
      </svg>
    ''';
  }

  static String _getSchemaVMC(Map<String, dynamic> resultats, Map<String, String> theme) {
    final debit = resultats['debit'] ?? 0;
    final temperatureEntree = resultats['temperature_entree'] ?? 0;
    final temperatureSortie = resultats['temperature_sortie'] ?? 0;

    return '''
      <svg width="600" height="400" xmlns="http://www.w3.org/2000/svg">
        <rect width="100%" height="100%" fill="${theme['fond']}"/>
        <!-- VMC -->
        <rect x="250" y="150" width="100" height="100" fill="${theme['ventilation']}" stroke="${theme['bordure']}" stroke-width="2"/>
        <text x="300" y="200" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          VMC ${debit} m³/h
        </text>
        <!-- Entrées d'air -->
        <path d="M150,200 L250,200" stroke="${theme['circuit']}" stroke-width="4" fill="none"/>
        <text x="200" y="190" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          ${temperatureEntree}°C
        </text>
        <!-- Sorties d'air -->
        <path d="M350,200 L450,200" stroke="${theme['retour']}" stroke-width="4" fill="none"/>
        <text x="400" y="190" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          ${temperatureSortie}°C
        </text>
      </svg>
    ''';
  }

  static String _getSchemaHydraulique(Map<String, dynamic> resultats, Map<String, String> theme) {
    final volume = resultats['volume'] ?? 0;
    final debit = resultats['debit'] ?? 0;
    final pression = resultats['pression'] ?? 0;

    return '''
      <svg width="600" height="400" xmlns="http://www.w3.org/2000/svg">
        <rect width="100%" height="100%" fill="${theme['fond']}"/>
        <!-- Réservoir -->
        <rect x="50" y="100" width="100" height="200" fill="${theme['reservoir']}" stroke="${theme['bordure']}" stroke-width="2"/>
        <text x="100" y="200" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          Réservoir ${volume} L
        </text>
        <!-- Pompe -->
        <rect x="200" y="175" width="50" height="50" fill="${theme['pompe']}" stroke="${theme['bordure']}" stroke-width="2"/>
        <text x="225" y="200" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          ${debit} L/min
        </text>
        <!-- Circuit de distribution -->
        <path d="M250,200 L400,200" stroke="${theme['circuit']}" stroke-width="4" fill="none"/>
        <text x="325" y="190" text-anchor="middle" fill="${theme['texte']}" font-family="Arial" font-size="12">
          ${pression} bar
        </text>
        <!-- Points de puisage -->
        <rect x="400" y="150" width="50" height="100" fill="${theme['radiateur']}" stroke="${theme['bordure']}" stroke-width="2"/>
      </svg>
    ''';
  }

  static String _getSchemaParDefaut(String module) {
    return '''
      <svg width="600" height="400" xmlns="http://www.w3.org/2000/svg">
        <rect width="100%" height="100%" fill="#FFFFFF"/>
        <text x="300" y="200" text-anchor="middle" fill="#000000" font-family="Arial" font-size="16">
          Schéma non disponible pour le module $module
        </text>
      </svg>
    ''';
  }
} 