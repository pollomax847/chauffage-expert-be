import 'package:flutter/foundation.dart';
import 'dart:math';

class BEEUEV {
  // Débits unitaires des appareils sanitaires (l/s)
  static const Map<String, double> debitsUnitaires = {
    'lavabo': 0.2,
    'evier': 0.2,
    'bain': 0.33,
    'douche': 0.2,
    'wc': 0.2,
    'lave_linge': 0.2,
    'lave_vaisselle': 0.2,
    'bidet': 0.1,
  };

  // Pentes minimales selon le diamètre (mm/m)
  static const Map<int, double> pentesMinimales = {
    32: 0.01,
    40: 0.008,
    50: 0.006,
    63: 0.005,
    75: 0.004,
    100: 0.003,
    125: 0.002,
    160: 0.0015,
  };

  // Calcul du débit maximal
  static Map<String, dynamic> calculerDebitMax({
    required int nombreEquipements,
    required double pente,
    required double diametre,
  }) {
    final debitMax = nombreEquipements * 0.5; // L/s
    bool conforme = pente >= 1.5 && diametre >= 100;
    String recommandation = '';

    if (!conforme) {
      if (pente < 1.5) {
        recommandation = 'Augmenter la pente à 1.5% minimum';
      }
      if (diametre < 100) {
        recommandation += recommandation.isNotEmpty ? '\n' : '';
        recommandation += 'Augmenter le diamètre à 100mm minimum';
      }
    }

    return {
      'debitMax': debitMax.toStringAsFixed(2),
      'conforme': conforme,
      'penteMin': 1.5,
      'diametreMin': 100,
      'recommandation': recommandation,
    };
  }

  // Calcul du nombre de descentes nécessaires
  static Map<String, dynamic> calculerDescentes({
    required double surfaceToit,
    required double pluieProjet,
    required double diametre,
  }) {
    final debit = surfaceToit * pluieProjet / 3600; // m³/h
    final nombreDescentes = (debit / 6).ceil();
    bool conforme = diametre >= 80;
    String recommandation = '';

    if (!conforme) {
      recommandation = 'Augmenter le diamètre à 80mm minimum';
    }

    return {
      'debit': debit.toStringAsFixed(2),
      'nombreDescentes': nombreDescentes,
      'conforme': conforme,
      'diametreMin': 80,
      'recommandation': recommandation,
    };
  }

  // Vérification des pentes selon DTU 60.11
  static Map<String, dynamic> verifierPentes({
    required double longueur,
    required double pente,
    required String typeReseau,
  }) {
    double penteMin = 1.5;
    double penteMax = 5.0;

    if (typeReseau == 'EU') {
      penteMin = 1.5;
      penteMax = 5.0;
    } else if (typeReseau == 'EP') {
      penteMin = 0.5;
      penteMax = 10.0;
    }

    bool conforme = pente >= penteMin && pente <= penteMax;
    String recommandation = '';

    if (!conforme) {
      if (pente < penteMin) {
        recommandation = 'Augmenter la pente à $penteMin% minimum';
      } else if (pente > penteMax) {
        recommandation = 'Réduire la pente à $penteMax% maximum';
      }
    }

    return {
      'penteMin': penteMin,
      'penteMax': penteMax,
      'conforme': conforme,
      'recommandation': recommandation,
    };
  }

  // Calcul du débit probable
  static Map<String, dynamic> calculerDebitProbable({
    required Map<String, int> appareils,
  }) {
    double debitTotal = 0;
    Map<String, double> debitsParAppareil = {};

    for (var entry in appareils.entries) {
      final debitUnitaire = debitsUnitaires[entry.key] ?? 0.0;
      final debit = debitUnitaire * entry.value;
      debitsParAppareil[entry.key] = debit;
      debitTotal += debit;
    }

    return {
      'debitTotal': debitTotal.toStringAsFixed(2),
      'debitsParAppareil': debitsParAppareil,
    };
  }

  // Calcul du diamètre minimal
  static Map<String, dynamic> calculerDiametre({
    required double debit,
    required double pente,
  }) {
    // Vitesse minimale (m/s)
    const vitesseMinimale = 0.6;

    // Section minimale (m²)
    final sectionMinimale = (debit / 1000) / vitesseMinimale;

    // Diamètre minimal (mm)
    final diametreMinimal = sqrt((4 * sectionMinimale) / pi) * 1000;

    // Diamètres standards disponibles
    final diametresStandards = pentesMinimales.keys.toList();
    diametresStandards.sort();

    // Sélection du diamètre standard
    int diametre = diametresStandards.firstWhere(
      (d) => d >= diametreMinimal,
      orElse: () => diametresStandards.last,
    );

    // Vérification de la pente
    final penteMinimale = pentesMinimales[diametre] ?? 0.01;
    final penteOK = pente >= penteMinimale;

    return {
      'diametre': diametre.toString(),
      'penteMinimale': penteMinimale.toStringAsFixed(3),
      'penteOK': penteOK,
    };
  }

  // Calcul de la vitesse d'écoulement
  static Map<String, dynamic> calculerVitesse({
    required double debit,
    required double diametre,
    required double pente,
  }) {
    // Section (m²)
    final section = pi * pow(diametre / 2000, 2);

    // Vitesse théorique (m/s)
    final vitesse = (debit / 1000) / section;

    // Vérification de la vitesse minimale
    const vitesseMinimale = 0.6;
    final vitesseOK = vitesse >= vitesseMinimale;

    return {
      'vitesse': vitesse.toStringAsFixed(2),
      'vitesseMinimale': vitesseMinimale.toStringAsFixed(2),
      'vitesseOK': vitesseOK,
    };
  }
}
