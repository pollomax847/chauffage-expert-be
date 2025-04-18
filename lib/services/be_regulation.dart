import 'dart:math';

class BERegulation {
  // Calcul des sous-stations
  static Map<String, dynamic> dimensionnerSousStation({
    required double puissanceThermique,
    required double temperatureDepart,
    required double temperatureRetour,
    required double temperatureAmbiance,
  }) {
    // Débit volumique (m³/h)
    final debitVolumique = (puissanceThermique * 1000) /
        (4.18 * (temperatureDepart - temperatureRetour));

    // Puissance de l'échangeur (kW)
    final puissanceEchangeur = puissanceThermique * 1.2;

    // Surface d'échange (m²)
    final deltaT =
        (temperatureDepart + temperatureRetour) / 2 - temperatureAmbiance;
    final surfaceEchange = puissanceEchangeur / (deltaT * 0.8);

    // Volume du vase d'expansion (L)
    final volumeVase = (debitVolumique * 0.1).ceilToDouble();

    return {
      'debitVolumique': debitVolumique.toStringAsFixed(2),
      'puissanceEchangeur': puissanceEchangeur.toStringAsFixed(1),
      'surfaceEchange': surfaceEchange.toStringAsFixed(2),
      'volumeVase': volumeVase.toStringAsFixed(0),
    };
  }

  // Calcul des vannes de régulation
  static Map<String, dynamic> dimensionnerVanne({
    required double debit,
    required double pressionDifferentielle,
    required String typeVanne,
  }) {
    // Kv de la vanne
    final kv = debit / sqrt(pressionDifferentielle);

    // Diamètre nominal (mm)
    final diametreNominal = sqrt(kv * 4 / (pi * 0.5)) * 1000;

    // Coefficient de débit selon le type de vanne
    final coefficients = {
      '2_voies': 1.0,
      '3_voies': 1.2,
      'equilibrage': 0.8,
    };

    final coefficient = coefficients[typeVanne] ?? 1.0;

    // Kv corrigé
    final kvCorrige = kv * coefficient;

    // Puissance de l'actionneur (W)
    final puissanceActionneur = max(5.0, kvCorrige * 0.1);

    return {
      'kv': kv.toStringAsFixed(2),
      'kvCorrige': kvCorrige.toStringAsFixed(2),
      'diametreNominal': diametreNominal.toStringAsFixed(0),
      'puissanceActionneur': puissanceActionneur.toStringAsFixed(1),
    };
  }

  // Calcul des vases d'expansion
  static Map<String, dynamic> dimensionnerVaseExpansion({
    required double volumeInstallation,
    required double temperatureMax,
    required double pressionMax,
  }) {
    // Coefficient d'expansion de l'eau
    final coefficientExpansion = 0.00043 * (temperatureMax - 10);

    // Volume d'expansion (L)
    final volumeExpansion = volumeInstallation * coefficientExpansion;

    // Volume du vase (L)
    final volumeVase = volumeExpansion * 1.1;

    // Pression de gonflage (bar)
    final pressionGonflage = pressionMax * 0.3;

    return {
      'volumeExpansion': volumeExpansion.toStringAsFixed(2),
      'volumeVase': volumeVase.toStringAsFixed(0),
      'pressionGonflage': pressionGonflage.toStringAsFixed(1),
    };
  }

  // Coefficients de régulation selon le type
  static const Map<String, double> coefficientsRegulation = {
    'thermostat': 1.0,
    'thermostat_programmable': 1.1,
    'thermostat_connecte': 1.2,
    'regulation_par_zone': 1.3,
  };

  // Calcul des paramètres de régulation
  static Map<String, dynamic> calculerParametres({
    required double puissanceChaudiere,
    required String typeRegulation,
    required int nombreZones,
  }) {
    // Coefficient selon le type de régulation
    final coefficient = coefficientsRegulation[typeRegulation] ?? 1.0;

    // Calcul de la puissance par zone
    final puissanceParZone = puissanceChaudiere / nombreZones;

    // Calcul des économies potentielles
    final economies = (coefficient - 1.0) * 100; // en pourcentage

    return {
      'puissanceChaudiere': puissanceChaudiere.toStringAsFixed(2),
      'puissanceParZone': puissanceParZone.toStringAsFixed(2),
      'typeRegulation': typeRegulation,
      'nombreZones': nombreZones,
      'coefficient': coefficient.toStringAsFixed(2),
      'economiesPotentielles': economies.toStringAsFixed(1),
    };
  }

  // Calcul du nombre de vannes thermostatiques
  static Map<String, dynamic> calculerVannesThermostatiques({
    required int nombreRadiateurs,
    required int nombreZones,
  }) {
    final vannesParZone = (nombreRadiateurs / nombreZones).ceil();

    return {
      'nombreTotalVannes': nombreRadiateurs,
      'vannesParZone': vannesParZone,
      'nombreZones': nombreZones,
    };
  }
}
