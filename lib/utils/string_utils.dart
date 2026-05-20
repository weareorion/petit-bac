class StringUtils {
  /// Enlève tous les accents d'un texte français (y compris les ligatures comme œ/æ).
  static String removeAccents(String text) {
    const withDia = 'ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßŸàáâãäåçèéêëìíîïðñòóôõöøùúûüýþÿ';
    const sansDia = 'AAAAAACEEEEIIIIDNOOOOOOUUUUYbBYaaaaaaceeeeiiiidnoooooouuuuyby';
    String result = text;
    for (int i = 0; i < withDia.length; i++) {
      result = result.replaceAll(withDia[i], sansDia[i]);
    }
    result = result.replaceAll('œ', 'oe').replaceAll('Œ', 'OE');
    result = result.replaceAll('æ', 'ae').replaceAll('Æ', 'AE');
    return result;
  }

  /// Supprime les articles définis, indéfinis ou élidés de tête (ex: l', d', le, la, un, une).
  static String stripLeadingArticles(String text) {
    String cleaned = text.trim();
    // Supprimer les articles élidés de type l', d', L', D'
    cleaned = cleaned.replaceFirst(RegExp(r"^[ldLD]'"), '');
    // Supprimer les articles "le ", "la ", "les ", "un ", "une ", "des " (insensible à la casse)
    cleaned = cleaned.replaceFirst(RegExp(r"^(le|la|les|un|une|des)\s+", caseSensitive: false), '');
    return cleaned.trim();
  }

  /// Normalise complètement une chaîne pour comparaison (minuscule, sans accent, sans ponctuation).
  static String normalizeForComparison(String text) {
    String normalized = removeAccents(text).toLowerCase();
    // Conserver uniquement les caractères alphanumériques
    normalized = normalized.replaceAll(RegExp(r'[^a-z0-9]'), '');
    return normalized;
  }
}
