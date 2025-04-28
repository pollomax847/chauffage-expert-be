import 'be_security_service.dart';

class BEGeothermieService {
  static const double _conductiviteThermiqueSol = 2.0; // W/(m·K)
  static const double _capaciteCalorifiqueSol = 2000.0; // J/(kg·K)
  static const double _densiteSol = 1800.0; // kg/m³
  static const double _temperatureSolProfondeur = 10.0; // °C
  static const double _profondeurCaptage = 100.0; // m

  static Future<Map<String, dynamic>> calculerGeothermie({
    required Map<String, dynamic> parametres,
  }) async {
    try {
      // Validation des paramètres
      if (!BESecurityService.validateParameters(
        module: 'geothermie',
        parameters: parametres,
      )) {
        throw Exception('Paramètres invalides');
      }

      // Extraction des paramètres
      final puissanceThermique = parametres['puissance_thermique'] as double;
      final surfaceTerrain = parametres['surface_terrain'] as double;
      final typeCaptage = parametres['type_captage'] as String;
      final temperatureEau = parametres['temperature_eau'] as double;

      // Calculs spécifiques selon le type de captage
      Map<String, dynamic> resultats = {};
      switch (typeCaptage) {
        case 'horizontal':
          resultats = _calculerCaptageHorizontal(
            puissanceThermique,
            surfaceTerrain,
            temperatureEau,
          );
          break;
        case 'vertical':
          resultats = _calculerCaptageVertical(
            puissanceThermique,
            temperatureEau,
          );
          break;
        case 'sur_sonde':
          resultats = _calculerCaptageSurSonde(
            puissanceThermique,
            temperatureEau,
          );
          break;
        default:
          throw Exception('Type de captage non supporté');
      }

      // Vérification de l'intégrité des résultats
      if (!BESecurityService.validateResults(
        module: 'geothermie',
        results: resultats,
      )) {
        throw Exception('Résultats invalides');
      }

      // Journalisation de l'événement
      await BESecurityService.logSecurityEvent(
        'calcul',
        'Calculs géothermiques effectués pour le type de captage: $typeCaptage',
      );

      return resultats;
    } catch (e) {
      await BESecurityService.logSecurityEvent(
        'erreur',
        'Erreur lors des calculs géothermiques: $e',
      );
      rethrow;
    }
  }

  static Map<String, dynamic> _calculerCaptageHorizontal(
    double puissanceThermique,
    double surfaceTerrain,
    double temperatureEau,
  ) {
    // Calcul de la longueur de capteur nécessaire
    final longueurCapteur = puissanceThermique / (20 * _conductiviteThermiqueSol);
    
    // Calcul de la surface de captage nécessaire
    final surfaceCaptage = longueurCapteur * 0.8; // 0.8 m d'espacement entre les tubes
    
    // Vérification de la faisabilité
    final faisable = surfaceCaptage <= surfaceTerrain;
    
    // Calcul du coefficient de performance (COP)
    final cop = _calculerCOP(temperatureEau);
    
    return {
      'longueur_capteur': longueurCapteur,
      'surface_captage': surfaceCaptage,
      'faisable': faisable,
      'cop': cop,
      'puissance_thermique': puissanceThermique,
      'type_captage': 'horizontal',
    };
  }

  static Map<String, dynamic> _calculerCaptageVertical(
    double puissanceThermique,
    double temperatureEau,
  ) {
    // Calcul du nombre de sondes nécessaires
    const puissanceParSonde = 50.0; // W/m
    final longueurTotale = puissanceThermique / puissanceParSonde;
    final nombreSondes = (longueurTotale / _profondeurCaptage).ceil();
    
    // Calcul du coefficient de performance (COP)
    final cop = _calculerCOP(temperatureEau);
    
    return {
      'nombre_sondes': nombreSondes,
      'profondeur_sondes': _profondeurCaptage,
      'longueur_totale': longueurTotale,
      'cop': cop,
      'puissance_thermique': puissanceThermique,
      'type_captage': 'vertical',
    };
  }

  static Map<String, dynamic> _calculerCaptageSurSonde(
    double puissanceThermique,
    double temperatureEau,
  ) {
    // Calcul de la longueur de sonde nécessaire
    final longueurSonde = puissanceThermique / (50 * _conductiviteThermiqueSol);
    
    // Calcul du coefficient de performance (COP)
    final cop = _calculerCOP(temperatureEau);
    
    return {
      'longueur_sonde': longueurSonde,
      'profondeur_sonde': _profondeurCaptage,
      'cop': cop,
      'puissance_thermique': puissanceThermique,
      'type_captage': 'sur_sonde',
    };
  }

  static double _calculerCOP(double temperatureEau) {
    // Calcul simplifié du COP en fonction de la température de l'eau
    final deltaT = _temperatureSolProfondeur - temperatureEau;
    return 3.0 + (deltaT / 10.0); // COP de base de 3.0, amélioré par la différence de température
  }
} 