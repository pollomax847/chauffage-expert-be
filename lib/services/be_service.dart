import 'dart:math';
import 'be_constants.dart';
import 'be_security_service.dart';

class BEService {
  // 1. Calcul du volume d'eau du circuit
  static double calculerVolumeCircuit({
    required double longueurTuyauterie,
    required double diametre,
    required int nombreRadiateurs,
    double volumeBallon = 0,
  }) {
    // Volume de la tuyauterie (πr²h)
    final section = pi * pow(diametre / 2000, 2); // Conversion mm en m
    final volumeTuyauterie =
        section * longueurTuyauterie * 1000; // Conversion en litres

    // Volume estimé des radiateurs (approximation)
    final volumeRadiateurs =
        nombreRadiateurs * 1.5; // 1.5L par radiateur en moyenne

    return volumeTuyauterie + volumeRadiateurs + volumeBallon;
  }

  // 2. Calcul des pertes de charge
  static Map<String, double> calculerPertesCharge({
    required String typeTube,
    required double longueur,
    required int nombreCoudes,
    required double debit,
  }) {
    // Coefficients de perte de charge selon le type de tube
    final coefficients = {
      'cuivre': 0.02,
      'per': 0.03,
      'acier': 0.04,
    };

    final coefficient = coefficients[typeTube] ?? 0.03;

    // Pertes linéaires (Pa/m)
    final pertesLineaires =
        coefficient * pow(debit / 3600, 1.85) / pow(0.02, 4.87);

    // Pertes singulières (équivalent longueur droite)
    final pertesSingulieres = nombreCoudes * 0.5; // 0.5m équivalent par coude

    // Pertes totales (kPa)
    final pertesTotales =
        (pertesLineaires * (longueur + pertesSingulieres)) / 1000;

    return {
      'pertesLineaires': pertesLineaires,
      'pertesSingulieres': pertesSingulieres,
      'pertesTotales': pertesTotales,
    };
  }

  // 3. Temps de chauffe ballon ECS
  static double calculerTempsChauffe({
    required double volumeBallon,
    required double temperatureConsigne,
    required double temperatureEntree,
    required double puissanceDisponible,
  }) {
    // Capacité thermique de l'eau : 4.18 kJ/kg.K
    // Masse volumique de l'eau : 1 kg/L
    final energieNecessaire =
        volumeBallon * 4.18 * (temperatureConsigne - temperatureEntree);
    final tempsHeures = energieNecessaire / (puissanceDisponible * 3600);
    return tempsHeures * 60; // Conversion en minutes
  }

  // 4. Rendement réel chaudière
  static double calculerRendement({
    required String typeChaudiere,
    required double puissanceNominale,
    required double puissanceUtile,
    required double temperatureFumee,
    required double temperatureExterieure,
  }) {
    // Calcul du rendement selon le type de chaudière
    double rendementBase = puissanceUtile / puissanceNominale * 100;

    // Ajustement selon la température des fumées
    final deltaT = temperatureFumee - temperatureExterieure;
    double coefficientTemperature = 1.0;

    if (deltaT > 200) {
      coefficientTemperature = 0.9;
    } else if (deltaT > 150) {
      coefficientTemperature = 0.95;
    }

    // Ajustement selon le type de chaudière
    double coefficientType = 1.0;
    switch (typeChaudiere) {
      case 'gaz':
        coefficientType = 0.98;
        break;
      case 'fioul':
        coefficientType = 0.95;
        break;
      case 'bois':
        coefficientType = 0.85;
        break;
    }

    return rendementBase * coefficientTemperature * coefficientType;
  }

  // 5. Estimation condensation chaudière
  static Map<String, dynamic> estimerCondensation({
    required double temperatureRetour,
    required String typeChaudiere,
    double humiditeRelative = 50,
  }) {
    // Point de rosée selon la température et l'humidité
    final pointRosee = 243.12 *
        (log(humiditeRelative / 100) +
            (17.62 * temperatureRetour) / (243.12 + temperatureRetour)) /
        (17.62 -
            log(humiditeRelative / 100) -
            (17.62 * temperatureRetour) / (243.12 + temperatureRetour));

    // Estimation du taux de condensation
    double tauxCondensation = 0;
    if (temperatureRetour < pointRosee) {
      tauxCondensation = (pointRosee - temperatureRetour) * 2; // Approximation
    }

    return {
      'tauxCondensation': tauxCondensation,
      'pointRosee': pointRosee,
      'condensationPossible': temperatureRetour < pointRosee,
    };
  }

  // 6. Équilibrage réseau
  static Map<String, dynamic> calculerEquilibrage({
    required List<Map<String, dynamic>> radiateurs,
    required List<Map<String, dynamic>> planchers,
  }) {
    final radiateurResults = _calculerEquilibrageEmetteurs(radiateurs);
    final planchersResults =
        _calculerEquilibrageEmetteurs(planchers, isPlancher: true);

    return {
      'radiateurs': radiateurResults,
      'planchers': planchersResults,
    };
  }

