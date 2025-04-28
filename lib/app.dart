import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/client_screen.dart';
import 'screens/pdf_screen.dart';

class ChauffageExpertApp extends ConsumerWidget {
  const ChauffageExpertApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/clients',
          builder: (context, state) => const ClientScreen(),
        ),
        GoRoute(
          path: '/pdf',
          builder: (context, state) => const PdfScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Chauffage Expert BE',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
