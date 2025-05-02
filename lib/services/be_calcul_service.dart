// services/be_calcul_service.dart
import 'dart:math';
import '../models/calcul_params.dart';

class BECalculService {
  static const double GRAVITY = 9.81;
  static const double AIR_DENSITY = 1.225;
  static const double WATER_DENSITY = 1000;
  static const double SPECIFIC_HEAT_WATER = 4186;

  double calculatePowerNeeded({
    required double volume,
    required double deltaT,
    required double timeInHours,
    double efficiency = 0.95,
  }) {
    // P = m * c * ΔT / t
    final mass = volume * WATER_DENSITY;
    final timeInSeconds = timeInHours * 3600;
    final power =
        (mass * SPECIFIC_HEAT_WATER * deltaT) / (timeInSeconds * efficiency);
    return power;
  }

  double calculateFlowRate({
    required double power,
    required double deltaT,
    double efficiency = 0.95,
  }) {
    // Q = P / (ρ * c * ΔT)
    final flowRate =
        power / (WATER_DENSITY * SPECIFIC_HEAT_WATER * deltaT * efficiency);
    return flowRate;
  }

  double calculatePressureDrop({
    required double flowRate,
    required double pipeLength,
    required double pipeDiameter,
    required double roughness,
    required double viscosity,
  }) {
    // Reynolds number
    final velocity = flowRate / (pi * pow(pipeDiameter / 2, 2));
    final reynolds = (velocity * pipeDiameter) / viscosity;

    // Friction factor (Colebrook equation)
    double frictionFactor = 0.02; // Initial guess
    for (int i = 0; i < 10; i++) {
      frictionFactor = pow(
              -2 *
                  log(roughness / (3.7 * pipeDiameter) +
                      2.51 / (reynolds * sqrt(frictionFactor))) /
                  ln10,
              -2)
          .toDouble();
    }

    // Pressure drop (Darcy-Weisbach equation)
    final pressureDrop = frictionFactor *
        (pipeLength / pipeDiameter) *
        (WATER_DENSITY * pow(velocity, 2)) /
        2;
    return pressureDrop;
  }

  Map<String, double> calculateHeatLoss({
    required double surfaceArea,
    required double uValue,
    required double indoorTemp,
    required double outdoorTemp,
  }) {
    final deltaT = indoorTemp - outdoorTemp;
    final heatLoss = surfaceArea * uValue * deltaT;

    return {
      'heatLoss': heatLoss,
      'surfaceTemp': indoorTemp - (heatLoss / (surfaceArea * 8.29)),
    };
  }

  double calculateRadiatorSize({
    required double heatLoss,
    required double deltaT,
    double efficiency = 0.95,
  }) {
    // Simplified calculation based on EN 442
    final nominalPower = heatLoss / efficiency;
    final correctionFactor = pow(deltaT / 50, 1.3);
    return nominalPower / correctionFactor;
  }

  Map<String, double> optimizeSystem(CalculParams params) {
    final results = <String, double>{};

    // Calcul des pertes thermiques
    final heatLossResults = calculateHeatLoss(
      surfaceArea: params.surfaceArea,
      uValue: params.uValue,
      indoorTemp: params.indoorTemp,
      outdoorTemp: params.outdoorTemp,
    );
    results['heatLoss'] = heatLossResults['heatLoss']!;

    // Dimensionnement du radiateur
    results['radiatorSize'] = calculateRadiatorSize(
      heatLoss: results['heatLoss']!,
      deltaT: params.deltaT,
      efficiency: params.efficiency,
    );

    // Calcul du débit
    results['flowRate'] = calculateFlowRate(
      power: results['radiatorSize']!,
      deltaT: params.deltaT,
      efficiency: params.efficiency,
    );

    // Calcul des pertes de charge
    results['pressureDrop'] = calculatePressureDrop(
      flowRate: results['flowRate']!,
      pipeLength: params.pipeLength,
      pipeDiameter: params.pipeDiameter,
      roughness: params.roughness,
      viscosity: params.viscosity,
    );

    return results;
  }
}
