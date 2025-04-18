// services/be_validation_service.dart
import 'dart:convert';
import 'be_security_service.dart';

class BEValidationService {
  static final Map<String, Map<String, dynamic>> _reglesValidation = {
    'temperature': {
      'min': -50.0,
      'max': 70.0,
      'message': 'La température doit être comprise entre -50°C et 70°C',
    },
    'puissance': {
      'min': 0.0,
      'max': 100000.0,
      'message': 'La puissance doit être comprise entre 0 W et 100 kW',
    },
    'debit': {
      'min': 0.0,
      'max': 10000.0,
      'message': 'Le débit doit être compris entre 0 et 100000 m³/h',
    },
    'surface': {
      'min': 0.0,
      'max': 10000.0,
      'message': 'La surface doit être comprise entre 0 et 10000 m²',
    },
    'nombre': {
      'min': 0,
      'max': 1000,
      'message': 'Le nombre doit être compris entre 0 et 1000',
    },
  };

  static final Map<String, Map<String, List<String>>> _reglesModule = {
    'chauffage': {
      'surfaces': ['surface'],
      'zoneClimatique': ['nombre'],
      'temperatureInterieure': ['temperature'],
      'temperatureExterieure': ['temperature'],
    },
    'hydraulique': {
      'typeBatiment': ['nombre'],
      'appareils': ['nombre'],
    },
    'vmc': {
      'volumeHabitable': ['surface'],
      'typeVMC': ['nombre'],
      'nombrePieces': ['nombre'],
    },
    'geothermie': {
      'puissanceCalculee': ['puissance'],
      'typeCaptage': ['nombre'],
      'surfaceTerrain': ['surface'],
    },
    'regulation': {
      'puissanceChaudiere': ['puissance'],
      'typeRegulation': ['nombre'],
      'nombreZones': ['nombre'],
    },
    'alimentation': {
      'puissanceThermique': ['puissance'],
      'typeSysteme': ['nombre'],
    },
    'evacuation': {
      'puissanceChaudiere': ['puissance'],
      'typeEvacuation': ['nombre'],
    },
  };

  static Future<Map<String, dynamic>> validate({
    required String module,
    required Map<String, dynamic> parameters,
  }) async {
    final resultats = {
      'valide': true,
      'erreurs': <String>[],
      'avertissements': <String>[],
    };

    try {
      // Vérification des paramètres requis
      if (!BESecurityService.validateParameters(
        module: module,
        parameters: parameters,
      )) {
        resultats['valide'] = false;
        resultats['erreurs']!.add('Paramètres manquants pour le module $module');
        return resultats;
      }

      // Validation des valeurs selon les règles
      final reglesModule = _reglesModule[module];
      if (reglesModule != null) {
        for (final entry in parameters.entries) {
          final nomParametre = entry.key;
          final valeur = entry.value;
          final typesValidation = reglesModule[nomParametre];

          if (typesValidation != null) {
            for (final type in typesValidation) {
              final regle = _reglesValidation[type];
              if (regle != null) {
                final validation = _validerValeur(
                  valeur,
                  regle['min'],
                  regle['max'],
                  regle['message'],
                );
                if (!validation['valide']) {
                  resultats['valide'] = false;
                  resultats['erreurs'].add(validation['message']);
                } else if (validation['avertissement'] != null) {
                  resultats['avertissements'].add(validation['avertissement']);
                }
              }
            }
          }
        }
      }

      // Journalisation des résultats de validation
      await BESecurityService.logSecurityEvent(
        'validation',
        'Validation du module $module: ${resultats['valide'] ? 'succès' : 'échec'}',
      );

      return resultats;
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors de la validation: $e',
      );
      resultats['valide'] = false;
      resultats['erreurs'].add('Erreur lors de la validation: $e');
      return resultats;
    }
  }

  static Map<String, dynamic> _validerValeur(
    dynamic valeur,
    dynamic min,
    dynamic max,
    String message,
  ) {
    final resultat = {
      'valide': true,
      'message': '',
      'avertissement': null,
    };

    try {
      final valeurNumerique = double.parse(valeur.toString());

      if (valeurNumerique < min) {
        resultat['valide'] = false;
        resultat['message'] = message;
      } else if (valeurNumerique > max) {
        resultat['valide'] = false;
        resultat['message'] = message;
      } else if (valeurNumerique > max * 0.8) {
        resultat['avertissement'] = 'Valeur proche de la limite maximale';
      } else if (valeurNumerique < min * 1.2) {
        resultat['avertissement'] = 'Valeur proche de la limite minimale';
      }
    } catch (e) {
      resultat['valide'] = false;
      resultat['message'] = 'Valeur invalide: $valeur';
    }

    return resultat;
  }
}
