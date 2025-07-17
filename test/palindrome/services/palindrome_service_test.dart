import 'package:flutter_test/flutter_test.dart';
import 'package:threescr/palindrome/services/palindrome_service.dart';

void main() {
  group('PalindromeService Tests', () {
    group('isPalindrome - Positive Cases', () {
      test('should return true for valid palindromes from requirements', () {
        expect(PalindromeService.isPalindrome('kasur rusak'), isTrue);
        expect(PalindromeService.isPalindrome('step on no pets'), isTrue);
        expect(PalindromeService.isPalindrome('put it up'), isTrue);
      });

      test('should return true for simple palindromes', () {
        expect(PalindromeService.isPalindrome('racecar'), isTrue);
        expect(PalindromeService.isPalindrome('level'), isTrue);
        expect(PalindromeService.isPalindrome('noon'), isTrue);
        expect(PalindromeService.isPalindrome('radar'), isTrue);
      });

      test('should return true for single character', () {
        expect(PalindromeService.isPalindrome('a'), isTrue);
        expect(PalindromeService.isPalindrome('A'), isTrue);
        expect(PalindromeService.isPalindrome('1'), isTrue);
      });

      test('should handle case insensitive palindromes', () {
        expect(PalindromeService.isPalindrome('Madam'), isTrue);
        expect(PalindromeService.isPalindrome('RACECAR'), isTrue);
        expect(PalindromeService.isPalindrome('Level'), isTrue);
      });

      test('should handle mixed case palindromes', () {
        expect(PalindromeService.isPalindrome('RaceCar'), isTrue);
        expect(PalindromeService.isPalindrome('mAdAm'), isTrue);
      });
    });

    group('isPalindrome - Negative Cases', () {
      test('should return false for non-palindromes from requirements', () {
        expect(PalindromeService.isPalindrome('suitmedia'), isFalse);
      });

      test('should return false for common non-palindromes', () {
        expect(PalindromeService.isPalindrome('hello'), isFalse);
        expect(PalindromeService.isPalindrome('world'), isFalse);
        expect(PalindromeService.isPalindrome('flutter'), isFalse);
        expect(PalindromeService.isPalindrome('programming'), isFalse);
        expect(PalindromeService.isPalindrome('race a car'), isFalse);
      });

      test('should return false for empty string', () {
        expect(PalindromeService.isPalindrome(''), isFalse);
      });

      test('should return false for words with different characters', () {
        expect(PalindromeService.isPalindrome('abc'), isFalse);
        expect(PalindromeService.isPalindrome('test'), isFalse);
        expect(PalindromeService.isPalindrome('palindrome'), isFalse);
      });
    });

    group('validateName - Positive Cases', () {
      test('should return null for valid names', () {
        expect(PalindromeService.validateName('John'), isNull);
        expect(PalindromeService.validateName('Jane Doe'), isNull);
        expect(PalindromeService.validateName('A'), isNull);
        expect(PalindromeService.validateName('John123'), isNull);
        expect(PalindromeService.validateName('Mary-Jane'), isNull);
      });

      test('should return null for names with spaces', () {
        expect(PalindromeService.validateName('John Doe'), isNull);
        expect(PalindromeService.validateName('Jane Smith Wilson'), isNull);
      });
    });

    group('validateName - Negative Cases', () {
      test('should return error message for empty name', () {
        expect(PalindromeService.validateName(''), 
            equals('Please enter your name'));
      });

      test('should return error message for whitespace-only name', () {
        expect(PalindromeService.validateName('   '), 
            equals('Please enter your name'));
        expect(PalindromeService.validateName('\t'), 
            equals('Please enter your name'));
        expect(PalindromeService.validateName('\n'), 
            equals('Please enter your name'));
      });
    });

    group('validateSentence - Positive Cases', () {
      test('should return null for valid sentences', () {
        expect(PalindromeService.validateSentence('racecar'), isNull);
        expect(PalindromeService.validateSentence('hello world'), isNull);
        expect(PalindromeService.validateSentence('a'), isNull);
        expect(PalindromeService.validateSentence('kasur rusak'), isNull);
      });

      test('should return null for sentences with special characters', () {
        expect(PalindromeService.validateSentence('Hello, World!'), isNull);
        expect(PalindromeService.validateSentence('Test@123'), isNull);
      });
    });

    group('validateSentence - Negative Cases', () {
      test('should return error message for empty sentence', () {
        expect(PalindromeService.validateSentence(''), 
            equals('Please enter a sentence to check'));
      });

      test('should return error message for whitespace-only sentence', () {
        expect(PalindromeService.validateSentence('   '), 
            equals('Please enter a sentence to check'));
        expect(PalindromeService.validateSentence('\t\n'), 
            equals('Please enter a sentence to check'));
      });
    });

    group('processPalindromeCheck - Positive Cases', () {
      test('should return isPalindrome message for palindromes', () {
        expect(PalindromeService.processPalindromeCheck('racecar'), 
            equals('isPalindrome'));
        expect(PalindromeService.processPalindromeCheck('level'), 
            equals('isPalindrome'));
        expect(PalindromeService.processPalindromeCheck('kasur rusak'), 
            equals('isPalindrome'));
      });

      test('should return not palindrome message for non-palindromes', () {
        expect(PalindromeService.processPalindromeCheck('suitmedia'), 
            equals('not palindrome'));
        expect(PalindromeService.processPalindromeCheck('hello'), 
            equals('not palindrome'));
        expect(PalindromeService.processPalindromeCheck('flutter'), 
            equals('not palindrome'));
      });
    });

    group('processPalindromeCheck - Negative Cases', () {
      test('should return error message for empty input', () {
        expect(PalindromeService.processPalindromeCheck(''), 
            equals('Please enter a sentence to check'));
      });

      test('should return error message for whitespace-only input', () {
        expect(PalindromeService.processPalindromeCheck('   '), 
            equals('Please enter a sentence to check'));
      });
    });

    group('getResultMessage - Positive Cases', () {
      test('should return isPalindrome message for palindromes', () {
        expect(PalindromeService.getResultMessage('racecar'), 
            equals('isPalindrome'));
        expect(PalindromeService.getResultMessage('level'), 
            equals('isPalindrome'));
      });

      test('should return not palindrome message for non-palindromes', () {
        expect(PalindromeService.getResultMessage('suitmedia'), 
            equals('not palindrome'));
        expect(PalindromeService.getResultMessage('hello'), 
            equals('not palindrome'));
      });
    });

    group('getResultMessage - Negative Cases', () {
      test('should return error message for empty input', () {
        expect(PalindromeService.getResultMessage(''), 
            equals('Please enter a sentence to check'));
      });

      test('should return error message for whitespace-only input', () {
        expect(PalindromeService.getResultMessage('   '), 
            equals('Please enter a sentence to check'));
      });
    });

    group('Edge Cases', () {
      test('should handle numbers as palindromes', () {
        expect(PalindromeService.isPalindrome('121'), isTrue);
        expect(PalindromeService.isPalindrome('1221'), isTrue);
        expect(PalindromeService.isPalindrome('123'), isFalse);
      });

      test('should handle mixed alphanumeric', () {
        expect(PalindromeService.isPalindrome('a1a'), isTrue);
        expect(PalindromeService.isPalindrome('1a1'), isTrue);
        expect(PalindromeService.isPalindrome('a1b'), isFalse);
      });

      test('should handle very long palindromes', () {
        String longPalindrome = '${'a' * 1000}b${'a' * 1000}';
        expect(PalindromeService.isPalindrome(longPalindrome), isTrue);
      });
    });
  });
}