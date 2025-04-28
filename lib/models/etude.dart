import 'package:flutter/foundation.dart';

class Etude {
  final String id;
  final String clientId;
  final String adresse;
  final String description;
  final DateTime dateCreation;
  final Map<String, dynamic> donneesTechniques;
  final List<String> documents;
  final Map<String, dynamic> resultats;

  Etude({
    required this.id,
    required this.clientId,
    required this.adresse,
    required this.description,
    required this.dateCreation,
    this.donneesTechniques = const {},
    this.documents = const [],
    this.resultats = const {},
  });

  factory Etude.fromJson(Map<String, dynamic> json) {
    return Etude(
      id: json['id'] ?? '',
      clientId: json['client_id'] ?? '',
      adresse: json['adresse'] ?? '',
      description: json['description'] ?? '',
      dateCreation: json['date_creation'] != null
          ? DateTime.parse(json['date_creation'])
          : DateTime.now(),
      donneesTechniques: json['donnees_techniques'] ?? {},
      documents: List<String>.from(json['documents'] ?? []),
      resultats: json['resultats'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'adresse': adresse,
      'description': description,
      'date_creation': dateCreation.toIso8601String(),
      'donnees_techniques': donneesTechniques,
      'documents': documents,
      'resultats': resultats,
    };
  }
}
