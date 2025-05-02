// models/client.dart
import 'package:uuid/uuid.dart';

class Client {
  final String id;
  final String nom;
  final String prenom;
  final String? email;
  final String? telephone;
  final String? adresse;
  final String? ville;
  final String? codePostal;
  final DateTime dateCreation;
  final DateTime derniereMaj;

  Client({
    String? id,
    required this.nom,
    required this.prenom,
    this.email,
    this.telephone,
    this.adresse,
    this.ville,
    this.codePostal,
    DateTime? dateCreation,
    DateTime? derniereMaj,
  })  : id = id ?? const Uuid().v4(),
        dateCreation = dateCreation ?? DateTime.now(),
        derniereMaj = derniereMaj ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'adresse': adresse,
      'ville': ville,
      'codePostal': codePostal,
      'dateCreation': dateCreation.toIso8601String(),
      'derniereMaj': derniereMaj.toIso8601String(),
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      email: map['email'],
      telephone: map['telephone'],
      adresse: map['adresse'],
      ville: map['ville'],
      codePostal: map['codePostal'],
      dateCreation: DateTime.parse(map['dateCreation']),
      derniereMaj: DateTime.parse(map['derniereMaj']),
    );
  }
}
