// BE3CEP - Service pour les calculs de Chauffage, ECS, EUEV et VMC
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'be_security_service.dart';
import 'be_pdf_service.dart';

/// Service regroupant les méthodes de calculs pour le module 3CEP
/// (Chauffage, ECS, EUEV, VMC)
class BE3CEP {
  // Coefficients pour les calculs de déperdition thermique
  static const Map<String, double> _coefficientsMurs = {
    'H1': 0.5,
    'H2': 0.45,
    'H3': 0.4,
  };

  static const Map<String, double> _coefficientsPlafond = {
    'H1': 0.3,
    'H2': 0.25,
    'H3': 0.2,
  };

  static const Map<String, double> _coefficientsPlancher = {
    'H1': 0.35,
    'H2': 0.3,
    'H3': 0.25,
  };

  static const Map<String, double> _coefficientsFenetres = {
    'H1': 2.3,
    'H2': 2.0,
    'H3': 1.8,
  };

  static const Map<String, double> _coefficientsPortes = {
    'H1': 1.5,
    'H2': 1.3,
    'H3': 1.1,
  };

  // Débits de référence pour les appareils sanitaires (L/s)
  static const Map<String, double> _debitsAppareils = {
    'lavabo': 0.1,
    'evier': 0.2,
    'bain': 0.3,
    'douche': 0.2,
    'wc': 0.1,
  };

  // Débits VMC selon type de local (m³/h)
  static const Map<String, double> _debitsVMC = {
    'sejour': 18.0,
    'chambre': 18.0,
    'cuisine': 45.0,
    'salle_de_bain': 30.0,
    'wc': 15.0,
  };

  /// Méthode principale de calcul pour l'installation complète
  ///
  /// Effectue les calculs pour les 4 modules: chauffage, ECS, EUEV et VMC
  /// Retourne un map contenant les résultats ou une erreur
  static Map<String, dynamic> calculerInstallation({
    required String typeBatiment,
    required int nombrePersonnes,
    required String zoneClimatique,
    required double temperatureInterieure,
    required Map<String, double> surfaces,
    required double coefficientSecurite,
    required double coefficientSimultaneiteECS,
    required double tempsRechauffement,
    required Map<String, int> appareilsSanitaires,
    required double penteEUEV,
    required Map<String, int> locaux,
  }) {
    try {
      // Validation des entrées
      if (!_validerZoneClimatique(zoneClimatique)) {
        return {
          'erreur': 'Zone climatique invalide. Valeurs acceptées: H1, H2, H3'
        };
      }

      if (temperatureInterieure < 10 || temperatureInterieure > 30) {
        return {
          'erreur': 'Température intérieure doit être entre 10°C et 30°C'
        };
      }

      if (coefficientSecurite < 1.0 || coefficientSecurite > 1.5) {
        return {
          'erreur': 'Le coefficient de sécurité doit être entre 1.0 et 1.5'
        };
      }

      // Journalisation de l'opération
      if (kDebugMode) {
        debugPrint('Calcul 3CEP démarré pour: $typeBatiment');
      }

      // 1. Calcul des déperditions et besoins de chauffage
      final chauffage = _calculerChauffage(
        zoneClimatique: zoneClimatique,
        temperatureInterieure: temperatureInterieure,
        surfaces: surfaces,
        coefficientSecurite: coefficientSecurite,
      );

      // 2. Calcul des besoins en eau chaude sanitaire
      final ecs = _calculerECS(
        nombrePersonnes: nombrePersonnes,
        appareilsSanitaires: appareilsSanitaires,
        coefficientSimultaneite: coefficientSimultaneiteECS,
        tempsRechauffement: tempsRechauffement,
      );

      // 3. Calcul des évacuations d'eau usées et vannes
      final euev = _calculerEUEV(
        appareilsSanitaires: appareilsSanitaires,
        pente: penteEUEV,
      );

      // 4. Calcul de la ventilation
      final vmc = _calculerVMC(locaux);

      // 5. Génération des recommandations
      final recommandations = _genererRecommandations(
        typeBatiment: typeBatiment,
        chauffage: chauffage,
        ecs: ecs,
        euev: euev,
        vmc: vmc,
      );

      // Journalisation du résultat
      try {
        BESecurityService.logSecurityEvent(
            'calcul', 'Calcul 3CEP effectué avec succès pour: $typeBatiment');
      } catch (e) {
        // Ne pas bloquer l'exécution si la journalisation échoue
        if (kDebugMode) {
          debugPrint('Erreur de journalisation: $e');
        }
      }

      return {
        'chauffage': chauffage,
        'ecs': ecs,
        'euev': euev,
        'vmc': vmc,
        'recommandations': recommandations,
      };
    } catch (e) {
      // Journalisation de l'erreur
      try {
        BESecurityService.logSecurityEvent(
            'erreur', 'Erreur dans le calcul 3CEP: $e');
      } catch (_) {/* Ignorer l'erreur de journalisation */}

      return {
        'erreur': 'Erreur lors du calcul: $e',
      };
    }
  }

