import 'dart:math';
import 'be_chauffage.dart';
import 'be_ecs.dart';
import 'be_euev.dart';
import 'be_vmc.dart';

class BE3CEP {
  // Calcul complet pour une installation 3CEP
  static Map<String, dynamic> calculerInstallation({
    // Paramètres généraux
    required String typeBatiment,
    required int nombrePersonnes,
    required String zoneClimatique,
    required double temperatureInterieure,

    // Paramètres chauffage
    required Map<String, double> surfaces,
    required double coefficientSecurite,

    // Paramètres ECS
    required double coefficientSimultaneiteECS,
    required double tempsRechauffement,

    // Paramètres EUEV
    required Map<String, int> appareilsSanitaires,
    required double penteEUEV,

    // Paramètres VMC
    required Map<String, int> locaux,
  }) {
    // 1. Calculs chauffage
    final temperatureExterieure =
        BEChauffage.temperaturesBase[zoneClimatique] ?? 0.0;
    final deperditions = BEChauffage.calculerDeperditions(
      surfaces: surfaces,
      zoneClimatique: zoneClimatique,
      temperatureInterieure: temperatureInterieure,
      temperatureExterieure: temperatureExterieure,
    );

    final puissanceChauffage = BEChauffage.calculerPuissance(
      deperditions: double.parse(deperditions['deperditionsTotales']),
      coefficientSecurite: coefficientSecurite,
    );

    // 2. Calculs ECS
    final volumeECS = BEECS.calculerVolumeStockage(
      typeEtablissement: typeBatiment,
      nombrePersonnes: nombrePersonnes,
      coefficientSimultaneite: coefficientSimultaneiteECS,
    );

    final puissanceECS = BEECS.calculerPuissance(
      volumeStockage: double.parse(volumeECS['volumeStockage']),
      tempsRechauffement: tempsRechauffement,
    );

    // 3. Calculs EUEV
    final debitEUEV = BEEUEV.calculerDebitProbable(
      appareils: appareilsSanitaires,
    );

    final diametreEUEV = BEEUEV.calculerDiametre(
      debit: double.parse(debitEUEV['debitTotal']),
      pente: penteEUEV,
    );

    // 4. Calculs VMC
    final debitVMC = BEVMC.calculerDebitTotal(
      locaux: locaux,
    );

    // 5. Synthèse des résultats
    return {
      'chauffage': {
        'deperditions': deperditions,
        'puissance': puissanceChauffage,
        'temperatureExterieure': temperatureExterieure,
      },
      'ecs': {
        'volume': volumeECS,
        'puissance': puissanceECS,
      },
      'euev': {
        'debit': debitEUEV,
        'diametre': diametreEUEV,
      },
      'vmc': {
        'debit': debitVMC,
      },
      'recommandations': _genererRecommandations(
        puissanceChauffage: double.parse(puissanceChauffage['puissance']),
        puissanceECS: double.parse(puissanceECS['puissance']),
        debitEUEV: double.parse(debitEUEV['debitTotal']),
        debitVMC: double.parse(debitVMC['debitTotal']),
      ),
    };
  }

  // Génération des recommandations
  static Map<String, dynamic> _genererRecommandations({
    required double puissanceChauffage,
    required double puissanceECS,
    required double debitEUEV,
    required double debitVMC,
  }) {
    List<String> recommandations = [];

    // Recommandations chauffage
    if (puissanceChauffage > 100) {
      recommandations.add('Envisager une chaudière à condensation');
    } else if (puissanceChauffage > 30) {
      recommandations.add('Envisager une pompe à chaleur');
    } else {
      recommandations.add('Envisager un chauffage électrique');
    }

    // Recommandations ECS
    if (puissanceECS > 50) {
      recommandations.add('Prévoir un ballon de stockage ECS');
    }

    // Recommandations EUEV
    if (debitEUEV > 2.0) {
      recommandations.add('Prévoir une ventilation primaire');
    }

    // Recommandations VMC
    if (debitVMC > 300) {
      recommandations.add('Envisager une VMC double flux');
    }

    return {
      'liste': recommandations,
      'nombre': recommandations.length,
    };
  }

