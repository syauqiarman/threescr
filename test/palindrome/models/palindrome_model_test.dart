import 'package:flutter_test/flutter_test.dart';
import 'package:threescr/palindrome/models/palindrome_model.dart';

void main() {
  group('PalindromeModel Tests', () {
    group('Constructor Tests', () {
      test('should create PalindromeModel with all required fields', () {
        const model = PalindromeModel(
          name: 'John',
          sentence: 'racecar',
          isPalindrome: true,
        );

        expect(model.name, equals('John'));
        expect(model.sentence, equals('racecar'));
        expect(model.isPalindrome, isTrue);
      });

      test('should create const PalindromeModel', () {
        const model1 = PalindromeModel(
          name: 'John',
          sentence: 'racecar',
          isPalindrome: true,
        );

        const model2 = PalindromeModel(
          name: 'John',
          sentence: 'racecar',
          isPalindrome: true,
        );

        expect(identical(model1, model2), isTrue);
      });
    });

    group('Factory Constructor Tests', () {
      test('should create empty PalindromeModel with default values', () {
        final model = PalindromeModel.empty();

        expect(model.name, equals(''));
        expect(model.sentence, equals(''));
        expect(model.isPalindrome, isFalse);
      });

      test('should create const empty PalindromeModel', () {
        final model1 = PalindromeModel.empty();
        final model2 = PalindromeModel.empty();

        expect(identical(model1, model2), isTrue);
      });
    });

    group('CopyWith Tests - Positive Cases', () {
      test('should copy with new name', () {
        const original = PalindromeModel(
          name: 'John',
          sentence: 'racecar',
          isPalindrome: true,
        );

        final copied = original.copyWith(name: 'Jane');

        expect(copied.name, equals('Jane'));
        expect(copied.sentence, equals('racecar'));
        expect(copied.isPalindrome, isTrue);
      });

      test('should copy with new sentence', () {
        const original = PalindromeModel(
          name: 'John',
          sentence: 'racecar',
          isPalindrome: true,
        );

        final copied = original.copyWith(sentence: 'level');

        expect(copied.name, equals('John'));
        expect(copied.sentence, equals('level'));
        expect(copied.isPalindrome, isTrue);
      });

      test('should copy with new isPalindrome', () {
        const original = PalindromeModel(
          name: 'John',
          sentence: 'racecar',
          isPalindrome: true,
        );

        final copied = original.copyWith(isPalindrome: false);

        expect(copied.name, equals('John'));
        expect(copied.sentence, equals('racecar'));
        expect(copied.isPalindrome, isFalse);
      });

      test('should copy with all new values', () {
        const original = PalindromeModel(
          name: 'John',
          sentence: 'racecar',
          isPalindrome: true,
        );

        final copied = original.copyWith(
          name: 'Jane',
          sentence: 'hello',
          isPalindrome: false,
        );

        expect(copied.name, equals('Jane'));
        expect(copied.sentence, equals('hello'));
        expect(copied.isPalindrome, isFalse);
      });
    });

    group('CopyWith Tests - Negative Cases', () {
      test('should keep original values when copyWith with null', () {
        const original = PalindromeModel(
          name: 'John',
          sentence: 'racecar',
          isPalindrome: true,
        );

        final copied = original.copyWith();

        expect(copied.name, equals('John'));
        expect(copied.sentence, equals('racecar'));
        expect(copied.isPalindrome, isTrue);
      });

      test('should keep original values when copyWith with explicit null', () {
        const original = PalindromeModel(
          name: 'John',
          sentence: 'racecar',
          isPalindrome: true,
        );

        final copied = original.copyWith(
          name: null,
          sentence: null,
          isPalindrome: null,
        );

        expect(copied.name, equals('John'));
        expect(copied.sentence, equals('racecar'));
        expect(copied.isPalindrome, isTrue);
      });
    });

    group('Immutability Tests', () {
      test('should not modify original when copying', () {
        const original = PalindromeModel(
          name: 'John',
          sentence: 'racecar',
          isPalindrome: true,
        );

        final copied = original.copyWith(name: 'Jane');

        // Original should remain unchanged
        expect(original.name, equals('John'));
        expect(original.sentence, equals('racecar'));
        expect(original.isPalindrome, isTrue);

        // Copied should have new values
        expect(copied.name, equals('Jane'));
        expect(copied.sentence, equals('racecar'));
        expect(copied.isPalindrome, isTrue);
      });
    });

    group('Edge Cases', () {
      test('should handle empty strings', () {
        const model = PalindromeModel(
          name: '',
          sentence: '',
          isPalindrome: false,
        );

        expect(model.name, equals(''));
        expect(model.sentence, equals(''));
        expect(model.isPalindrome, isFalse);
      });

      test('should handle special characters', () {
        const model = PalindromeModel(
          name: 'John@123',
          sentence: 'race a car!',
          isPalindrome: false,
        );

        expect(model.name, equals('John@123'));
        expect(model.sentence, equals('race a car!'));
        expect(model.isPalindrome, isFalse);
      });
    });
  });
}