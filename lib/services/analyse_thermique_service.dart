import '../models/radiateur.dart';
import '../models/etude.dart';

class AnalyseThermiqueService {
  // Vérifie si la puissance du radiateur est suffisante
  static bool verifierPuissance(Radiateur radiateur, double besoinThermique) {
    return radiateur.puissance >= besoinThermique;
  }

  // Vérifie si le matériau de tuyauterie est adapté
  static bool verifierMateriauTuyauterie(String materiau) {
    final materiauxValides = ['PVC-P', 'Multicouche', 'Cuivre'];
    return materiauxValides.contains(materiau);
  }

  // Calcule la marge de puissance
  static double calculerMargePuissance(
      Radiateur radiateur, double besoinThermique) {
    return radiateur.puissance - besoinThermique;
  }

  // Génère un rapport d'analyse pour un radiateur
  static Map<String, dynamic> genererRapportRadiateur(
    Radiateur radiateur,
    double besoinThermique,
    String materiauTuyauterie,
    String identification,
    String? modele,
  ) {
    final puissanceSuffisante = verifierPuissance(radiateur, besoinThermique);
    final materiauAdapte = verifierMateriauTuyauterie(materiauTuyauterie);
    final margePuissance = calculerMargePuissance(radiateur, besoinThermique);

    final dimensions =
        '${radiateur.largeur}x${radiateur.hauteur}x${radiateur.profondeur} mm';

    return {
      'reference': radiateur.reference,
      'identification': identification,
      'modele': modele ?? radiateur.reference,
      'dimensions': dimensions,
      'puissance': radiateur.puissance,
      'besoinThermique': besoinThermique,
      'margePuissance': margePuissance,
      'puissanceSuffisante': puissanceSuffisante,
      'materiauTuyauterie': materiauTuyauterie,
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

  // Génère un rapport global pour une liste de radiateurs avec informations supplémentaires
  static Map<String, dynamic> genererRapportGlobal(
    List<Radiateur> radiateurs,
    List<double> besoinsThermiques,
    List<String> materiauxTuyauterie,
    List<String> identifications,
    List<String?> modeles,
  ) {
    if (radiateurs.length != besoinsThermiques.length ||
        radiateurs.length != materiauxTuyauterie.length ||
        radiateurs.length != identifications.length ||
        radiateurs.length != modeles.length) {
      throw ArgumentError('Toutes les listes doivent avoir la même longueur');
    }

    final rapports = <Map<String, dynamic>>[];

    for (var i = 0; i < radiateurs.length; i++) {
      rapports.add(genererRapportRadiateur(
        radiateurs[i],
        besoinsThermiques[i],
        materiauxTuyauterie[i],
        identifications[i],
        modeles[i],
      ));
    }

    final nombreRadiateurs = radiateurs.length;
    final nombreConformes = rapports
        .where((r) => r['puissanceSuffisante'] && r['materiauAdapte'])
        .length;

    return {
      'nombreRadiateurs': nombreRadiateurs,
      'nombreConformes': nombreConformes,
      'tauxConformite': nombreRadiateurs > 0
          ? (nombreConformes / nombreRadiateurs * 100).toStringAsFixed(1)
          : '0.0',
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
      'nombreNonConformes': rapports
          .where((r) => !r['puissanceSuffisante'] || !r['materiauAdapte'])
          .length,
    };
  }
}
