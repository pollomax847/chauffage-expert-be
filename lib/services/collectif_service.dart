// services/collectif_service.dart
import 'dart:math';

class CollectifService {
  // 1. Calcul du volume du ballon solaire
  static Map<String, double> calculerVolumeBallon({
    required int nombreLogements,
    required double surfaceCapteurs,
    required double consommationECS,
    required double tauxCouverture,
  }) {
    // Volume minimal selon la surface de capteurs (50L/m²)
    final volumeMinimal = surfaceCapteurs * 50;

    // Volume selon la consommation ECS (30L/personne/jour)
    final volumeConsommation = nombreLogements * 2.5 * 30;

    // Volume selon le taux de couverture souhaité
    final volumeCouverture = (volumeConsommation * tauxCouverture) / 100;

    // Volume final (maximum des trois)
    final volumeFinal =
        max(volumeMinimal, max(volumeConsommation, volumeCouverture));

    return {
      'volumeMinimal': volumeMinimal,
      'volumeConsommation': volumeConsommation,
      'volumeCouverture': volumeCouverture,
      'volumeFinal': volumeFinal,
    };
  }

  // 2. Dimensionnement des capteurs solaires
  static Map<String, double> dimensionnerCapteurs({
    required int nombreLogements,
    required double consommationECS,
    required double tauxCouverture,
    required double ensoleillement,
  }) {
    // Besoin énergétique annuel (kWh)
    final besoinEnergetique = consommationECS * 1.16 * 365;

    // Production solaire nécessaire (kWh)
    final productionNecessaire = (besoinEnergetique * tauxCouverture) / 100;

    // Surface de capteurs nécessaire (m²)
    final surfaceCapteurs = productionNecessaire / (ensoleillement * 0.7);

    return {
      'besoinEnergetique': besoinEnergetique,
      'productionNecessaire': productionNecessaire,
      'surfaceCapteurs': surfaceCapteurs,
    };
  }

  // 3. Calcul de la puissance de la chaudière collective
  static Map<String, double> calculerPuissanceChaudiere({
    required int nombreLogements,
    required double surfaceChauffee,
    required String isolation,
    required double temperatureExterieure,
    required double temperatureInterieure,
  }) {
    // Coefficient de déperdition selon l'isolation
    final coefficients = {
      'excellente': 0.6,
      'bonne': 0.8,
      'moyenne': 1.0,
      'mauvaise': 1.2,
    };

    final coefficient = coefficients[isolation] ?? 1.0;

    // Puissance de base (W/m²)
    final puissanceBase = 100 * coefficient;

    // Correction selon la température
    final deltaT = temperatureInterieure - temperatureExterieure;
    final coefficientTemperature = max(1, deltaT / 20).toDouble();

    // Puissance totale (kW)
    final puissanceTotale =
        (puissanceBase * surfaceChauffee * coefficientTemperature) / 1000;

    return {
      'puissanceBase': puissanceBase,
      'coefficientTemperature': coefficientTemperature,
      'puissanceTotale': puissanceTotale,
    };
  }

  // 4. Calcul du rendement annuel
  static Map<String, double> calculerRendement({
    required double productionSolaire,
    required double consommationGaz,
    required double pouvoirCalorifique,
  }) {
    // Énergie solaire (kWh)
    final energieSolaire = productionSolaire;

    // Énergie gaz (kWh)
    final energieGaz = consommationGaz * pouvoirCalorifique;

    // Énergie totale (kWh)
    final energieTotale = energieSolaire + energieGaz;

    // Rendement solaire (%)
    final rendementSolaire = (energieSolaire / energieTotale) * 100;

    return {
      'energieSolaire': energieSolaire,
      'energieGaz': energieGaz,
      'energieTotale': energieTotale,
      'rendementSolaire': rendementSolaire,
    };
  }