  /// Validation de la zone climatique
  ///
  /// Vérifie si la zone climatique fait partie des valeurs acceptées (H1, H2, H3)
  static bool _validerZoneClimatique(String zone) {
    return ['H1', 'H2', 'H3'].contains(zone);
  }

  // Calcul des déperditions et besoins de chauffage
  static Map<String, dynamic> _calculerChauffage({
    required String zoneClimatique,
    required double temperatureInterieure,
    required Map<String, double> surfaces,
    required double coefficientSecurite,
  }) {
    // Température extérieure de base selon la zone climatique
    final temperaturesExtBase = {
      'H1': -7.0,
      'H2': -5.0,
      'H3': -2.0,
    };

    final tempExt = temperaturesExtBase[zoneClimatique] ?? -7.0;
    final deltaT = temperatureInterieure - tempExt;

    // Calcul des déperditions par type de surface
    double deperditionsMurs =
        surfaces['murs']! * _coefficientsMurs[zoneClimatique]! * deltaT;
    double deperditionsPlafond =
        surfaces['plafond']! * _coefficientsPlafond[zoneClimatique]! * deltaT;
    double deperditionsPlancher =
        surfaces['plancher']! * _coefficientsPlancher[zoneClimatique]! * deltaT;
    double deperditionsFenetres =
        surfaces['fenetres']! * _coefficientsFenetres[zoneClimatique]! * deltaT;
    double deperditionsPortes =
        surfaces['portes']! * _coefficientsPortes[zoneClimatique]! * deltaT;

    // Total des déperditions
    double deperditionsTotal = deperditionsMurs +
        deperditionsPlafond +
        deperditionsPlancher +
        deperditionsFenetres +
        deperditionsPortes;

    // Application du coefficient de sécurité
    double puissanceCalculee = deperditionsTotal * coefficientSecurite;

    return {
      'deperditions_murs': '${deperditionsMurs.toStringAsFixed(2)} W',
      'deperditions_plafond': '${deperditionsPlafond.toStringAsFixed(2)} W',
      'deperditions_plancher': '${deperditionsPlancher.toStringAsFixed(2)} W',
      'deperditions_fenetres': '${deperditionsFenetres.toStringAsFixed(2)} W',
      'deperditions_portes': '${deperditionsPortes.toStringAsFixed(2)} W',
      'deperditions_totales': '${deperditionsTotal.toStringAsFixed(2)} W',
      'puissance_calculee': '${puissanceCalculee.toStringAsFixed(2)} W',
    };
  }

  // Calcul des besoins en eau chaude sanitaire
  static Map<String, dynamic> _calculerECS({
    required int nombrePersonnes,
    required Map<String, int> appareilsSanitaires,
    required double coefficientSimultaneite,
    required double tempsRechauffement,
  }) {
    // Volume d'ECS par personne
    const double volumeParPersonne = 40.0; // litres

    // Calcul du volume total
    double volumeTotal = nombrePersonnes * volumeParPersonne;

    // Température ECS et eau froide
    const double tempECS = 60.0; // °C
    const double tempEF = 10.0; // °C
    const double rhoEau = 1.0; // kg/L
    const double cpEau = 4.18; // kJ/kg/K

    // Énergie nécessaire pour chauffer l'eau (kWh)
    double energie = volumeTotal * rhoEau * cpEau * (tempECS - tempEF) / 3600;

    // Puissance en fonction du temps de réchauffement (kW)
    double puissance = energie / tempsRechauffement;

    // Calcul du débit de pointe
    double debitPointe = 0;
    appareilsSanitaires.forEach((appareil, nombre) {
      if (_debitsAppareils.containsKey(appareil)) {
        debitPointe += _debitsAppareils[appareil]! * nombre;
      }
    });

    // Application du coefficient de simultanéité
    debitPointe *= coefficientSimultaneite;

    return {
      'volume_ecs': '${volumeTotal.toStringAsFixed(2)} L',
      'energie_jour': '${energie.toStringAsFixed(2)} kWh',
      'puissance': '${puissance.toStringAsFixed(2)} kW',
      'debit_pointe': '${(debitPointe * 3600).toStringAsFixed(2)} L/h',
    };
  }

  // Calcul des évacuations d'eau usées et vannes
  static Map<String, dynamic> _calculerEUEV({
    required Map<String, int> appareilsSanitaires,
    required double pente,
  }) {
    // Unités de décharge par appareil
    final Map<String, double> unitesDecharge = {
      'lavabo': 1,
      'evier': 2,
      'bain': 3,
      'douche': 2,
      'wc': 4,
    };

    // Calcul du total d'unités de décharge
    double totalUD = 0;
    appareilsSanitaires.forEach((appareil, nombre) {
      if (unitesDecharge.containsKey(appareil)) {
        totalUD += unitesDecharge[appareil]! * nombre;
      }
    });

    // Calcul du diamètre d'évacuation en fonction des UD et de la pente
    int diametre = _calculerDiametreEvacuation(totalUD, pente);

    // Débit total d'évacuation
    double debitEvacuation = sqrt(totalUD) * 0.5; // L/s

    return {
      'unites_decharge': totalUD.toString(),
      'diametre_evacuation': '$diametre mm',
      'debit_evacuation': '${debitEvacuation.toStringAsFixed(2)} L/s',
      'pente': '$pente %',
    };
  }