  // Méthode générique pour calculer l'équilibrage des émetteurs (radiateurs ou planchers)
  static List<Map<String, dynamic>> _calculerEquilibrageEmetteurs(
      List<Map<String, dynamic>> emetteurs,
      {bool isPlancher = false}) {
    final results = <Map<String, dynamic>>[];

    for (final emetteur in emetteurs) {
      try {
        // Extraction des paramètres
        final puissance = emetteur['puissance'] as double;
        final deltaT = emetteur['deltaT'] as double;
        final typeTube = emetteur['typeTube'] as String;
        final longueur = emetteur['longueur'] as double;
        final nombreCoudes = emetteur['nombreCoudes'] as int;

        // Calcul du débit
        final debit = _calculerDebit(puissance, deltaT);

        // Calcul des pertes de charge
        final rugosite = BEConstants.rugositesMateriaux[typeTube] ?? 0.007;
        final diametre = isPlancher ? 16.0 : 12.0; // mm
        final pertesCharge = _calculerPertesCharge(
          debit: debit,
          diametre: diametre,
          longueur: longueur,
          nombreCoudes: nombreCoudes,
          rugosite: rugosite,
        );

        results.add({
          'debit': debit,
          'pertesCharge': pertesCharge,
          'diametre': diametre,
          'typeTube': typeTube,
        });
      } catch (e) {
        BESecurityService.logSecurityEvent(
            'erreur', 'Erreur de calcul d\'équilibrage: $e');

        // Ajouter un résultat d'erreur pour ne pas casser l'interface
        results.add({
          'debit': 0.0,
          'pertesCharge': 0.0,
          'diametre': isPlancher ? 16.0 : 12.0,
          'typeTube': emetteur['typeTube'] ?? 'per',
          'erreur': true,
        });
      }
    }

    return results;
  }

  // Calcul du débit en fonction de la puissance et du delta T
  static double _calculerDebit(double puissance, double deltaT) {
    // Q = P / (ρ * Cp * ΔT) * 3600
    // avec P en kW, ρ = 1 kg/L, Cp = 4.18 kJ/kg/K, ΔT en K
    return (puissance / (4.18 * deltaT)) * 3600;
  }

  // Calcul des pertes de charge linéaires et singulières
  static double _calculerPertesCharge({
    required double debit,
    required double diametre,
    required double longueur,
    required int nombreCoudes,
    required double rugosite,
  }) {
    // Conversion des unités
    final debitM3s = debit / 3600; // m³/s
    final diametreM = diametre / 1000; // m

    // Vitesse d'écoulement (m/s)
    final section = pi * pow(diametreM / 2, 2);
    final vitesse = debitM3s / section;

    // Nombre de Reynolds
    const viscosite = 1.003e-6; // m²/s à 20°C
    final reynolds = (vitesse * diametreM) / viscosite;

    // Coefficient de perte de charge linéaire (Darcy-Weisbach)
    final lambda = _calculerLambda(reynolds, rugosite, diametreM);

    // Pertes de charge linéaires (kPa)
    final pertesLineaires =
        lambda * (longueur / diametreM) * (pow(vitesse, 2) / 2) * 1000 * 0.001;

    // Pertes de charge singulières (kPa)
    const kCoude = 0.3; // Coefficient pour un coude standard
    final pertesSingulieres =
        nombreCoudes * kCoude * (pow(vitesse, 2) / 2) * 1000 * 0.001;

    // Pertes de charge totales (kPa)
    return pertesLineaires + pertesSingulieres;
  }

  // Calcul du coefficient lambda selon la formule de Colebrook-White
  static double _calculerLambda(
      double reynolds, double rugosite, double diametre) {
    if (reynolds < 2300) {
      // Régime laminaire
      return 64 / reynolds;
    } else if (reynolds > 4000) {
      // Régime turbulent
      // Approximation de Swamee-Jain
      final rugositeRelative = (rugosite / 1000) / diametre;
      return 0.25 /
          pow(log10(rugositeRelative / 3.7 + 5.74 / pow(reynolds, 0.9)), 2);
    } else {
      // Régime transitoire - moyenne pondérée
      final lambdaLaminaire = 64 / reynolds;
      final rugositeRelative = (rugosite / 1000) / diametre;
      final lambdaTurbulent =
          0.25 / pow(log10(rugositeRelative / 3.7 + 5.74 / pow(4000, 0.9)), 2);

      // Interpolation
      final factor = (reynolds - 2300) / (4000 - 2300);
      return lambdaLaminaire * (1 - factor) + lambdaTurbulent * factor;
    }
  }

  // 7. Valeurs ohmiques des sondes
  static Map<String, dynamic> verifierSonde({
    required double temperature,
    required double valeurOhmique,
    required String typeSonde,
  }) {
    // Valeurs de référence selon le type de sonde
    final references = {
      'PT100': {
        'equation': (double t) => 100 * (1 + 0.00385 * t),
        'tolerance': 0.1,
      },
      'PT1000': {
        'equation': (double t) => 1000 * (1 + 0.00385 * t),
        'tolerance': 1.0,
      },
      'NTC10K': {
        'equation': (double t) =>
            10000 * exp(3950 * (1 / (t + 273.15) - 1 / 298.15)),
        'tolerance': 5.0,
      },
    };

    final reference = references[typeSonde] ?? references['PT100']!;
    final equation = reference['equation'] as double Function(double);
    final tolerance = reference['tolerance'] as double;

    final valeurTheorique = equation(temperature);
    final difference = (valeurOhmique - valeurTheorique).abs();
    final conforme = difference <= tolerance;

    return {
      'valeurTheorique': valeurTheorique,
      'difference': difference,
      'conforme': conforme,
      'tolerance': tolerance,
    };
  }
}
