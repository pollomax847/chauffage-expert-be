// models/materiau.dart
class Materiau {
  final String id;
  final String nom;
  final double conductiviteThermique; // W/(m·K)
  final double epaisseur; // m
  final double masseVolumique; // kg/m³
  final double chaleurSpecifique; // J/(kg·K)

  Materiau({
    required this.id,
    required this.nom,
    required this.conductiviteThermique,
    required this.epaisseur,
    required this.masseVolumique,
    required this.chaleurSpecifique,
  });

  double get resistanceThermique => epaisseur / conductiviteThermique;
}
