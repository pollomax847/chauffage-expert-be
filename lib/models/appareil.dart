class Appareil {
  final String nom;
  final double uniteDebit;
  int quantite;

  Appareil({
    required this.nom,
    required this.uniteDebit,
    this.quantite = 0,
  });
}

// Table de correspondance des diamètres
class DiametreCorrespondance {
  final double diametreInterieur;
  final String diametreNominal;

  DiametreCorrespondance({
    required this.diametreInterieur,
    required this.diametreNominal,
  });
}

// Liste des diamètres standards
final diametresStandards = [
  DiametreCorrespondance(diametreInterieur: 13, diametreNominal: 'DN 15/21'),
  DiametreCorrespondance(diametreInterieur: 20, diametreNominal: 'DN 20/25'),
  DiametreCorrespondance(diametreInterieur: 26, diametreNominal: 'DN 26/32'),
  DiametreCorrespondance(diametreInterieur: 33, diametreNominal: 'DN 33/42'),
  DiametreCorrespondance(diametreInterieur: 42, diametreNominal: 'DN 42/50'),
  DiametreCorrespondance(diametreInterieur: 50, diametreNominal: 'DN 50/60'),
  DiametreCorrespondance(diametreInterieur: 60, diametreNominal: 'DN 60/75'),
  DiametreCorrespondance(diametreInterieur: 75, diametreNominal: 'DN 75/90'),
];
