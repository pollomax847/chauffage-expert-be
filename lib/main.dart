// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_page.dart';
import 'pages/dimensionnement_page.dart';
import 'pages/be_page.dart';
import 'pages/reglementation_page.dart';
import 'pages/export_page.dart';
import 'pages/gestion_donnees_page.dart';
import 'pages/3cep_page.dart';
import 'pages/calcul_page.dart';
import 'pages/chauffage_page.dart';
import 'pages/collectif_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/departitions_page.dart';
import 'pages/ecs_page.dart';
import 'pages/euev_page.dart';
import 'pages/hydraulique_page.dart';
import 'pages/rapport_page.dart';
import 'pages/rapport_thermique_page.dart';
import 'screens/radiateurs_page.dart';
import 'theme/app_theme.dart';
import 'di/app_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppModule.init();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/dimensionnement',
      builder: (context, state) => const DimensionnementPage(),
    ),
    GoRoute(
      path: '/bureau-etude',
      builder: (context, state) => const BEPage(),
    ),
    GoRoute(
      path: '/reglementation',
      builder: (context, state) => const ReglementationPage(),
    ),
    GoRoute(
      path: '/export',
      builder: (context, state) => const ExportPage(
        typeExport: 'pdf',
        titre: 'Exportation des données',
      ),
    ),
    GoRoute(
      path: '/gestion-donnees',
      builder: (context, state) => const GestionDonneesPage(),
    ),
    GoRoute(
      path: '/radiateurs',
      builder: (context, state) => const RadiateursPage(),
    ),
    GoRoute(
      path: '/3cep',
      builder: (context, state) => const TroisCEPPage(),
    ),
    GoRoute(
      path: '/calcul',
      builder: (context, state) => const CalculPage(),
    ),
    GoRoute(
      path: '/chauffage',
      builder: (context, state) => const ChauffagePage(),
    ),
    GoRoute(
      path: '/collectif',
      builder: (context, state) => const CollectifPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/deperditions',
      builder: (context, state) => const DepartitionsPage(),
    ),
    GoRoute(
      path: '/ecs',
      builder: (context, state) => const ECSPage(),
    ),
    GoRoute(
      path: '/euev',
      builder: (context, state) => const EUEVPage(),
    ),
    GoRoute(
      path: '/hydraulique',
      builder: (context, state) => const HydrauliquePage(),
    ),
    GoRoute(
      path: '/rapport',
      builder: (context, state) => const RapportPage(),
    ),
    GoRoute(
      path: '/rapport-thermique',
      builder: (context, state) => const RapportThermiquePage(),
    ),
  ],
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Chauffage Expert',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
