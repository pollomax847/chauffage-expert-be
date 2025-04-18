import 'dart:math';

class BEAlimentation {
  // Débits unitaires selon le type d'appareil (L/s)
  static const Map<String, double> debitsUnitaires = {
    'lavabo': 0.2,
    'evier': 0.3,
    'douche': 0.2,
    'baignoire': 0.3,
    'wc': 0.1,
    'lave_linge': 0.2,
    'lave_vaisselle': 0.2,
    'bidet': 0.1,
  };

  // Coefficients de puissance électrique selon le type de système
  static const Map<String, double> coefficientsPuissance = {
    'chaudiere_gaz': 0.1,
    'chaudiere_fioul': 0.15,
    'pompe_chaleur': 0.3,
    'geothermie': 0.25,
    'solaire': 0.05,
  };

  // Calcul du réseau d'alimentation
  static Map<String, dynamic> dimensionnerReseau({
    required Map<String, int> appareils,
    required double longueur,
    required double pressionEntree,
    required double pressionMinimale,
    required int nombreLogements,
    required int nombreEtages,
    required double hauteurEtage,
  }) {
    double debitTotal = 0;
    Map<String, double> debitsParAppareil = {};

    // Calcul des débits
    for (var entry in appareils.entries) {
      final debitAppareil = debitsUnitaires[entry.key] ?? 0.0;
      final debit = debitAppareil * entry.value * nombreLogements;
      debitsParAppareil[entry.key] = debit;
      debitTotal += debit;
    }

    // Calcul du diamètre théorique (mm)
    final diametreTheorique = sqrt(debitTotal * 4 / (pi * 1.5)) * 1000;

    // Calcul des pertes de charge (bar)
    final pertesCharge = (longueur * 0.1) / 100; // 0.1 bar/100m

    // Hauteur totale (m)
    final hauteurTotale = nombreEtages * hauteurEtage;

    // Pression minimale requise (bar)
    final pressionMinimaleRequise = (hauteurTotale * 0.1) + 1.0;

    // Pression disponible (bar)
    final pressionDisponible =
        pressionEntree - pressionMinimaleRequise - pertesCharge;

    // Vitesse d'écoulement (m/s)
    final section = pi * pow(diametreTheorique / 2000, 2);
    final vitesse = debitTotal / section;

    return {
      'debitTotal': debitTotal.toStringAsFixed(2),
      'diametreTheorique': diametreTheorique.toStringAsFixed(0),
      'pertesCharge': pertesCharge.toStringAsFixed(2),
      'pressionMinimaleRequise': pressionMinimaleRequise.toStringAsFixed(2),
      'pressionDisponible': pressionDisponible.toStringAsFixed(2),
      'vitesse': vitesse.toStringAsFixed(2),
      'debitsParAppareil': debitsParAppareil,
      'hauteurTotale': hauteurTotale.toStringAsFixed(1),
    };
  }

  // Calcul des surpresseurs
  static Map<String, dynamic> dimensionnerSurpresseur({
    required double debit,
    required double hauteurManometrique,
    required double pressionMinimale,
    required int nombreLogements,
    required int nombreEtages,
    required double hauteurEtage,
  }) {
    // Hauteur totale (m)
    final hauteurTotale = nombreEtages * hauteurEtage;

    // Pression minimale requise (bar)
    final pressionMinimaleRequise = (hauteurTotale * 0.1) + 1.0;

    // Puissance hydraulique (kW)
    final puissanceHydraulique = (debit * hauteurManometrique * 9.81) / 3600;

    // Puissance absorbée (kW) avec rendement de 70%
    final puissanceAbsorbee = puissanceHydraulique / 0.7;

    // Volume du ballon (L)
    final volumeBallon = max(50.0, debit * 60 * 2 * nombreLogements);

    // Consommation annuelle (kWh)
    final consommationAnnuelle = (puissanceAbsorbee * 24 * 365) / 1000;

    return {
      'puissanceHydraulique': puissanceHydraulique.toStringAsFixed(2),
      'puissanceAbsorbee': puissanceAbsorbee.toStringAsFixed(2),
      'volumeBallon': volumeBallon.toStringAsFixed(0),
      'consommationAnnuelle': consommationAnnuelle.toStringAsFixed(1),
      'pressionMinimaleRequise': pressionMinimaleRequise.toStringAsFixed(2),
      'hauteurTotale': hauteurTotale.toStringAsFixed(1),
    };
  }

