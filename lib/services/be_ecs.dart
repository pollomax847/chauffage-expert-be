import 'package:flutter/foundation.dart';
import 'dart:math';

class BEECS {
  // Besoins en eau chaude selon le type d'établissement
  static const Map<String, double> besoinsECS = {
    'maison_individuelle': 50,
    'logement_collectif': 40,
    'hotel': 60,
    'restaurant': 20,
    'hopital': 80,
  };

  // Températures de référence
  static const double temperatureFroide = 10;
  static const double temperatureChaude = 60;

  // Calcul du volume de stockage
  static Map<String, dynamic> calculerVolumeStockage({
    required String typeEtablissement,
    required int nombrePersonnes,
    required double coefficientSimultaneite,
  }) {
    final besoinUnitaire = besoinsECS[typeEtablissement] ?? 50.0;
    final volumeTheorique = besoinUnitaire * nombrePersonnes;
    final volumeStockage = volumeTheorique * coefficientSimultaneite;

    return {
      'volumeTheorique': volumeTheorique.toStringAsFixed(2),
      'volumeStockage': volumeStockage.toStringAsFixed(2),
      'coefficientSimultaneite': coefficientSimultaneite.toStringAsFixed(2),
    };
  }

  // Calcul de la puissance nécessaire
  static Map<String, dynamic> calculerPuissance({
    required double volumeStockage,
    required double tempsRechauffement,
  }) {
    // Chaleur massique de l'eau : 4.18 kJ/kg.K
    // Masse volumique de l'eau : 1 kg/L
    final puissance =
        (volumeStockage * 4.18 * (temperatureChaude - temperatureFroide)) /
            (tempsRechauffement * 3600);

    return {
      'puissance': puissance.toStringAsFixed(2),
      'tempsRechauffement': tempsRechauffement.toStringAsFixed(2),
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
    final kCoude = 0.3;
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
}
