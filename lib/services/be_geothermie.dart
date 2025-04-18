import 'dart:math';

class BEGeothermie {
  // Coefficients de puissance selon le type de captage
  static const Map<String, double> coefficientsCaptage = {
    'horizontal': 30, // W/m²
    'vertical': 50, // W/m
    'sur_sonde': 40, // W/m
  };

  // Calcul de la puissance géothermique
  static Map<String, dynamic> calculerPuissance({
    required double puissanceCalculee,
    required String typeCaptage,
    required double surfaceTerrain,
  }) {
    // Coefficient selon le type de captage
    final coefficient = coefficientsCaptage[typeCaptage] ?? 30;

    // Calcul de la puissance disponible
    double puissanceDisponible;
    if (typeCaptage == 'horizontal') {
      puissanceDisponible = surfaceTerrain * coefficient;
    } else {
      // Pour les captages verticaux, on considère une profondeur moyenne de 100m
      puissanceDisponible = surfaceTerrain * coefficient * 100;
    }

    // Vérification de la suffisance
    final suffisant = puissanceDisponible >= puissanceCalculee;

    return {
      'puissanceCalculee': puissanceCalculee.toStringAsFixed(2),
      'puissanceDisponible': puissanceDisponible.toStringAsFixed(2),
      'typeCaptage': typeCaptage,
      'surfaceTerrain': surfaceTerrain,
      'suffisant': suffisant,
      'ratio': (puissanceDisponible / puissanceCalculee).toStringAsFixed(2),
    };
  }

  // Calcul de la longueur de sonde nécessaire
  static Map<String, dynamic> calculerLongueurSonde({
    required double puissanceCalculee,
    required String typeCaptage,
  }) {
    final coefficient = coefficientsCaptage[typeCaptage] ?? 30;
    final longueur = puissanceCalculee / coefficient;

    return {
      'longueur': longueur.toStringAsFixed(2),
      'typeCaptage': typeCaptage,
      'puissanceCalculee': puissanceCalculee,
    };
  }

  // Calcul des PAC géothermiques
  static Map<String, dynamic> dimensionnerPACGeothermique({
    required double puissanceThermique,
    required double temperatureSource,
    required double temperatureEmise,
    required String typeCaptage,
  }) {
    // COP théorique
    final copTheorique =
        (temperatureEmise + 273.15) / (temperatureEmise - temperatureSource);

    // COP réel selon le type de captage
    final coefficientsCOP = {
      'horizontal': 0.7,
      'vertical': 0.8,
      'sur_eau': 0.75,
    };

    final coefficient = coefficientsCOP[typeCaptage] ?? 0.7;
    final copReel = copTheorique * coefficient;

    // Puissance électrique (kW)
    final puissanceElectrique = puissanceThermique / copReel;

    // Débit source (m³/h)
    final debitSource =
        puissanceThermique / (4.18 * (temperatureEmise - temperatureSource));

    // Surface de captage (m²)
    final surfaceCaptage =
        puissanceThermique * (typeCaptage == 'horizontal' ? 1.5 : 1.0);

    return {
      'copTheorique': copTheorique.toStringAsFixed(2),
      'copReel': copReel.toStringAsFixed(2),
      'puissanceElectrique': puissanceElectrique.toStringAsFixed(1),
      'debitSource': debitSource.toStringAsFixed(2),
      'surfaceCaptage': surfaceCaptage.toStringAsFixed(0),
    };
  }

  // Calcul des réseaux de stockage thermique
  static Map<String, dynamic> dimensionnerStockageThermique({
    required double puissanceThermique,
    required double dureeStockage,
    required double temperatureStockage,
    required double temperatureUtilisation,
  }) {
    // Capacité thermique (kWh)
    final capaciteThermique = puissanceThermique * dureeStockage;

    // Volume de stockage (m³)
    final volumeStockage = capaciteThermique /
        (4.18 * (temperatureStockage - temperatureUtilisation));

    // Surface d'échange (m²)
    final surfaceEchange = puissanceThermique / 0.8;

    // Puissance de pompage (kW)
    final puissancePompage = puissanceThermique * 0.05;

    return {
      'capaciteThermique': capaciteThermique.toStringAsFixed(0),
      'volumeStockage': volumeStockage.toStringAsFixed(1),
      'surfaceEchange': surfaceEchange.toStringAsFixed(1),
      'puissancePompage': puissancePompage.toStringAsFixed(1),
    };
  }

  // Calcul des sondes géothermiques
  static Map<String, dynamic> dimensionnerSondesGeothermiques({
    required double puissanceThermique,
    required double profondeur,
    required double conductiviteThermique,
  }) {
    // Puissance linéique (W/m)
    final puissanceLineique = conductiviteThermique * 50;

    // Longueur totale (m)
    final longueurTotale = puissanceThermique * 1000 / puissanceLineique;

    // Nombre de sondes
    final nombreSondes = (longueurTotale / profondeur).ceil();

    // Espacement entre sondes (m)
    final espacement = sqrt(puissanceThermique / nombreSondes);

    return {
      'puissanceLineique': puissanceLineique.toStringAsFixed(1),
      'longueurTotale': longueurTotale.toStringAsFixed(0),
      'nombreSondes': nombreSondes.toStringAsFixed(0),
      'espacement': espacement.toStringAsFixed(1),
    };
  }

  static Map<String, double> dimensionnerPompesCirculation({
    required double debit,
    required double hauteurManometrique,
    required double rendement,
  }) {
    // Calcul de la puissance hydraulique (kW)
    final puissanceHydraulique = (debit * hauteurManometrique * 9.81) / 3600;

    // Calcul de la puissance absorbée (kW)
    final puissanceAbsorbee = puissanceHydraulique / (rendement / 100);

    // Estimation de la vitesse de rotation (tr/min)
    final vitesseRotation =
        1450.0; // Vitesse standard pour les pompes de circulation

    return {
      'puissanceHydraulique': puissanceHydraulique,
      'puissanceAbsorbee': puissanceAbsorbee,
      'vitesseRotation': vitesseRotation,
    };
  }
}
