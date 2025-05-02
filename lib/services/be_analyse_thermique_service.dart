// services/be_analyse_thermique_service.dart
import 'dart:math';
import '../models/piece.dart';
import '../models/materiau.dart';
import './be_calcul_service.dart';

class BEAnalyseThermiqueService {
  final BECalculService _calculService;

  BEAnalyseThermiqueService(this._calculService);

  Map<String, double> analyserPiece(Piece piece) {
    final results = <String, double>{};

    // Calcul des pertes par les murs
    double pertesTotales = 0;
    for (final mur in piece.murs) {
      final pertes = _calculService.calculateHeatLoss(
        surfaceArea: mur.surface,
        uValue: mur.materiau.conductiviteThermique,
        indoorTemp: piece.temperatureInterieure,
        outdoorTemp: piece.temperatureExterieure,
      );
      pertesTotales += pertes['heatLoss']!;
      results['pertes_mur_${mur.orientation}'] = pertes['heatLoss']!;
    }

    // Calcul des pertes par le sol
    if (piece.sol != null) {
      final pertesSol = _calculService.calculateHeatLoss(
        surfaceArea: piece.surface,
        uValue: piece.sol!.conductiviteThermique,
        indoorTemp: piece.temperatureInterieure,
        outdoorTemp: piece.temperatureSol,
      );
      pertesTotales += pertesSol['heatLoss']!;
      results['pertes_sol'] = pertesSol['heatLoss']!;
    }

    // Calcul des pertes par le plafond
    if (piece.plafond != null) {
      final pertesPlafond = _calculService.calculateHeatLoss(
        surfaceArea: piece.surface,
        uValue: piece.plafond!.conductiviteThermique,
        indoorTemp: piece.temperatureInterieure,
        outdoorTemp: piece.temperaturePlafond,
      );
      pertesTotales += pertesPlafond['heatLoss']!;
      results['pertes_plafond'] = pertesPlafond['heatLoss']!;
    }

    // Calcul des pertes par renouvellement d'air
    final pertesAir = calculerPertesAir(piece);
    pertesTotales += pertesAir;
    results['pertes_air'] = pertesAir;

    // Calcul des apports solaires
    final apportsSolaires = calculerApportsSolaires(piece);
    results['apports_solaires'] = apportsSolaires;

    // Bilan thermique
    results['pertes_totales'] = pertesTotales;
    results['bilan_thermique'] = pertesTotales - apportsSolaires;

    return results;
  }

  double calculerPertesAir(Piece piece) {
    // ρ * c * Q * ΔT
    final debitAir = piece.volume * piece.tauxRenouvellementAir;
    return BECalculService.AIR_DENSITY *
        1005 *
        debitAir *
        (piece.temperatureInterieure - piece.temperatureExterieure) /
        3600;
  }

  double calculerApportsSolaires(Piece piece) {
    double apportsTotaux = 0;

    for (final mur in piece.murs) {
      if (mur.fenetres.isEmpty) continue;

      for (final fenetre in mur.fenetres) {
        // Facteur solaire * surface vitrée * rayonnement solaire
        final apports = fenetre.facteurSolaire *
            fenetre.surface *
            _getRayonnementSolaire(mur.orientation);
        apportsTotaux += apports;
      }
    }

    return apportsTotaux;
  }

  double _getRayonnementSolaire(String orientation) {
    // Valeurs moyennes de rayonnement solaire en W/m² selon l'orientation
    const rayonnements = {
      'N': 100.0,
      'NE': 200.0,
      'E': 500.0,
      'SE': 600.0,
      'S': 700.0,
      'SO': 600.0,
      'O': 500.0,
      'NO': 200.0,
    };

    return rayonnements[orientation] ?? 0.0;
  }
}
