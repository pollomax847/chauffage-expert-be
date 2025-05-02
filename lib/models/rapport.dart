import 'package:uuid/uuid.dart';

class Rapport {
  final String id;
  final String clientName;
  final String entrepriseName;
  final String moduleName;
  final Map<String, dynamic> results;
  final DateTime createdAt;
  final String? filePath;

  Rapport({
    String? id,
    required this.clientName,
    required this.entrepriseName,
    required this.moduleName,
    required this.results,
    DateTime? createdAt,
    this.filePath,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'clientName': clientName,
        'entrepriseName': entrepriseName,
        'moduleName': moduleName,
        'results': results,
        'createdAt': createdAt.toIso8601String(),
        'filePath': filePath,
      };

  factory Rapport.fromJson(Map<String, dynamic> json) => Rapport(
        id: json['id'],
        clientName: json['clientName'],
        entrepriseName: json['entrepriseName'],
        moduleName: json['moduleName'],
        results: json['results'],
        createdAt: DateTime.parse(json['createdAt']),
        filePath: json['filePath'],
      );
}
