// Be_chauffage_expert/lib/widgets/app_header.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importer pour le formatage de la date

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Utiliser une couleur d'ombre standard ou avec opacité
    final shadowColor = Colors.black.withOpacity(0.1);
    // TODO: Récupérer le nom de l'utilisateur dynamiquement (ex: depuis l'état de l'application/authentification)
    const userName = 'Paul';
    // TODO: Utiliser l'URL de l'avatar de l'utilisateur réel si disponible, sinon un placeholder
    const avatarUrl =
        'https://ui-avatars.com/api/?name=$userName&background=2D5E3D&color=fff';
    // Obtenir la date actuelle et la formater
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE d MMMM yyyy', 'fr_FR')
        .format(now); // Formatage en français

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: shadowColor, // Couleur d'ombre corrigée
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                // Supprimer 'const' car l'URL est dynamique
                radius: 20,
                backgroundImage: NetworkImage(avatarUrl), // URL dynamique
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenue $userName', // Nom dynamique
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    formattedDate, // Date dynamique et formatée
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implémenter les notifications
            },
          ),
        ],
      ),
    );
  }
}
