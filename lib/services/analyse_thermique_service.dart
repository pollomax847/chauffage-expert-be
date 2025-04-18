import '../models/radiateur.dart';

class AnalyseThermiqueService {
  // Vérifie si la puissance du radiateur est suffisante
  static bool verifierPuissance(Radiateur radiateur) {
    return radiateur.puissance >= radiateur.besoinThermique;
  }

  // Vérifie si le matériau de tuyauterie est adapté
  static bool verifierMateriauTuyauterie(String materiau) {
    final materiauxValides = ['PVC-P', 'Multicouche', 'Cuivre'];
    return materiauxValides.contains(materiau);
  }

  // Calcule la marge de puissance
  static double calculerMargePuissance(Radiateur radiateur) {
    return radiateur.puissance - radiateur.besoinThermique;
  }

  // Génère un rapport d'analyse pour un radiateur
  static Map<String, dynamic> genererRapportRadiateur(Radiateur radiateur) {
    final puissanceSuffisante = verifierPuissance(radiateur);
    final materiauAdapte = verifierMateriauTuyauterie(
      radiateur.materiauTuyauterie,
    );
    final margePuissance = calculerMargePuissance(radiateur);

    return {
      'reference': radiateur.reference,
      'identification': radiateur.identification,
      'modele': radiateur.modele,
      'dimensions': radiateur.dimensions,
      'puissance': radiateur.puissance,
      'besoinThermique': radiateur.besoinThermique,
      'margePuissance': margePuissance,
      'puissanceSuffisante': puissanceSuffisante,
      'materiauTuyauterie': radiateur.materiauTuyauterie,
      'materiauAdapte': materiauAdapte,
      'recommandations': _genererRecommandations(
        puissanceSuffisante,
        materiauAdapte,
        margePuissance,
      ),
    };
  }

  // Génère des recommandations basées sur l'analyse
  static List<String> _genererRecommandations(
    bool puissanceSuffisante,
    bool materiauAdapte,
    double margePuissance,
  ) {
    final recommandations = <String>[];

    if (!puissanceSuffisante) {
      recommandations.add(
        'La puissance du radiateur est insuffisante par rapport aux besoins thermiques.',
      );
    } else if (margePuissance > 0) {
      recommandations.add(
        'La puissance du radiateur est suffisante avec une marge de ${margePuissance.toStringAsFixed(2)} W.',
      );
    }

    if (!materiauAdapte) {
      recommandations.add(
        'Le matériau de tuyauterie n\'est pas adapté. Utiliser PVC-P, Multicouche ou Cuivre.',
      );
    }

    return recommandations;
  }

  // Génère un rapport global pour une liste de radiateurs
  static Map<String, dynamic> genererRapportGlobal(List<Radiateur> radiateurs) {
    final rapports = radiateurs.map(genererRapportRadiateur).toList();
    final nombreRadiateurs = radiateurs.length;
    final nombreConformes =
        rapports
            .where((r) => r['puissanceSuffisante'] && r['materiauAdapte'])
            .length;

    return {
      'nombreRadiateurs': nombreRadiateurs,
      'nombreConformes': nombreConformes,
      'tauxConformite': (nombreConformes / nombreRadiateurs * 100)
          .toStringAsFixed(1),
      'rapportsDetaille': rapports,
      'synthese': _genererSynthese(rapports),
    };
  }

  // Génère une synthèse du rapport global
  static Map<String, dynamic> _genererSynthese(
    List<Map<String, dynamic>> rapports,
  ) {
    final puissanceTotale = rapports.fold<double>(
      0,
      (sum, r) => sum + (r['puissance'] as double),
    );
    final besoinTotal = rapports.fold<double>(
      0,
      (sum, r) => sum + (r['besoinThermique'] as double),
    );

    return {
      'puissanceTotale': puissanceTotale,
      'besoinTotal': besoinTotal,
      'margeTotale': puissanceTotale - besoinTotal,
      'nombreNonConformes':
          rapports
              .where((r) => !r['puissanceSuffisante'] || !r['materiauAdapte'])
              .length,
    };
  }
}