  // 5. Calcul de la puissance de la pompe à chaleur collective
  static Map<String, double> calculerPuissancePAC({
    required int nombreLogements,
    required double surfaceChauffee,
    required String isolation,
    required double temperatureExterieure,
    required double temperatureInterieure,
    required double temperatureEau,
  }) {
    // Coefficient de déperdition selon l'isolation
    final coefficients = {
      'excellente': 0.6,
      'bonne': 0.8,
      'moyenne': 1.0,
      'mauvaise': 1.2,
    };

    final coefficient = coefficients[isolation] ?? 1.0;

    // Puissance de base (W/m²)
    final puissanceBase = 100 * coefficient;

    // Correction selon la température
    final deltaT = temperatureInterieure - temperatureExterieure;
    final coefficientTemperature = max(1, deltaT / 20).toDouble();

    // Puissance totale (kW)
    final puissanceTotale =
        (puissanceBase * surfaceChauffee * coefficientTemperature) / 1000;

    // COP estimé selon la température de l'eau
    final cop = temperatureEau > 45 ? 2.5 : 3.5;

    // Puissance électrique nécessaire (kW)
    final puissanceElectrique = puissanceTotale / cop;

    return {
      'puissanceBase': puissanceBase,
      'coefficientTemperature': coefficientTemperature,
      'puissanceTotale': puissanceTotale,
      'cop': cop,
      'puissanceElectrique': puissanceElectrique,
    };
  }

  // 6. Dimensionnement du réseau de chaleur
  static Map<String, double> dimensionnerReseau({
    required double puissanceThermique,
    required double longueurReseau,
    required double temperatureDepart,
    required double temperatureRetour,
    required double pertesLineaires,
  }) {
    // Débit volumique (m³/h)
    final debitVolumique = (puissanceThermique * 1000) /
        (4.18 * (temperatureDepart - temperatureRetour));

    // Diamètre nominal (mm)
    final diametreNominal = sqrt(debitVolumique * 4 / (pi * 2)) * 1000;

    // Pertes de charge linéaires (bar/100m)
    final pertesChargeLineaires = pertesLineaires * longueurReseau / 100;

    // Pertes thermiques (kW)
    final pertesThermiques =
        pertesLineaires * longueurReseau * puissanceThermique / 100;

    return {
      'debitVolumique': debitVolumique,
      'diametreNominal': diametreNominal,
      'pertesChargeLineaires': pertesChargeLineaires,
      'pertesThermiques': pertesThermiques,
    };
  }

  // 7. Dimensionnement des émetteurs de chaleur
  static Map<String, double> dimensionnerEmetteurs({
    required double puissanceThermique,
    required double temperatureDepart,
    required double temperatureRetour,
    required double temperatureAmbiance,
    required String typeEmetteur,
  }) {
    // Coefficient de correction selon le type d'émetteur
    final coefficients = {
      'radiateur': 1.0,
      'plancherChauffant': 0.8,
      'ventiloConvecteur': 1.2,
    };

    final coefficient = coefficients[typeEmetteur] ?? 1.0;

    // Température moyenne de l'eau
    final temperatureMoyenne = (temperatureDepart + temperatureRetour) / 2;

    // Écart de température
    final deltaT = temperatureMoyenne - temperatureAmbiance;

    // Puissance corrigée (kW)
    final puissanceCorrigee = puissanceThermique * coefficient;

    // Surface d'émission nécessaire (m²)
    final surfaceEmission = puissanceCorrigee / (deltaT * 10);

    return {
      'puissanceCorrigee': puissanceCorrigee,
      'temperatureMoyenne': temperatureMoyenne,
      'deltaT': deltaT,
      'surfaceEmission': surfaceEmission,
    };
  }

  // 8. Dimensionnement des colonnes montantes d'eau
  static Map<String, double> dimensionnerColonnesMontantes({
    required int nombreLogements,
    required int nombreEtages,
    required double consommationParLogement,
    required double hauteurEtage,
  }) {
    // Débit de pointe par logement (L/s)
    final debitPointe = consommationParLogement * 0.2;

    // Débit total (L/s)
    final debitTotal = debitPointe * nombreLogements;

    // Hauteur totale (m)
    final hauteurTotale = hauteurEtage * nombreEtages;

    // Pression minimale requise (bar)
    final pressionMinimale = 1.5 + (hauteurTotale * 0.1);

    // Diamètre nominal (mm)
    final diametreNominal = sqrt(debitTotal * 4 / (pi * 1.5)) * 1000;

    // Vitesse d'écoulement (m/s)
    final vitesse = debitTotal / (pi * pow(diametreNominal / 2000, 2));

    return {
      'debitPointe': debitPointe,
      'debitTotal': debitTotal,
      'hauteurTotale': hauteurTotale,
      'pressionMinimale': pressionMinimale,
      'diametreNominal': diametreNominal,
      'vitesse': vitesse,
    };
  }

