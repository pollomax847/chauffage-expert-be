import 'dart:math';

class BEHydraulique {
  // Coefficients de simultanéité selon le type de bâtiment
  static const Map<String, double> coefficientsSimultaneite = {
    'maison_individuelle': 0.5,
    'logement_collectif': 0.7,
    'bureau': 0.6,
    'commerce': 0.8,
    'industrie': 0.9,
  };

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

  // Calcul du débit probable
  static Map<String, dynamic> calculerDebitProbable({
    required String typeBatiment,
    required Map<String, int> appareils,
  }) {
    // Coefficient de simultanéité
    final k = coefficientsSimultaneite[typeBatiment] ?? 0.7;

    // Calcul de la somme des débits unitaires
    double sommeDebitsUnitaires = 0;
    for (var entry in appareils.entries) {
      final debitUnitaire = debitsUnitaires[entry.key] ?? 0.0;
      sommeDebitsUnitaires += debitUnitaire * entry.value;
    }

    // Débit probable (l/s)
    final debitProbable = k * sqrt(sommeDebitsUnitaires);

    return {
      'debitProbable': debitProbable.toStringAsFixed(2),
      'coefficientSimultaneite': k.toStringAsFixed(2),
      'sommeDebitsUnitaires': sommeDebitsUnitaires.toStringAsFixed(2),
      'appareils': appareils,
    };
  }

  // Calcul du diamètre de la canalisation
  static Map<String, dynamic> calculerDiametre({
    required double debit,
    required double vitesseMaximale, // m/s
  }) {
    // Section de passage (m²)
    final section = (debit / 1000) / vitesseMaximale;

    // Diamètre intérieur (mm)
    final diametreInterieur = sqrt((4 * section) / pi) * 1000;

    // Diamètre nominal standard
    final diametresStandards = [10, 12, 15, 20, 25, 32, 40, 50, 65, 80, 100];
    int diametreNominal = diametresStandards.firstWhere(
      (d) => d >= diametreInterieur,
      orElse: () => diametresStandards.last,
    );

    return {
      'diametreInterieur': diametreInterieur.toStringAsFixed(1),
      'diametreNominal': diametreNominal.toString(),
      'section': section.toStringAsFixed(6),
      'vitesse': (debit / 1000 / section).toStringAsFixed(2),
    };
  }

  // Calcul des pertes de charge
  static Map<String, dynamic> calculerPertesCharge({
    required double debit,
    required double diametre,
    required double longueur,
    required int nombreCoudes,
    required double rugosite, // mm
  }) {
    // Vitesse d'écoulement (m/s)
    final section = pi * pow(diametre / 2000, 2);
    final vitesse = (debit / 1000) / section;

    // Nombre de Reynolds
    const viscosite = 1.003e-6; // m²/s à 20°C
    final reynolds = (vitesse * diametre / 1000) / viscosite;

    // Coefficient de perte de charge linéaire (Darcy-Weisbach)
    final lambda = 0.316 / pow(reynolds, 0.25);

    // Pertes de charge linéaires (mCE)
    final pertesLineaires =
        lambda * (longueur / (diametre / 1000)) * pow(vitesse, 2) / (2 * 9.81);

    // Pertes de charge singulières (mCE)
    const kCoude = 0.3; // Coefficient de perte de charge pour un coude
    final pertesSingulieres =
        nombreCoudes * kCoude * pow(vitesse, 2) / (2 * 9.81);

    // Pertes de charge totales (mCE)
    final pertesTotales = pertesLineaires + pertesSingulieres;

    return {
      'pertesLineaires': pertesLineaires.toStringAsFixed(2),
      'pertesSingulieres': pertesSingulieres.toStringAsFixed(2),
      'pertesTotales': pertesTotales.toStringAsFixed(2),
      'vitesse': vitesse.toStringAsFixed(2),
      'reynolds': reynolds.toStringAsFixed(0),
    };
  }
}
