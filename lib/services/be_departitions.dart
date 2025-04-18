import 'package:flutter/foundation.dart';

class BEDepartitions {
  // Coefficients de déperdition selon l'année de construction
  static const Map<String, double> coefficientsDep = {
    'avant 1974': 1.75,
    '1974-1982': 1.50,
    '1983-1989': 1.25,
    '1990-2005': 1.00,
    '2006-2012': 0.80,
    '2013-2020': 0.60,
    'après 2020': 0.40,
  };

  // Calcul des déperditions d'une pièce
  static Map<String, dynamic> calculerDepPerditions({
    required String anneeConstruction,
    required double surface,
    required double hauteurSousPlafond,
    required double temperatureAmbiante,
    required double temperatureExterieure,
  }) {
    // Coefficient de déperdition selon l'année
    final coefficient = coefficientsDep[anneeConstruction] ?? 1.0;

    // Volume de la pièce
    final volume = surface * hauteurSousPlafond;

    // ΔT = T intérieure - T extérieure
    final deltaT = temperatureAmbiante - temperatureExterieure;

    // Calcul des déperditions (W)
    final deperditions = volume * coefficient * deltaT;

    return {
      'deperditions': deperditions.toStringAsFixed(2),
      'volume': volume.toStringAsFixed(2),
      'coefficient': coefficient.toStringAsFixed(2),
      'deltaT': deltaT.toStringAsFixed(1),
    };
  }

  // Calcul des déperditions totales d'un bâtiment
  static Map<String, dynamic> calculerDepPerditionsTotal({
    required List<Map<String, dynamic>> pieces,
    required double temperatureExterieure,
  }) {
    double totalDeperditions = 0;
    List<Map<String, dynamic>> resultatsPieces = [];

    for (var piece in pieces) {
      final resultat = calculerDepPerditions(
        anneeConstruction: piece['anneeConstruction'],
        surface: piece['surface'],
        hauteurSousPlafond: piece['hauteurSousPlafond'],
        temperatureAmbiante: piece['temperatureAmbiante'],
        temperatureExterieure: temperatureExterieure,
      );

      totalDeperditions += double.parse(resultat['deperditions']);
      resultatsPieces.add({
        'nom': piece['nom'],
        ...resultat,
      });
    }

    return {
      'totalDeperditions': totalDeperditions.toStringAsFixed(2),
      'pieces': resultatsPieces,
    };
  }

  // Calcul de la consommation annuelle
  static Map<String, dynamic> calculerConsommation({
    required double deperditions,
    required int dju, // Degré jour unifié
    required double rendement,
    required bool estNeuf, // Pour le coefficient d'intermittence
  }) {
    // Coefficient d'intermittence
    final i = estNeuf ? 0.8 : 0.9;

    // Consommation annuelle en kWh
    final consommation = (deperditions * 24 * dju * i) / rendement;

    return {
      'consommation': consommation.toStringAsFixed(2),
      'dju': dju.toString(),
      'rendement': rendement.toStringAsFixed(2),
      'intermittence': i.toStringAsFixed(1),
    };
  }
}