  // 9. Dimensionnement des pompes de retour de boucles
  static Map<String, double> dimensionnerPompesRetour({
    required double debitVolumique,
    required double temperatureDepart,
    required double temperatureRetour,
    required double longueurBoucle,
    required double pertesLineaires,
  }) {
    // Écart de température
    final deltaT = temperatureDepart - temperatureRetour;

    // Pertes de charge totales (bar)
    final pertesCharge = (pertesLineaires * longueurBoucle) / 100;

    // Hauteur manométrique (m)
    final hauteurManometrique = pertesCharge * 10.2;

    // Puissance hydraulique (kW)
    final puissanceHydraulique =
        (debitVolumique * hauteurManometrique * 9.81) / 3600;

    // Puissance absorbée (kW) avec rendement de 70%
    final puissanceAbsorbee = puissanceHydraulique / 0.7;

    // Vitesse de rotation (tr/min)
    final vitesseRotation = 1450.0;

    return {
      'deltaT': deltaT,
      'pertesCharge': pertesCharge,
      'hauteurManometrique': hauteurManometrique,
      'puissanceHydraulique': puissanceHydraulique,
      'puissanceAbsorbee': puissanceAbsorbee,
      'vitesseRotation': vitesseRotation,
    };
  }

  // 10. Dimensionnement de la VMC
  static Map<String, double> dimensionnerVMC({
    required int nombreLogements,
    required double surfaceHabitable,
    required String typeVMC,
    required double tauxOccupation,
  }) {
    // Débit de base par logement (m³/h)
    final debitBase = typeVMC == 'simple flux' ? 15.0 : 30.0;

    // Débit total (m³/h)
    final debitTotal = debitBase * nombreLogements * tauxOccupation;

    // Puissance du ventilateur (W)
    final puissanceVentilateur = debitTotal * 0.2;

    // Consommation annuelle (kWh)
    final consommationAnnuelle = puissanceVentilateur * 24 * 365 / 1000;

    return {
      'debitBase': debitBase,
      'debitTotal': debitTotal,
      'puissanceVentilateur': puissanceVentilateur,
      'consommationAnnuelle': consommationAnnuelle,
    };
  }

  static Map<String, double> dimensionnerPompesCirculation({
    required double debitVolumique,
    required double hauteurManometrique,
    required double longueurReseau,
    required double pertesLineaires,
  }) {
    final pertesCharge = (pertesLineaires * longueurReseau) / 100;
    final hauteurTotale = hauteurManometrique + (pertesCharge * 10.2);
    final puissanceHydraulique = (debitVolumique * hauteurTotale * 9.81) / 3600;
    final puissanceAbsorbee = puissanceHydraulique / 0.7;
    final vitesseRotation = 1450.0;

    return {
      'pertesCharge': pertesCharge,
      'hauteurTotale': hauteurTotale,
      'puissanceHydraulique': puissanceHydraulique,
      'puissanceAbsorbee': puissanceAbsorbee,
      'vitesseRotation': vitesseRotation,
    };
  }

  static Map<String, double> dimensionnerPompesSurpression({
    required double debitTotal,
    required double hauteurTotale,
    required double pressionMinimale,
  }) {
    final pressionTotale = pressionMinimale + (hauteurTotale * 0.1);
    final puissanceHydraulique = (debitTotal * pressionTotale * 0.1) / 3.6;
    final puissanceAbsorbee = puissanceHydraulique / 0.7;
    final vitesseRotation = 1450.0;

    return {
      'pressionTotale': pressionTotale,
      'puissanceHydraulique': puissanceHydraulique,
      'puissanceAbsorbee': puissanceAbsorbee,
      'vitesseRotation': vitesseRotation,
    };
  }
}
