import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // Ajout pour les mocks
import 'package:be_chauffage_expert/services/be_3cep.dart'; // Ensure this file exists
import 'package:be_chauffage_expert/services/be_security_service.dart'; // Ensure this file exists

// Mock pour BESecurityService
class MockBESecurityService extends Mock implements BESecurityService {}

void main() {
  // Configuration avant les tests
  setUpAll(() {
    // Ignorer les appels aux services externes
    // Cette partie est nécessaire car BE3CEP dépend probablement de BESecurityService
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('BE3CEP Tests', () {
    test('Calcul chauffage avec données valides', () {
      final surfaces = {
        'murs': 100.0,
        'plafond': 50.0,
        'plancher': 50.0,
        'fenetres': 10.0,
        'portes': 2.0,
      };

      // Essayer d'exécuter le calcul dans un bloc try-catch pour gérer les erreurs potentielles
      Map<String, dynamic> resultat;
      try {
        resultat = BE3CEP.calculerInstallation(
          typeBatiment: 'Individuel',
          nombrePersonnes: 4,
          zoneClimatique: 'H1',
          temperatureInterieure: 19.0,
          surfaces: surfaces,
          coefficientSecurite: 1.1,
          coefficientSimultaneiteECS: 0.7,
          tempsRechauffement: 1.0,
          appareilsSanitaires: {'lavabo': 2, 'douche': 1, 'wc': 1},
          penteEUEV: 2.0,
          locaux: {
            'sejour': 1,
            'chambre': 3,
            'cuisine': 1,
            'salle_de_bain': 1,
            'wc': 1
          },
        );
      } catch (e) {
        fail('BE3CEP.calculerInstallation a échoué avec l\'erreur: $e');
      }

      // Vérifications avec gestion de null safety
      expect(resultat, isNotNull);
      expect(resultat.containsKey('erreur'), isFalse);
      expect(resultat['chauffage'], isNotNull);
      expect(resultat['ecs'], isNotNull);
      expect(resultat['euev'], isNotNull);
      expect(resultat['vmc'], isNotNull);
      expect(resultat['recommandations'], isNotNull);
    });

    test('Validation zone climatique invalide', () {
      // Test avec une zone climatique incorrecte
      final surfaces = {
        'murs': 100.0,
        'plafond': 50.0,
        'plancher': 50.0,
        'fenetres': 10.0,
        'portes': 2.0
      };
      final resultat = BE3CEP.calculerInstallation(
        typeBatiment: 'Individuel',
        nombrePersonnes: 4,
        zoneClimatique: 'H4', // Zone invalide
        temperatureInterieure: 19.0,
        surfaces: surfaces,
        coefficientSecurite: 1.1,
        coefficientSimultaneiteECS: 0.7,
        tempsRechauffement: 1.0,
        appareilsSanitaires: {'lavabo': 2, 'douche': 1, 'wc': 1},
        penteEUEV: 2.0,
        locaux: {
          'sejour': 1,
          'chambre': 3,
          'cuisine': 1,
          'salle_de_bain': 1,
          'wc': 1
        },
      );

      expect(resultat.containsKey('erreur'), isTrue);
      expect(resultat['erreur'], contains('Zone climatique invalide'));
    });

    test('Validation température hors limites', () {
      final surfaces = {
        'murs': 100.0,
        'plafond': 50.0,
        'plancher': 50.0,
        'fenetres': 10.0,
        'portes': 2.0
      };
      final resultat = BE3CEP.calculerInstallation(
        typeBatiment: 'Individuel',
        nombrePersonnes: 4,
        zoneClimatique: 'H1',
        temperatureInterieure: 35.0, // Température trop élevée
        surfaces: surfaces,
        coefficientSecurite: 1.1,
        coefficientSimultaneiteECS: 0.7,
        tempsRechauffement: 1.0,
        appareilsSanitaires: {'lavabo': 2, 'douche': 1, 'wc': 1},
        penteEUEV: 2.0,
        locaux: {
          'sejour': 1,
          'chambre': 3,
          'cuisine': 1,
          'salle_de_bain': 1,
          'wc': 1
        },
      );

      expect(resultat.containsKey('erreur'), isTrue);
      expect(resultat['erreur'], contains('Température intérieure'));
    });
  });
}