  // Calcul des retours de boucle
  static Map<String, dynamic> dimensionnerRetourBoucle({
    required double debit,
    required double longueurBoucle,
    required double temperatureDepart,
    required double temperatureRetour,
    required int nombreLogements,
    required int nombreEtages,
    required double hauteurEtage,
  }) {
    // Hauteur totale (m)
    final hauteurTotale = nombreEtages * hauteurEtage;

    // Pertes de charge (bar)
    final pertesCharge = (longueurBoucle * 0.1) / 100; // 0.1 bar/100m

    // Puissance hydraulique (kW)
    final puissanceHydraulique = (debit * hauteurTotale * 9.81) / 3600;

    // Puissance absorbée (kW) avec rendement de 70%
    final puissanceAbsorbee = puissanceHydraulique / 0.7;

    // Débit de circulation (m³/h)
    final debitCirculation = debit * 0.1 * nombreLogements;

    // Diamètre de la boucle (mm)
    final diametreBoucle = sqrt(debitCirculation * 4 / (pi * 1.5)) * 1000;

    // Vitesse d'écoulement (m/s)
    final section = pi * pow(diametreBoucle / 2000, 2);
    final vitesse = debitCirculation / section;

    return {
      'pertesCharge': pertesCharge.toStringAsFixed(2),
      'puissanceHydraulique': puissanceHydraulique.toStringAsFixed(2),
      'puissanceAbsorbee': puissanceAbsorbee.toStringAsFixed(2),
      'debitCirculation': debitCirculation.toStringAsFixed(2),
      'diametreBoucle': diametreBoucle.toStringAsFixed(0),
      'vitesse': vitesse.toStringAsFixed(2),
      'hauteurTotale': hauteurTotale.toStringAsFixed(1),
    };
  }

  // Calcul des colonnes montantes
  static Map<String, dynamic> dimensionnerColonneMontante({
    required Map<String, int> appareils,
    required int nombreLogements,
    required int nombreEtages,
    required double hauteurEtage,
  }) {
    double debitTotal = 0;
    Map<String, double> debitsParAppareil = {};

    // Calcul des débits
    for (var entry in appareils.entries) {
      final debitAppareil = debitsUnitaires[entry.key] ?? 0.0;
      final debit = debitAppareil * entry.value * nombreLogements;
      debitsParAppareil[entry.key] = debit;
      debitTotal += debit;
    }

    // Calcul du diamètre théorique (mm)
    final diametreTheorique = sqrt(debitTotal * 4 / (pi * 1.5)) * 1000;

    // Hauteur totale (m)
    final hauteurTotale = nombreEtages * hauteurEtage;

    // Pression minimale requise (bar)
    final pressionMinimaleRequise = (hauteurTotale * 0.1) + 1.0;

    // Vitesse d'écoulement (m/s)
    final section = pi * pow(diametreTheorique / 2000, 2);
    final vitesse = debitTotal / section;

    return {
      'debitTotal': debitTotal.toStringAsFixed(2),
      'diametreTheorique': diametreTheorique.toStringAsFixed(0),
      'pressionMinimaleRequise': pressionMinimaleRequise.toStringAsFixed(2),
      'vitesse': vitesse.toStringAsFixed(2),
      'debitsParAppareil': debitsParAppareil,
      'hauteurTotale': hauteurTotale.toStringAsFixed(1),
    };
  }

  // Calcul de la puissance électrique nécessaire
  static Map<String, dynamic> calculerPuissanceElectrique({
    required double puissanceThermique,
    required String typeSysteme,
  }) {
    // Coefficient selon le type de système
    final coefficient = coefficientsPuissance[typeSysteme] ?? 0.1;

    // Calcul de la puissance électrique
    final puissanceElectrique = puissanceThermique * coefficient;

    // Calcul de l'intensité (en A) pour du 230V monophasé
    final intensite = puissanceElectrique / 230;

    return {
      'puissanceThermique': puissanceThermique.toStringAsFixed(2),
      'puissanceElectrique': puissanceElectrique.toStringAsFixed(2),
      'intensite': intensite.toStringAsFixed(2),
      'typeSysteme': typeSysteme,
      'coefficient': coefficient.toStringAsFixed(2),
    };
  }

  // Calcul de la section des câbles
  static Map<String, dynamic> calculerSectionCable({
    required double intensite,
    required double longueur,
    required String typeInstallation,
  }) {
    // Coefficients de chute de tension selon le type d'installation
    final coefficientsChute = {
      'encastree': 0.8,
      'apparente': 1.0,
      'souterraine': 0.7,
    };

    final coefficient = coefficientsChute[typeInstallation] ?? 1.0;

    // Calcul simplifié de la section (en mm²)
    final section = (intensite * longueur * coefficient) / 1000;

    return {
      'section': section.toStringAsFixed(2),
      'intensite': intensite.toStringAsFixed(2),
      'longueur': longueur.toStringAsFixed(2),
      'typeInstallation': typeInstallation,
    };
  }
}
