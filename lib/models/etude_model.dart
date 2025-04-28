class Etude {
  final String id;
  final String clientId;
  final String adresse;
  final double surface;
  final double hauteur;
  final double temperatureSouhaitee;
  final DateTime dateCreation;

  Etude({
    required this.id,
    required this.clientId,
    required this.adresse,
    required this.surface,
    required this.hauteur,
    required this.temperatureSouhaitee,
    required this.dateCreation,
  });

  factory Etude.fromJson(Map<String, dynamic> json) {
    return Etude(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      adresse: json['adresse'] as String,
      surface: json['surface'] as double,
      hauteur: json['hauteur'] as double,
      temperatureSouhaitee: json['temperatureSouhaitee'] as double,
      dateCreation: DateTime.parse(json['dateCreation'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'adresse': adresse,
      'surface': surface,
      'hauteur': hauteur,
      'temperatureSouhaitee': temperatureSouhaitee,
      'dateCreation': dateCreation.toIso8601String(),
    };
  }
}
