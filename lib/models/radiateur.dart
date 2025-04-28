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
    };
  }
}
