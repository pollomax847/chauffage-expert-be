import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/client_model.dart';

class ClientDbService {
  static const String _clientsKey = 'clients';

  // Récupérer tous les clients
  Future<List<Client>> getAllClients() async {
    final prefs = await SharedPreferences.getInstance();
    final clientsJson = prefs.getStringList(_clientsKey) ?? [];

    return clientsJson
        .map((json) => Client.fromJson(jsonDecode(json)))
        .toList();
  }

  // Ajouter ou mettre à jour un client
  Future<void> saveClient(Client client) async {
    final prefs = await SharedPreferences.getInstance();
    final clientsJson = prefs.getStringList(_clientsKey) ?? [];

    // Supprimer le client existant s'il existe
    final filteredClients = clientsJson.where((json) {
      final c = Client.fromJson(jsonDecode(json));
      return c.id != client.id;
    }).toList();

    // Ajouter le nouveau client
    filteredClients.add(jsonEncode(client.toJson()));

    // Sauvegarder la liste mise à jour
    await prefs.setStringList(_clientsKey, filteredClients);
  }

  // Supprimer un client
  Future<void> deleteClient(String clientId) async {
    final prefs = await SharedPreferences.getInstance();
    final clientsJson = prefs.getStringList(_clientsKey) ?? [];

    final filteredClients = clientsJson.where((json) {
      final client = Client.fromJson(jsonDecode(json));
      return client.id != clientId;
    }).toList();

    await prefs.setStringList(_clientsKey, filteredClients);
  }
}
