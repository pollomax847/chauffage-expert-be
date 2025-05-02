// models/calcul_params.dart
class CalculParams {
  final double surfaceArea;
  final double uValue;
  final double indoorTemp;
  final double outdoorTemp;
  final double deltaT;
  final double efficiency;
  final double pipeLength;
  final double pipeDiameter;
  final double roughness;
  final double viscosity;

  CalculParams({
    required this.surfaceArea,
    required this.uValue,
    required this.indoorTemp,
    required this.outdoorTemp,
    required this.deltaT,
    required this.efficiency,
    required this.pipeLength,
    required this.pipeDiameter,
    required this.roughness,
    required this.viscosity,
  });
}