  // Calcul des économies d'énergie
  static Map<String, dynamic> calculerEconomies({
    required double puissanceChauffage,
    required double puissanceECS,
    required double debitVMC,
    required int dureeUtilisation, // heures/an
  }) {
    // Consommation annuelle (kWh)
    final consommationChauffage = puissanceChauffage * dureeUtilisation;
    final consommationECS = puissanceECS * dureeUtilisation;
    final consommationVMC =
        (debitVMC * 1.2 * 100) / 1000 * dureeUtilisation; // 1.2 kg/m³, 100 Pa

    // Économies potentielles (%)
    const economieChauffage = 0.15; // 15% avec une PAC
    const economieECS = 0.20; // 20% avec un ballon thermodynamique
    const economieVMC = 0.30; // 30% avec une VMC double flux

    return {
      'consommation': {
        'chauffage': consommationChauffage.toStringAsFixed(2),
        'ecs': consommationECS.toStringAsFixed(2),
        'vmc': consommationVMC.toStringAsFixed(2),
        'totale': (consommationChauffage + consommationECS + consommationVMC)
            .toStringAsFixed(2),
      },
      'economies': {
        'chauffage':
            (consommationChauffage * economieChauffage).toStringAsFixed(2),
        'ecs': (consommationECS * economieECS).toStringAsFixed(2),
        'vmc': (consommationVMC * economieVMC).toStringAsFixed(2),
        'totale': (consommationChauffage * economieChauffage +
                consommationECS * economieECS +
                consommationVMC * economieVMC)
            .toStringAsFixed(2),
      },
    };
  }

  // Dimensionnement des conduits de chaudière
  static Map<String, dynamic> dimensionnerConduits({
    required double puissanceNominale, // kW
    required double hauteurConduit, // m
    required String typeCombustible, // 'gaz', 'fioul', 'bois'
    required double temperatureFumee, // °C
    required double temperatureExterieure, // °C
  }) {
    // Débit de fumées selon le combustible (m³/h par kW)
    final Map<String, double> debitsFumees = {
      'gaz': 0.8,
      'fioul': 0.9,
      'bois': 1.2,
    };

    // Calcul du débit de fumées
    final debitFumees =
        puissanceNominale * (debitsFumees[typeCombustible] ?? 0.8);

    // Calcul de la section minimale (m²)
    const vitesseFumee = 2.0; // m/s (vitesse recommandée)
    final sectionMinimale = (debitFumees / 3600) / vitesseFumee;

    // Calcul du diamètre minimal (mm)
    final diametreMinimal = sqrt((4 * sectionMinimale) / pi) * 1000;

    // Diamètres standards disponibles
    final diametresStandards = [80, 100, 125, 150, 200, 250, 300];
    int diametreConduit = diametresStandards.firstWhere(
      (d) => d >= diametreMinimal,
      orElse: () => diametresStandards.last,
    );

    // Calcul de la dépression naturelle (Pa)
    const densiteAir = 1.293; // kg/m³
    final densiteFumee = 1.293 * (273 / (273 + temperatureFumee));
    final depressionNaturelle =
        hauteurConduit * 9.81 * (densiteAir - densiteFumee);

    // Vérification de la dépression
    const depressionMinimale = 10.0; // Pa
    final depressionOK = depressionNaturelle >= depressionMinimale;

    // Recommandations
    List<String> recommandations = [];
    if (!depressionOK) {
      recommandations.add('Prévoir un ventilateur de tirage');
    }
    if (temperatureFumee < 120) {
      recommandations
          .add('Risque de condensation - prévoir un conduit étanche');
    }
    if (hauteurConduit < 4) {
      recommandations
          .add('Hauteur de conduit insuffisante - minimum 4m recommandé');
    }

    return {
      'debitFumees': debitFumees.toStringAsFixed(2),
      'sectionMinimale': sectionMinimale.toStringAsFixed(4),
      'diametreConduit': diametreConduit.toString(),
      'depressionNaturelle': depressionNaturelle.toStringAsFixed(2),
      'depressionOK': depressionOK,
      'recommandations': recommandations,
    };
  }

