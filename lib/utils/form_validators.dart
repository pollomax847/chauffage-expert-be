class FormValidators {
  // Validateur pour les champs numériques positifs
  static String? positiveNumber(String? value, {bool allowZero = false}) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Veuillez entrer un nombre valide';
    }

    if (allowZero ? number < 0 : number <= 0) {
      return 'La valeur doit être ${allowZero ? 'positive ou nulle' : 'positive'}';
    }

    return null;
  }

  // Validateur pour les champs numériques avec plage
  static String? numberInRange(String? value, double min, double max) {
    final baseValidation = positiveNumber(value);
    if (baseValidation != null) {
      return baseValidation;
    }

    final number = double.parse(value!);
    if (number < min || number > max) {
      return 'La valeur doit être entre $min et $max';
    }

    return null;
  }

  // Validateur pour le texte non vide
  static String? nonEmptyText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire';
    }
    return null;
  }
}
