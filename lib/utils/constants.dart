class AppConstants {
  // Application
  static const String appName = "Chauffage Expert BE";
  static const String appVersion = "1.0.0";

  // API
  static const String apiUrl = String.fromEnvironment('API_URL',
      defaultValue: 'https://api.chauffage-expert.com');
  static const String apiKey =
      String.fromEnvironment('API_KEY', defaultValue: '');

  // Services
  static const String pdfServiceUrl =
      String.fromEnvironment('PDF_SERVICE_URL', defaultValue: '');
  static const String calculServiceUrl =
      String.fromEnvironment('CALCUL_SERVICE_URL', defaultValue: '');

  // Préférences
  static const String prefLanguage = 'language';
  static const String prefTheme = 'theme';
  static const String prefMarginChauffage = 'margin_chauffage';
  static const String prefMarginECS = 'margin_ecs';
  static const String prefMarginVMC = 'margin_vmc';
  static const String prefUnitTemp = 'unit_temperature';
  static const String prefUnitPuissance = 'unit_puissance';
  static const String prefUnitDebit = 'unit_debit';
}
