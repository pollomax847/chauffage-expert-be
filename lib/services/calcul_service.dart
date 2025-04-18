import 'dart:math';
import '../models/appareil.dart';

class CalculService {
  // Vitesse maximale en m/s
  static const double vitesseMax = 1.5;

  // Calcul du coefficient de simultanéité selon DTU 60.11
  static double calculerCoefficientSimultaneite(int nombreAppareils) {
    if (nombreAppareils <= 0) return 0;
    if (nombreAppareils == 1) return 1;
    return 1 / sqrt(nombreAppareils - 1);
  }

  // Calcul du débit en L/s
  static double calculerDebit(List<Appareil> appareils) {
    final sommeDU = appareils.fold<double>(
      0,
      (sum, appareil) => sum + (appareil.uniteDebit * appareil.quantite),
    );
    final y = calculerCoefficientSimultaneite(
      appareils.fold<int>(0, (sum, appareil) => sum + appareil.quantite),
    );
    return 0.2 * sqrt(sommeDU) * y;
  }

  // Calcul du diamètre intérieur en mm
  static double calculerDiametreInterieur(double debit) {
    // Q = v * S avec S = π * r²
    // donc r = √(Q / (v * π))
    final section = (debit / 1000) / vitesseMax; // conversion en m³/s
    final rayon = sqrt(section / pi);
    return rayon * 2 * 1000; // conversion en mm
  }

  // Tableau des diamètres standards
  static final Map<double, String> diametresStandards = {
    10.0: '10/12',
    12.0: '12/14',
    14.0: '14/16',
    16.0: '16/18',
    18.0: '18/20',
    20.0: '20/22',
    22.0: '22/24',
    24.0: '24/26',
    26.0: '26/28',
    28.0: '28/30',
    30.0: '30/32',
    32.0: '32/34',
    34.0: '34/36',
    36.0: '36/38',
    38.0: '38/40',
    40.0: '40/42',
  };

  // Trouver le diamètre nominal correspondant
  static String trouverDiametreNominal(double diametreInterieur) {
    for (final entry in diametresStandards.entries) {
      if (diametreInterieur <= entry.key) {
        return entry.value;
      }
    }
    return 'Supérieur à ${diametresStandards.values.last}';
  }
}
