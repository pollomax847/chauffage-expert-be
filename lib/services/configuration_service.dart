// services/configuration_service.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigurationService {
  // Marges
  static const String _keyMargeChauffage = 'marge_chauffage';
  static const String _keyMargeECS = 'marge_ecs';
  static const String _keyMargeVMC = 'marge_vmc';

  // Unités
  static const String _keyUniteTemperature = 'unite_temperature';
  static const String _keyUnitePuissance = 'unite_puissance';
  static const String _keyUniteDebit = 'unite_debit';

  // Apparence
  static const String _keyTheme = 'theme';
  static const String _keyTaillePolice = 'taille_police';
  static const String _keyLangue = 'langue';

  // Calculs
  static const String _keyPrecision = 'precision';
  static const String _keyFormatNombre = 'format_nombre';
  static const String _keyArrondi = 'arrondi';

  final SharedPreferences _prefs;

  ConfigurationService(this._prefs);

  // Getters avec valeurs par défaut
  // Marges
  double get margeChauffage => _prefs.getDouble(_keyMargeChauffage) ?? 1.2;
  double get margeECS => _prefs.getDouble(_keyMargeECS) ?? 1.1;
  double get margeVMC => _prefs.getDouble(_keyMargeVMC) ?? 1.15;

  // Unités
  String get uniteTemperature => _prefs.getString(_keyUniteTemperature) ?? '°C';
  String get unitePuissance => _prefs.getString(_keyUnitePuissance) ?? 'W';
  String get uniteDebit => _prefs.getString(_keyUniteDebit) ?? 'm³/h';

  // Apparence
  String get theme => _prefs.getString(_keyTheme) ?? 'system';
  double get taillePolice => _prefs.getDouble(_keyTaillePolice) ?? 1.0;
  String get langue => _prefs.getString(_keyLangue) ?? 'fr';

  // Calculs
  int get precision => _prefs.getInt(_keyPrecision) ?? 2;
  String get formatNombre => _prefs.getString(_keyFormatNombre) ?? 'point';
  bool get arrondi => _prefs.getBool(_keyArrondi) ?? true;

  // Setters
  // Marges
  Future<bool> setMargeChauffage(double valeur) =>
      _prefs.setDouble(_keyMargeChauffage, valeur);
  Future<bool> setMargeECS(double valeur) =>
      _prefs.setDouble(_keyMargeECS, valeur);
  Future<bool> setMargeVMC(double valeur) =>
      _prefs.setDouble(_keyMargeVMC, valeur);

  // Unités
  Future<bool> setUniteTemperature(String unite) =>
      _prefs.setString(_keyUniteTemperature, unite);
  Future<bool> setUnitePuissance(String unite) =>
      _prefs.setString(_keyUnitePuissance, unite);
  Future<bool> setUniteDebit(String unite) =>
      _prefs.setString(_keyUniteDebit, unite);

  // Apparence
  Future<bool> setTheme(String theme) => _prefs.setString(_keyTheme, theme);
  Future<bool> setTaillePolice(double taille) =>
      _prefs.setDouble(_keyTaillePolice, taille);
  Future<bool> setLangue(String langue) => _prefs.setString(_keyLangue, langue);

  // Calculs
  Future<bool> setPrecision(int precision) =>
      _prefs.setInt(_keyPrecision, precision);
  Future<bool> setFormatNombre(String format) =>
      _prefs.setString(_keyFormatNombre, format);
  Future<bool> setArrondi(bool arrondi) => _prefs.setBool(_keyArrondi, arrondi);

  // Liste des options disponibles
  static const List<String> themes = ['system', 'clair', 'sombre'];
  static const List<String> langues = ['fr', 'en'];
  static const List<String> formatsNombre = ['point', 'virgule'];
  static const List<double> taillesPolice = [0.8, 0.9, 1.0, 1.1, 1.2];
  static const List<int> precisions = [0, 1, 2, 3, 4];

  // Unités
  static const List<String> unitesTemperature = ['°C', '°F', 'K'];
  static const List<String> unitesPuissance = ['W', 'kW', 'BTU/h'];
  static const List<String> unitesDebit = ['m³/h', 'L/s', 'CFM'];
}
