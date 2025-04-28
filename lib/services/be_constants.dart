class BEConstants {
  // Coefficients pour les calculs de chauffage
  static const Map<String, double> coefficientsDeperdition = {
    'mur_exterieur': 0.5,
    'mur_interieur': 0.3,
    'plancher': 0.4,
    'plafond': 0.3,
    'fenetre_simple': 5.0,
    'fenetre_double': 2.8,
    'fenetre_triple': 1.3,
    'porte': 3.5,
  };

  // Températures de base par zone climatique
  static const Map<String, double> temperaturesBase = {
    'H1': -7.0,
    'H2': -5.0,
    'H3': -2.0,
  };

  // Débits unitaires pour appareils sanitaires
  static const Map<String, double> debitsUnitaires = {
    'baignoire': 0.33,
    'douche': 0.20,
    'lavabo': 0.10,
    'evier': 0.20,
    'wc': 0.10,
    'lave_linge': 0.20,
    'lave_vaisselle': 0.15,
    'bidet': 0.10,
  };

  // Coefficients de simultanéité pour ECS
  static const Map<String, double> coefficientsSimultaneite = {
    'maison_individuelle': 0.8,
    'immeuble_collectif': 0.6,
    'hotel': 0.7,
    'bureau': 0.5,
    'hopital': 0.9,
  };

  // Diamètres standards de canalisations (mm)
  static const List<double> diametresStandards = [
    12.0,
    14.0,
    16.0,
    20.0,
    25.0,
    32.0,
    40.0,
    50.0,
    63.0,
    75.0,
    90.0,
    110.0
  ];

  // Rugosité des matériaux (mm)
  static const Map<String, double> rugositesMateriaux = {
    'pvc': 0.007,
    'cuivre': 0.0015,
    'acier': 0.045,
    'fonte': 0.26,
    'per': 0.007,
  };

  // Pentes minimales pour les conduites d'évacuation (%)
  static const Map<int, double> pentesMinimales = {
    32: 1.5,
    40: 1.0,
    50: 1.0,
    75: 0.5,
    90: 0.5,
    100: 0.5,
    110: 0.5,
    125: 0.5,
    160: 0.5,
  };
}
