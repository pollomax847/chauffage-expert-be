import 'dart:math';

class BEVMC {
  // Débits d'air neuf selon le type de local
  static const Map<String, double> debitsAirNeuf = {
    'sejour': 30,
    'chambre': 15,
    'cuisine': 45,
    'salle_de_bain': 15,
    'wc': 15,
    'buanderie': 15,
    'garage': 15,
  };

  // Coefficients de débit selon le type de VMC
  static const Map<String, double> coefficientsDebit = {
    'simple_flux': 0.5,
    'double_flux': 0.7,
    'hygroréglable': 0.6,
  };

  // Calcul du débit total
  static Map<String, dynamic> calculerDebitTotal({
    required Map<String, int> locaux,
  }) {
    double debitTotal = 0;
    Map<String, double> debitsParLocal = {};

    for (var entry in locaux.entries) {
      final debitLocal = debitsAirNeuf[entry.key] ?? 0.0;
      final debit = debitLocal * entry.value;
      debitsParLocal[entry.key] = debit;
      debitTotal += debit;
    }

    return {
      'debitTotal': debitTotal.toStringAsFixed(2),
      'debitsParLocal': debitsParLocal,
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
    final vitesse = debit / section;

    // Pertes de charge linéaires (Pa)
    final lambda = 0.316 / pow((vitesse * diametre / 1000) / 1.5e-5, 0.25);
    final pertesLineaires =
        lambda * (longueur / (diametre / 1000)) * pow(vitesse, 2) / 2 * 1.2;

    // Pertes de charge singulières (Pa)
    const kCoude = 0.3;
    final pertesSingulieres = nombreCoudes * kCoude * pow(vitesse, 2) / 2 * 1.2;

    // Pertes de charge totales (Pa)
    final pertesTotales = pertesLineaires + pertesSingulieres;

    return {
      'pertesLineaires': pertesLineaires.toStringAsFixed(2),
      'pertesSingulieres': pertesSingulieres.toStringAsFixed(2),
      'pertesTotales': pertesTotales.toStringAsFixed(2),
      'vitesse': vitesse.toStringAsFixed(2),
    };
  }

  // Calcul du débit VMC
  static Map<String, dynamic> calculerDebitVMC({
    required double volumeHabitable,
    required String typeVMC,
    required int nombrePieces,
  }) {
    // Coefficient de débit selon le type de VMC
    final coefficient = coefficientsDebit[typeVMC] ?? 0.5;

    // Débit minimal selon la réglementation (m³/h)
    final debitMinimal = volumeHabitable * coefficient;

    // Ajustement selon le nombre de pièces
    final debitAjuste = debitMinimal * (1 + (nombrePieces - 1) * 0.1);

    return {
      'debitMinimal': debitMinimal.toStringAsFixed(2),
      'debitAjuste': debitAjuste.toStringAsFixed(2),
      'typeVMC': typeVMC,
      'nombrePieces': nombrePieces,
      'volumeHabitable': volumeHabitable,
    };
  }

  // Calcul de la puissance du ventilateur
  static Map<String, dynamic> calculerPuissanceVentilateur({
    required double debit,
    required double perteCharge,
  }) {
    // Puissance en watts
    final puissance =
        (debit * perteCharge) / (3600 * 0.5); // 0.5 = rendement estimé

    return {
      'puissance': puissance.toStringAsFixed(2),
      'debit': debit,
      'perteCharge': perteCharge,
    };
  }

  // Recommandation du débit du caisson VMC sanitaire
  static Map<String, dynamic> recommanderDebitCaisson({
    required int nombreLogements,
    required double tauxOccupation,
    required String typeVMC,
    required bool avecBallonThermodynamique,
  }) {
    // Débit de base par logement selon le type de VMC
    final debitsBase = {
      'simple flux': 15.0,
      'double flux': 30.0,
      'hygroréglable': 20.0,
    };

    final debitBase = debitsBase[typeVMC] ?? 15.0;

    // Débit total recommandé (m³/h)
    final debitTotal = debitBase * nombreLogements * tauxOccupation;

    // Puissance recommandée (W)
    final puissance = debitTotal * 0.2;

    // Consommation annuelle estimée (kWh)
    final consommationAnnuelle = puissance * 24 * 365 / 1000;

    // Calculs spécifiques pour VMC avec ballon thermodynamique
    double puissanceBallon = 0;
    double consommationBallon = 0;
    double copBallon = 0;

    if (avecBallonThermodynamique) {
      // Puissance du ballon thermodynamique (W)
      puissanceBallon = 1000.0; // 1 kW par défaut

      // COP du ballon thermodynamique selon le type de VMC
      final cops = {
        'simple flux': 2.5,
        'double flux': 3.0,
        'hygroréglable': 2.8,
      };
      copBallon = cops[typeVMC] ?? 2.5;

      // Consommation du ballon (kWh/an)
      consommationBallon = (puissanceBallon * 24 * 365 / 1000) / copBallon;
    }

    return {
      'debitBase': debitBase.toStringAsFixed(1),
      'debitTotal': debitTotal.toStringAsFixed(1),
      'puissance': puissance.toStringAsFixed(1),
      'consommationAnnuelle': consommationAnnuelle.toStringAsFixed(1),
      'avecBallonThermodynamique': avecBallonThermodynamique,
      'puissanceBallon': puissanceBallon.toStringAsFixed(1),
      'copBallon': copBallon.toStringAsFixed(1),
      'consommationBallon': consommationBallon.toStringAsFixed(1),
      'consommationTotale':
          (consommationAnnuelle + consommationBallon).toStringAsFixed(1),
    };
  }
}