  // Dimensionnement des conduits collectifs
  static Map<String, dynamic> dimensionnerConduitCollectif({
    required List<double> puissances, // kW de chaque chaudière
    required List<String> typesCombustible,
    required double hauteurConduit,
    required double longueurConduit,
    required int nombreCoudes,
  }) {
    // Calcul du débit total de fumées
    double debitTotal = 0;
    for (int i = 0; i < puissances.length; i++) {
      final debitFumees = puissances[i] * _getDebitFumees(typesCombustible[i]);
      debitTotal += debitFumees;
    }

    // Section minimale avec coefficient de simultanéité
    final coefficientSimultaneite =
        _calculerCoefficientSimultaneite(puissances.length);
    final sectionMinimale = (debitTotal * coefficientSimultaneite / 3600) / 2.0;

    // Diamètre minimal et standard
    final diametreMinimal = sqrt((4 * sectionMinimale) / pi) * 1000;
    final diametresStandards = [150, 200, 250, 300, 350, 400, 500];
    int diametreConduit = diametresStandards.firstWhere(
      (d) => d >= diametreMinimal,
      orElse: () => diametresStandards.last,
    );

    // Calcul des pertes de charge
    final pertesCharge = _calculerPertesChargeConduit(
      debit: debitTotal * coefficientSimultaneite,
      diametre: diametreConduit.toDouble(),
      longueur: longueurConduit,
      nombreCoudes: nombreCoudes,
    );

    return {
      'debitTotal': debitTotal.toStringAsFixed(2),
      'coefficientSimultaneite': coefficientSimultaneite.toStringAsFixed(2),
      'sectionMinimale': sectionMinimale.toStringAsFixed(4),
      'diametreConduit': diametreConduit.toString(),
      'pertesCharge': pertesCharge,
    };
  }

  // Calcul des pertes de charge dans le conduit
  static Map<String, dynamic> _calculerPertesChargeConduit({
    required double debit,
    required double diametre,
    required double longueur,
    required int nombreCoudes,
  }) {
    // Vitesse d'écoulement (m/s)
    final section = pi * pow(diametre / 2000, 2);
    final vitesse = (debit / 3600) / section;

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

  // Coefficient de simultanéité selon le nombre d'appareils
  static double _calculerCoefficientSimultaneite(int nombreAppareils) {
    if (nombreAppareils <= 2) return 1.0;
    if (nombreAppareils <= 4) return 0.9;
    if (nombreAppareils <= 6) return 0.8;
    if (nombreAppareils <= 10) return 0.7;
    return 0.6;
  }

  // Débit de fumées selon le type de combustible
  static double _getDebitFumees(String typeCombustible) {
    final Map<String, double> debitsFumees = {
      'gaz': 0.8,
      'fioul': 0.9,
      'bois': 1.2,
      'charbon': 1.5,
      'granules': 1.1,
    };
    return debitsFumees[typeCombustible] ?? 0.8;
  }

  // Vérification de la hauteur minimale du conduit
  static Map<String, dynamic> verifierHauteurConduit({
    required double hauteurConduit,
    required double hauteurBatiment,
    required double distanceObstacle,
  }) {
    final hauteurMinimale = max(4.0, hauteurBatiment * 0.1);
    final hauteurOK = hauteurConduit >= hauteurMinimale;

    const distanceMinimale = 3.0;
    final distanceOK = distanceObstacle >= distanceMinimale;

    List<String> recommandations = [];
    if (!hauteurOK) {
      recommandations.add('Hauteur minimale recommandée : ${hauteurMinimale}m');
    }
    if (!distanceOK) {
      recommandations
          .add('Distance minimale aux obstacles : ${distanceMinimale}m');
    }

    return {
      'hauteurMinimale': hauteurMinimale.toStringAsFixed(1),
      'hauteurOK': hauteurOK,
      'distanceOK': distanceOK,
      'recommandations': recommandations,
    };
  }
}
