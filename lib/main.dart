// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'pages/home_page.dart';
import 'pages/dimensionnement_page.dart';
import 'pages/be_page.dart';
import 'pages/reglementation_page.dart';
import 'pages/export_page.dart';
import 'pages/gestion_donnees_page.dart';
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
