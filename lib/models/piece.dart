// models/piece.dart
import 'materiau.dart';

class Mur {
  final String orientation;
  final double surface;
  final Materiau materiau;
  final List<Fenetre> fenetres;

  Mur({
    required this.orientation,
    required this.surface,
    required this.materiau,
    this.fenetres = const [],
  });
}

class Fenetre {
  final double surface;
  final double facteurSolaire;

  Fenetre({
    required this.surface,
    required this.facteurSolaire,
  });
}

class Piece {
  final String id;
  final String nom;
  final double surface;
  final double volume;
  final double temperatureInterieure;
  final double temperatureExterieure;
  final double temperatureSol;
  final double temperaturePlafond;
  final double tauxRenouvellementAir;
  final List<Mur> murs;
  final Materiau? sol;
  final Materiau? plafond;

  Piece({
    required this.id,
    required this.nom,
    required this.surface,
    required this.volume,
    required this.temperatureInterieure,
    required this.temperatureExterieure,
    required this.temperatureSol,
    required this.temperaturePlafond,
    required this.tauxRenouvellementAir,
    required this.murs,
    this.sol,
    this.plafond,
  });
}
