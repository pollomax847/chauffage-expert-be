class Calcul {
  final String id;
  final String type; // 'chauffage', 'hydraulique', 'vmc', etc.
  final DateTime dateCalcul;
  final Map<String, dynamic> parametres;
  final Map<String, dynamic> resultats;
  final String unitesOutput; // ex: 'kW', 'm3/h'

  Calcul({
    required this.id,
    required this.type,
    required this.dateCalcul,
    required this.parametres,
    required this.resultats,
    required this.unitesOutput,
  });

  factory Calcul.fromJson(Map<String, dynamic> json) {
    return Calcul(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      dateCalcul: json['date_calcul'] != null
          ? DateTime.parse(json['date_calcul'])
          : DateTime.now(),
      parametres: json['parametres'] ?? {},
      resultats: json['resultats'] ?? {},
      unitesOutput: json['unites_output'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'date_calcul': dateCalcul.toIso8601String(),
      'parametres': parametres,
      'resultats': resultats,
      'unites_output': unitesOutput,
    };
  }
}
