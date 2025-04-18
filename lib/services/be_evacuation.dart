import 'dart:math';

class BEEvacuation {
  // Débits d'évacuation selon le type d'appareil
  static const Map<String, double> debitsEvacuation = {
    'lavabo': 0.5,
    'douche': 0.8,
    'baignoire': 1.2,
    'wc': 1.5,
    'lave_linge': 0.6,
    'lave_vaisselle': 0.4,
    'evier': 0.7,
  };

  // Diamètres minimaux selon le type d'appareil
  static const Map<String, double> diametresMinimaux = {
    'lavabo': 32,
    'douche': 40,
    'baignoire': 40,
    'wc': 100,
    'lave_linge': 40,
    'lave_vaisselle': 40,
    'evier': 40,
  };

  // Coefficients de dimensionnement selon le type d'évacuation
  static const Map<String, double> coefficientsEvacuation = {
    'ventouse': 1.2,
    'cheminée': 1.0,
    'conduit': 1.1,
  };

  // Calcul du débit total et du diamètre
  static Map<String, dynamic> dimensionnerReseau({
    required Map<String, int> appareils,
    required double longueur,
    required double pente,
  }) {
    double debitTotal = 0;
    double diametreMinimal = 0;
    Map<String, double> debitsParAppareil = {};

    // Calcul des débits
    for (var entry in appareils.entries) {
      final debitAppareil = debitsEvacuation[entry.key] ?? 0.0;
      final debit = debitAppareil * entry.value;
      debitsParAppareil[entry.key] = debit;
      debitTotal += debit;
      diametreMinimal =
          max(diametreMinimal, diametresMinimaux[entry.key] ?? 0.0);
    }

    // Calcul du diamètre théorique (mm)
    final diametreTheorique = sqrt(debitTotal * 4 / (pi * 0.5)) * 1000;

    // Diamètre final (mm)
    final diametreFinal =
        max(diametreMinimal, diametreTheorique).ceilToDouble();

    // Vitesse d'écoulement (m/s)
    final section = pi * pow(diametreFinal / 2000, 2);
    final vitesse = debitTotal / section;

    return {
      'debitTotal': debitTotal.toStringAsFixed(2),
      'diametreMinimal': diametreMinimal.toStringAsFixed(0),
      'diametreTheorique': diametreTheorique.toStringAsFixed(0),
      'diametreFinal': diametreFinal.toStringAsFixed(0),
      'vitesse': vitesse.toStringAsFixed(2),
      'debitsParAppareil': debitsParAppareil,
    };
  }

  // Calcul des postes de relevage
  static Map<String, dynamic> dimensionnerPosteRelevage({
    required double debit,
    required double hauteurRelevage,
    required double longueurConduite,
  }) {
    // Puissance de la pompe (W)
    final puissance = (debit * hauteurRelevage * 9.81) / 0.7;

    // Volume de la cuve (m³)
    final volumeCuve = max(0.5, debit * 0.25);

    // Consommation annuelle (kWh)
    final consommationAnnuelle = (puissance * 24 * 365) / 1000;

    return {
      'puissance': puissance.toStringAsFixed(1),
      'volumeCuve': volumeCuve.toStringAsFixed(2),
      'consommationAnnuelle': consommationAnnuelle.toStringAsFixed(1),
    };
  }

  // Calcul des séparateurs d'hydrocarbures
  static Map<String, dynamic> dimensionnerSeparateur({
    required double debit,
    required String typeInstallation,
  }) {
    // Volume de rétention selon le type d'installation
    final volumes = {
      'parking': 0.1,
      'station_service': 0.2,
      'zone_industrielle': 0.3,
    };

    final volumeRetention = volumes[typeInstallation] ?? 0.1;

    // Volume du séparateur (m³)
    final volumeSeparateur = max(volumeRetention, debit * 0.1);

    // Surface de séparation (m²)
    final surfaceSeparation = volumeSeparateur * 2;

    return {
      'volumeRetention': volumeRetention.toStringAsFixed(2),
      'volumeSeparateur': volumeSeparateur.toStringAsFixed(2),
      'surfaceSeparation': surfaceSeparation.toStringAsFixed(2),
    };
  }

  // Calcul du dimensionnement de l'évacuation
  static Map<String, dynamic> calculerDimensionnement({
    required double puissanceChaudiere,
    required String typeEvacuation,
  }) {
    // Coefficient selon le type d'évacuation
    final coefficient = coefficientsEvacuation[typeEvacuation] ?? 1.0;

    // Calcul du diamètre minimal (en mm)
    final diametre = sqrt(puissanceChaudiere / 1000) * coefficient * 100;

    // Calcul de la hauteur minimale selon le type
    double hauteurMinimale;
    switch (typeEvacuation) {
      case 'ventouse':
        hauteurMinimale = 0.5; // 50 cm
        break;
      case 'cheminée':
        hauteurMinimale = 4.0; // 4 m
        break;
      case 'conduit':
        hauteurMinimale = 2.0; // 2 m
        break;
      default:
        hauteurMinimale = 1.0;
    }

    return {
      'puissanceChaudiere': puissanceChaudiere.toStringAsFixed(2),
      'diametre': diametre.toStringAsFixed(0),
      'hauteurMinimale': hauteurMinimale.toStringAsFixed(1),
      'typeEvacuation': typeEvacuation,
      'coefficient': coefficient.toStringAsFixed(2),
    };
  }

  // Calcul des pertes de charge
  static Map<String, dynamic> calculerPertesCharge({
    required double diametre,
    required double hauteur,
    required int nombreCoudes,
  }) {
    // Pertes linéaires (Pa/m)
    final pertesLineaires = 0.02 * pow(diametre / 1000, -4.87);

    // Pertes singulières (équivalent longueur droite)
    final pertesSingulieres = nombreCoudes * 0.5; // 0.5m équivalent par coude

    // Pertes totales (Pa)
    final pertesTotales = pertesLineaires * (hauteur + pertesSingulieres);

    return {
      'pertesLineaires': pertesLineaires.toStringAsFixed(2),
      'pertesSingulieres': pertesSingulieres.toStringAsFixed(2),
      'pertesTotales': pertesTotales.toStringAsFixed(2),
      'diametre': diametre.toStringAsFixed(0),
      'hauteur': hauteur.toStringAsFixed(1),
      'nombreCoudes': nombreCoudes,
    };
  }
}
