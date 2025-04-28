// models/radiateur.dart
class Radiateur {
  final String id;
  final String reference;
  final double puissance; // en kW
  final double largeur; // en mm
  final double hauteur; // en mm
  final double profondeur; // en mm
  final String materiau; // Exemple: 'acier', 'fonte', 'aluminium'
  final String typeRaccordement; // Exemple: 'central', 'lateral'
  final double entraxe; // en mm
  final String identification; // Identification de la pièce
  final String? modele; // Modèle du radiateur
  final double besoinThermique; // Besoin thermique en W
  final String materiauTuyauterie; // Matériau de la tuyauterie

  Radiateur({
    required this.id,
    required this.reference,
    required this.puissance,
    required this.largeur,
    required this.hauteur,
    required this.profondeur,
    required this.materiau,
    required this.typeRaccordement,
    required this.entraxe,
    required this.identification,
    this.modele,
    required this.besoinThermique,
    required this.materiauTuyauterie,
  });

  factory Radiateur.fromJson(Map<String, dynamic> json) {
    return Radiateur(
      id: json['id'] ?? '',
      reference: json['reference'] ?? '',
      puissance: double.tryParse(json['puissance'].toString()) ?? 0.0,
      largeur: double.tryParse(json['largeur'].toString()) ?? 0.0,
      hauteur: double.tryParse(json['hauteur'].toString()) ?? 0.0,
      profondeur: double.tryParse(json['profondeur'].toString()) ?? 0.0,
      materiau: json['materiau'] ?? '',
      typeRaccordement: json['type_raccordement'] ?? '',
      entraxe: double.tryParse(json['entraxe'].toString()) ?? 0.0,
      identification: json['identification'] ?? '',
      modele: json['modele'],
      besoinThermique:
          double.tryParse(json['besoin_thermique'].toString()) ?? 0.0,
      materiauTuyauterie: json['materiau_tuyauterie'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'puissance': puissance,
      'largeur': largeur,
      'hauteur': hauteur,
      'profondeur': profondeur,
      'materiau': materiau,
      'type_raccordement': typeRaccordement,
      'entraxe': entraxe,
      'identification': identification,
      'modele': modele,
      'besoin_thermique': besoinThermique,
      'materiau_tuyauterie': materiauTuyauterie,
    };
  }
}
