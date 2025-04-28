class DonneesModel {
  final Map<String, dynamic> donnees;

  DonneesModel({required this.donnees});

  factory DonneesModel.fromJson(Map<String, dynamic> json) {
    return DonneesModel(donnees: json);
  }

  Map<String, dynamic> toJson() {
    return donnees;
  }
} 