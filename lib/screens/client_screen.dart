import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/client_model.dart';
import '../services/client_db.dart';

// Fournisseur de la liste des clients
final clientsProvider = FutureProvider<List<Client>>((ref) async {
  final clientDb = ClientDbService();
  return await clientDb.getAllClients();
});

class ClientScreen extends ConsumerWidget {
  const ClientScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des clients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Rechercher un client
            },
          ),
        ],
      ),
      body: clientsAsync.when(
        data: (clients) {
          if (clients.isEmpty) {
            return const Center(
              child: Text('Aucun client trouvé. Ajoutez votre premier client.'),
            );
          }

          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return ListTile(
                title: Text('${client.prenom} ${client.nom}'),
                subtitle: Text(client.adresse),
                leading: CircleAvatar(
                  child: Text(client.prenom[0] + client.nom[0]),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Ouvrir la fiche client
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Erreur: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ouvrir le formulaire d'ajout de client
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
