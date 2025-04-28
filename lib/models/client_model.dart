class Client {
  final String id;
  final String nom;
  final String prenom;
  final String adresse;
  final String telephone;
  final String email;

  Client({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.telephone,
    required this.email,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      adresse: json['adresse'] as String,
      telephone: json['telephone'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'adresse': adresse,
      'telephone': telephone,
      'email': email,
    };
  }
}
