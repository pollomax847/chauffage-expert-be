import 'dart:math';

class BEChauffage {
  // Coefficients de déperdition selon le type de paroi
  static const Map<String, double> coefficientsDeperdition = {
    'mur_exterieur': 0.36,
    'mur_interieur': 0.36,
    'plancher_bas': 0.36,
    'plancher_haut': 0.20,
    'toiture': 0.20,
    'porte': 1.8,
    'fenetre': 1.4,
  };

  // Températures de base selon la zone climatique
  static const Map<String, double> temperaturesBase = {
    'H1a': -9,
    'H1b': -6,
    'H1c': -3,
    'H2a': -6,
    'H2b': -3,
    'H2c': 0,
    'H2d': 3,
    'H3': 0,
  };

  // Calcul des déperditions
  static Map<String, dynamic> calculerDeperditions({
    required Map<String, double> surfaces,
    required String zoneClimatique,
    required double temperatureInterieure,
    required double temperatureExterieure,
  }) {
    double deperditionsTotales = 0;
    Map<String, double> deperditionsParParoi = {};

    for (var entry in surfaces.entries) {
      final coefficient = coefficientsDeperdition[entry.key] ?? 0.0;
      final deperditions = coefficient *
          entry.value *
          (temperatureInterieure - temperatureExterieure);
      deperditionsParParoi[entry.key] = deperditions;
      deperditionsTotales += deperditions;
    }

    return {
      'deperditionsTotales': deperditionsTotales.toStringAsFixed(2),
      'deperditionsParParoi': deperditionsParParoi,
    };
  }

  // Calcul de la puissance nécessaire
  static Map<String, dynamic> calculerPuissance({
    required double deperditions,
    required double coefficientSecurite,
  }) {
    final puissance = deperditions * coefficientSecurite;

    return {
      'puissance': puissance.toStringAsFixed(2),
      'coefficientSecurite': coefficientSecurite.toStringAsFixed(2),
    };
  }

  // Calcul des pertes de charge
  static Map<String, dynamic> calculerPertesCharge({
    required double debit,
    required double longueur,
    required double diametre,
    required int nombreCoudes,
  }) {
    // Vitesse d'écoulement (m/s)
    final section = pi * pow(diametre / 2000, 2);
    final vitesse = (debit / 1000) / section;

    // Pertes de charge linéaires (mCE)
    final lambda = 0.316 / pow((vitesse * diametre / 1000) / 1.003e-6, 0.25);
    final pertesLineaires =
        lambda * (longueur / (diametre / 1000)) * pow(vitesse, 2) / (2 * 9.81);

    // Pertes de charge singulières (mCE)
    const kCoude = 0.3;
    final pertesSingulieres =
        nombreCoudes * kCoude * pow(vitesse, 2) / (2 * 9.81);

    // Pertes de charge totales (mCE)
    final pertesTotales = pertesLineaires + pertesSingulieres;

    return {
      'pertesLineaires': pertesLineaires.toStringAsFixed(2),
      'pertesSingulieres': pertesSingulieres.toStringAsFixed(2),
      'pertesTotales': pertesTotales.toStringAsFixed(2),
      'vitesse': vitesse.toStringAsFixed(2),
    };
  }

  // Calcul du dimensionnement des tuyauteries
  static Map<String, dynamic> dimensionnerTuyauteries({
    required double puissance,
    required double deltaT,
  }) {
    final debit = puissance / (4185 * deltaT); // Q = P / (Cp * ΔT)
    String diametre = '12';

    if (debit > 0.5) diametre = '16';
    if (debit > 1.0) diametre = '20';
    if (debit > 2.0) diametre = '25';
    if (debit > 4.0) diametre = '32';

    return {
      'debit': debit.toStringAsFixed(2),
      'diametre': diametre,
      'deltaT': deltaT.toStringAsFixed(1),
    };
  }
}
