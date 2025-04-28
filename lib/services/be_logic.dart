
class BELogic {
  // Eau Chaude Sanitaire
  static Map<String, dynamic> calculateECS({
    required int nombreLogements,
    required int nombrePoints,
    required double temperature,
  }) {
    final debit = nombreLogements * nombrePoints * 0.15; // L/s
    String diametre = '12';
    
    if (debit > 0.5) diametre = '16';
    if (debit > 1.0) diametre = '20';
    
    return {
      'debit': debit.toStringAsFixed(2),
      'diametre': diametre,
      'temperature': temperature,
    };
  }

  // Chauffage Collectif
  static Map<String, dynamic> calculateChauffage({
    required double surface,
    required int nombreLogements,
  }) {
    final puissance = surface * nombreLogements * 80; // W
    String typeGenerateur = 'Chaudière';
    
    if (puissance < 100000) {
      typeGenerateur = 'PAC';
    } else if (puissance > 500000) {
      typeGenerateur = 'Chaufferie';
    }
    
    return {
      'puissance': puissance.toStringAsFixed(0),
      'typeGenerateur': typeGenerateur,
    };
  }

  // VMC et 3CEP
  static Map<String, dynamic> calculateVMC({
    required int nombreLogements,
    required int nombreModules,
    required String typeVMC,
    required bool is3CEP,
    required bool isGazB,
  }) {
    final debit = nombreModules * nombreLogements * 30; // m³/h
    bool conforme = true;
    String alerte = '';
    
    if (is3CEP && isGazB) {
      conforme = false;
      alerte = '⚠️ Risque de tirage et CO';
    }
    
    return {
      'debit': debit.toStringAsFixed(0),
      'conforme': conforme,
      'alerte': alerte,
    };
  }

  // Eaux Usées et Vannes
  static Map<String, dynamic> calculateEU({
    required int nombreEquipements,
    required double pente,
    required double diametre,
  }) {
    final debitMax = nombreEquipements * 0.5; // L/s
    bool conforme = pente >= 1.5 && diametre >= 100;
    
    return {
      'debitMax': debitMax.toStringAsFixed(2),
      'conforme': conforme,
      'penteMin': 1.5,
    };
  }

  // Eaux Pluviales
  static Map<String, dynamic> calculateEP({
    required double surfaceToit,
    required double pluieProjet,
    required double diametre,
  }) {
    final debit = surfaceToit * pluieProjet / 3600; // m³/h
    final nombreDescentes = (debit / 6).ceil();
    bool conforme = diametre >= 80;
    
    return {
      'debit': debit.toStringAsFixed(2),
      'nombreDescentes': nombreDescentes,
      'conforme': conforme,
    };
  }

  // Bouclage ECS
  static Map<String, dynamic> calculateBouclage({
    required double longueur,
    required double perteLineaire,
  }) {
    final deltaP = perteLineaire * longueur;
    final debitRetour = deltaP / 100;
    String typePompe = 'Vanne';
    
    if (deltaP > 200) {
      typePompe = 'Pompe de circulation';
    }
    
    return {
      'deltaP': deltaP.toStringAsFixed(0),
      'debitRetour': debitRetour.toStringAsFixed(2),
      'typePompe': typePompe,
    };
  }

  // Pertes de Charge
  static Map<String, dynamic> calculatePertes({
    required double debit,
    required double diametre,
    required double longueur,
    required int nombreAccessoires,
  }) {
    final vitesse = (4 * debit) / (3.14 * diametre * diametre);
    final perteAccessoires = nombreAccessoires * 30;
    final deltaP = (longueur * 100) + perteAccessoires;
    bool alerte = vitesse > 2;
    
    return {
      'vitesse': vitesse.toStringAsFixed(2),
      'deltaP': deltaP.toStringAsFixed(0),
      'alerte': alerte,
    };
  }
} 