  // Calcul du diamètre d'évacuation selon les unités de décharge et la pente
  static int _calculerDiametreEvacuation(double ud, double pente) {
    if (pente < 1) {
      // Pente faible
      if (ud <= 10) return 100;
      if (ud <= 30) return 125;
      if (ud <= 240) return 150;
      return 200;
    } else if (pente < 2) {
      // Pente moyenne
      if (ud <= 20) return 100;
      if (ud <= 180) return 125;
      if (ud <= 700) return 150;
      return 200;
    } else {
      // Pente forte
      if (ud <= 30) return 100;
      if (ud <= 240) return 125;
      if (ud <= 1400) return 150;
      return 200;
    }
  }

  // Calcul de la ventilation
  static Map<String, dynamic> _calculerVMC(Map<String, int> locaux) {
    // Calcul du débit total
    double debitTotal = 0;
    locaux.forEach((local, nombre) {
      if (_debitsVMC.containsKey(local)) {
        debitTotal += _debitsVMC[local]! * nombre;
      }
    });

    // Calcul du diamètre de conduit principal
    double section =
        debitTotal / (3600 * 3.5); // Section en m² (vitesse 3.5 m/s)
    double diametre = sqrt(4 * section / pi) * 1000; // Diamètre en mm
    int diametreNominal = ((diametre / 10).ceil() * 10)
        .toInt(); // Arrondi au multiple de 10 supérieur

    // Recommandation de caisson VMC
    String typeVMC = "Simple flux";
    if (debitTotal > 180) typeVMC = "Simple flux haut rendement";
    if (debitTotal > 300) typeVMC = "Double flux avec récupérateur";

    return {
      'debit_total': '$debitTotal m³/h',
      'diametre_conduit': '$diametreNominal mm',
      'type_vmc': typeVMC,
    };
  }

  // Génération des recommandations
  static Map<String, dynamic> _genererRecommandations({
    required String typeBatiment,
    required Map<String, dynamic> chauffage,
    required Map<String, dynamic> ecs,
    required Map<String, dynamic> euev,
    required Map<String, dynamic> vmc,
  }) {
    final List<String> recommandations = [];

    // Recommandations sur le chauffage
    double puissance = double.parse(
        chauffage['puissance_calculee'].toString().replaceAll(' W', ''));
    if (puissance > 10000) {
      recommandations.add(
          'Un système de chauffage centralisé est recommandé pour cette puissance.');
    } else {
      recommandations
          .add('Des radiateurs individuels peuvent suffire pour ce projet.');
    }

    // Recommandations sur l'ECS
    double puissanceECS =
        double.parse(ecs['puissance'].toString().replaceAll(' kW', ''));
    if (puissanceECS > 10) {
      recommandations
          .add('Un ballon de stockage de grande capacité est recommandé.');
    }

    // Recommandations sur l'EUEV
    double ud = double.parse(euev['unites_decharge']);
    if (ud > 30) {
      recommandations.add(
          'Prévoir un regard de visite pour l\'entretien des canalisations.');
    }

    // Recommandations sur la VMC
    String typeVMC = vmc['type_vmc'];
    if (typeVMC.contains('Double flux')) {
      recommandations.add(
          'L\'installation d\'une VMC double flux permettra des économies d\'énergie significatives.');
    }

    // Recommandation générale selon le type de bâtiment
    if (typeBatiment.toLowerCase().contains('collectif')) {
      recommandations.add(
          'Pour ce type de bâtiment collectif, un système centralisé avec production séparée pour le chauffage et l\'ECS est recommandé.');
    } else {
      recommandations.add(
          'Pour ce type de bâtiment individuel, une chaudière mixte pourrait être une solution économique.');
    }

    return {
      'liste': recommandations,
    };
  }

  /// Exporte les résultats vers un fichier PDF
  ///
  /// Utilise le service BEPdfService pour générer un rapport PDF des calculs
  /// Retourne le chemin vers le fichier PDF généré
  static Future<String> exporterResultatsVersPDF(
      Map<String, dynamic> resultats, String typeBatiment) async {
    try {
      // Générer le PDF avec les résultats
      final pdf = await BEPdfService.generateBEPDF(
        resultats: resultats,
        typeBE: '3CEP - $typeBatiment',
      );

      // Journaliser l'opération
      await BESecurityService.logSecurityEvent(
          'export', 'Export PDF des résultats 3CEP généré pour: $typeBatiment');

      return pdf.path;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Erreur lors de l\'export PDF: $e');
      }
      await BESecurityService.logSecurityEvent(
          'erreur', 'Échec de l\'export PDF 3CEP: $e');
      throw Exception('Échec de l\'export: $e');
    }
  }
}
