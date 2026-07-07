import 'package:flutter_test/flutter_test.dart';
import 'package:petit_bac/services/wikipedia_service.dart';

void main() {
  group('WikipediaService Car Model Validation Tests', () {
    test('isValidWord - validates "Tundra" for VOITURES starting with T', () async {
      final isValid = await WikipediaService.isValidWord('Tundra', 'T', category: 'VOITURES');
      expect(isValid, isTrue);
    });

    test('isValidWord - validates "Swift" for VOITURES starting with S', () async {
      final isValid = await WikipediaService.isValidWord('Swift', 'S', category: 'VOITURES');
      expect(isValid, isTrue);
    });

    test('isValidWord - rejects incorrect starting letter for "Tundra"', () async {
      final isValid = await WikipediaService.isValidWord('Tundra', 'M', category: 'VOITURES');
      expect(isValid, isFalse);
    });

    test('isValidWord - rejects invalid/made-up word', () async {
      final isValid = await WikipediaService.isValidWord('Xyzyzyqwe', 'X', category: 'VOITURES');
      expect(isValid, isFalse);
    });
  });
}
