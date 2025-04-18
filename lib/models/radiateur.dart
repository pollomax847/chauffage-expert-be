class Radiateur {
  final String reference;
  final String identification;
  final String modele;
  final String dimensions;
  final double puissance;
  final String materiauTuyauterie;
  final double besoinThermique;

  Radiateur({
    required this.reference,
    required this.identification,
    required this.modele,
    required this.dimensions,
    required this.puissance,
    required this.materiauTuyauterie,
    required this.besoinThermique,
  });

  factory Radiateur.fromJson(Map<String, dynamic> json) {
    return Radiateur(
      reference: json['reference'] as String,
      identification: json['identification'] as String,
      modele: json['modele'] as String,
      dimensions: json['dimensions'] as String,
      puissance: (json['puissance'] as num).toDouble(),
      materiauTuyauterie: json['materiauTuyauterie'] as String,
      besoinThermique: (json['besoinThermique'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'identification': identification,
      'modele': modele,
      'dimensions': dimensions,
      'puissance': puissance,
      'materiauTuyauterie': materiauTuyauterie,
      'besoinThermique': besoinThermique,
    };
  }
}
