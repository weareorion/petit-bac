import 'package:flutter_test/flutter_test.dart';
import 'package:petit_bac/utils/string_utils.dart';

void main() {
  group('Tests de normalisation des accents et caractères spéciaux', () {
    test('removeAccents - supprime les accents minuscules et majuscules', () {
      expect(StringUtils.removeAccents('éléphant'), equals('elephant'));
      expect(StringUtils.removeAccents('ÉLÉPHANT'), equals('ELEPHANT'));
      expect(StringUtils.removeAccents('àâäçéèêëîïôöùûüÿœæ'), equals('aaaceeeeiioouuuyoeae'));
      expect(StringUtils.removeAccents('ÀÂÄÇÉÈÊËÎÏÔÖÙÛÜŸŒÆ'), equals('AAACEEEEIIOOUUUYOEAE'));
    });

    test('stripLeadingArticles - enlève les articles élidés (l\', d\')', () {
      expect(StringUtils.stripLeadingArticles("l'Italie"), equals('Italie'));
      expect(StringUtils.stripLeadingArticles("d'Espagne"), equals('Espagne'));
      expect(StringUtils.stripLeadingArticles("L'Italie"), equals('Italie'));
      expect(StringUtils.stripLeadingArticles("D'Espagne"), equals('Espagne'));
    });

    test('stripLeadingArticles - enlève les articles définis/indéfinis (le, la, les, un, une, des)', () {
      expect(StringUtils.stripLeadingArticles('le chat'), equals('chat'));
      expect(StringUtils.stripLeadingArticles('la pomme'), equals('pomme'));
      expect(StringUtils.stripLeadingArticles('les fruits'), equals('fruits'));
      expect(StringUtils.stripLeadingArticles('un chien'), equals('chien'));
      expect(StringUtils.stripLeadingArticles('une table'), equals('table'));
      expect(StringUtils.stripLeadingArticles('des bananes'), equals('bananes'));
    });

    test('stripLeadingArticles - conserve les mots qui commencent par des lettres d\'articles sans espace', () {
      expect(StringUtils.stripLeadingArticles('lettre'), equals('lettre'));
      expect(StringUtils.stripLeadingArticles('lave'), equals('lave'));
      expect(StringUtils.stripLeadingArticles('uni'), equals('uni'));
    });

    test('normalizeForComparison - normalise les espaces, tirets et majuscules', () {
      expect(StringUtils.normalizeForComparison('Saint-Tropez'), equals('sainttropez'));
      expect(StringUtils.normalizeForComparison('saint tropez'), equals('sainttropez'));
      expect(StringUtils.normalizeForComparison('Éléphant'), equals('elephant'));
      expect(StringUtils.normalizeForComparison('l\'éléphant'), equals('lelephant'));
    });
  });
}
