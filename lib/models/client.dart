class Client {
  final String id;
  final String nom;
  final String prenom;
  final String adresse;
  final String ville;
  final String codePostal;
  final String telephone;
  final String email;
  final List<String> interventions;
  final Map<String, dynamic> preferences;

  Client({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.ville,
    required this.codePostal,
    required this.telephone,
    required this.email,
    this.interventions = const [],
    this.preferences = const {},
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      adresse: json['adresse'] ?? '',
      ville: json['ville'] ?? '',
      codePostal: json['code_postal'] ?? '',
      telephone: json['telephone'] ?? '',
      email: json['email'] ?? '',
      interventions: List<String>.from(json['interventions'] ?? []),
      preferences: json['preferences'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'adresse': adresse,
      'ville': ville,
      'code_postal': codePostal,
      'telephone': telephone,
      'email': email,
      'interventions': interventions,
      'preferences': preferences,
    };
  }
}
