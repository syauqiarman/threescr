import 'package:flutter_test/flutter_test.dart';
import 'package:threescr/palindrome/viewmodels/palindrome_viewmodel.dart';

void main() {
  group('PalindromeViewModel Tests', () {
    late PalindromeViewModel viewModel;

    setUp(() {
      viewModel = PalindromeViewModel();
    });

    tearDown(() {
      // Gunakan try-catch untuk menghindari error jika sudah di-dispose
      try {
        viewModel.dispose();
      } catch (e) {
        // Ignore error jika sudah di-dispose
      }
    });

    group('Initial State Tests', () {
      test('should have empty initial state', () {
        expect(viewModel.name, equals(''));
        expect(viewModel.sentence, equals(''));
        expect(viewModel.resultMessage, equals(''));
      });
    });

    group('updateName - Positive Cases', () {
      test('should update name correctly', () {
        bool wasNotified = false;
        viewModel.addListener(() => wasNotified = true);

        viewModel.updateName('John');

        expect(viewModel.name, equals('John'));
        expect(wasNotified, isTrue);
      });

      test('should update name with spaces', () {
        viewModel.updateName('John Doe');

        expect(viewModel.name, equals('John Doe'));
      });

      test('should update name with special characters', () {
        viewModel.updateName('John@123');

        expect(viewModel.name, equals('John@123'));
      });

      test('should handle multiple name updates', () {
        viewModel.updateName('John');
        expect(viewModel.name, equals('John'));

        viewModel.updateName('Jane');
        expect(viewModel.name, equals('Jane'));

        viewModel.updateName('Bob');
        expect(viewModel.name, equals('Bob'));
      });
    });

    group('updateName - Negative Cases', () {
      test('should handle empty name', () {
        viewModel.updateName('John');
        viewModel.updateName('');

        expect(viewModel.name, equals(''));
      });

      test('should handle whitespace-only name', () {
        viewModel.updateName('   ');

        expect(viewModel.name, equals('   '));
      });
    });

    group('updateSentence - Positive Cases', () {
      test('should update sentence correctly', () {
        bool wasNotified = false;
        viewModel.addListener(() => wasNotified = true);

        viewModel.updateSentence('racecar');

        expect(viewModel.sentence, equals('racecar'));
        expect(wasNotified, isTrue);
      });

      test('should update sentence with spaces', () {
        viewModel.updateSentence('kasur rusak');

        expect(viewModel.sentence, equals('kasur rusak'));
      });

      test('should handle multiple sentence updates', () {
        viewModel.updateSentence('racecar');
        expect(viewModel.sentence, equals('racecar'));

        viewModel.updateSentence('level');
        expect(viewModel.sentence, equals('level'));

        viewModel.updateSentence('hello');
        expect(viewModel.sentence, equals('hello'));
      });
    });

    group('updateSentence - Negative Cases', () {
      test('should handle empty sentence', () {
        viewModel.updateSentence('racecar');
        viewModel.updateSentence('');

        expect(viewModel.sentence, equals(''));
      });

      test('should handle whitespace-only sentence', () {
        viewModel.updateSentence('   ');

        expect(viewModel.sentence, equals('   '));
      });
    });

    group('checkPalindrome - Positive Cases', () {
      test('should check palindrome correctly for valid palindromes', () {
        bool wasNotified = false;
        viewModel.addListener(() => wasNotified = true);

        viewModel.updateSentence('racecar');
        viewModel.checkPalindrome();

        expect(viewModel.resultMessage, equals('isPalindrome'));
        expect(wasNotified, isTrue);
      });

      test('should check palindrome correctly for palindromes from requirements', () {
        final testCases = [
          'kasur rusak',
          'step on no pets',
          'put it up',
        ];

        for (final testCase in testCases) {
          viewModel.updateSentence(testCase);
          viewModel.checkPalindrome();

          expect(viewModel.resultMessage, equals('isPalindrome'),
              reason: '"$testCase" should be a palindrome');
        }
      });

      test('should check palindrome correctly for non-palindromes', () {
        viewModel.updateSentence('suitmedia');
        viewModel.checkPalindrome();

        expect(viewModel.resultMessage, equals('not palindrome'));
      });

      test('should handle case insensitive palindromes', () {
        viewModel.updateSentence('Madam');
        viewModel.checkPalindrome();

        expect(viewModel.resultMessage, equals('isPalindrome'));
      });
    });

    group('checkPalindrome - Negative Cases', () {
      test('should return error message for empty sentence', () {
        viewModel.updateSentence('');
        viewModel.checkPalindrome();

        expect(viewModel.resultMessage, equals('Please enter a sentence to check'));
      });

      test('should return error message for whitespace-only sentence', () {
        viewModel.updateSentence('   ');
        viewModel.checkPalindrome();

        expect(viewModel.resultMessage, equals('Please enter a sentence to check'));
      });

      test('should handle non-palindromes correctly', () {
        final testCases = [
          'hello',
          'world',
          'flutter',
          'programming',
          'race a car',
        ];

        for (final testCase in testCases) {
          viewModel.updateSentence(testCase);
          viewModel.checkPalindrome();

          expect(viewModel.resultMessage, equals('not palindrome'),
              reason: '"$testCase" should not be a palindrome');
        }
      });
    });

    group('State Management Tests', () {
      test('should notify listeners when name changes', () {
        int notificationCount = 0;
        viewModel.addListener(() => notificationCount++);

        viewModel.updateName('John');
        viewModel.updateName('Jane');

        expect(notificationCount, equals(2));
      });

      test('should notify listeners when sentence changes', () {
        int notificationCount = 0;
        viewModel.addListener(() => notificationCount++);

        viewModel.updateSentence('racecar');
        viewModel.updateSentence('level');

        expect(notificationCount, equals(2));
      });

      test('should notify listeners when checking palindrome', () {
        int notificationCount = 0;
        viewModel.addListener(() => notificationCount++);

        viewModel.updateSentence('racecar');
        viewModel.checkPalindrome();

        expect(notificationCount, equals(2)); // 1 for updateSentence, 1 for checkPalindrome
      });

      test('should handle disposal properly', () {
        // Buat viewModel baru untuk test ini agar tidak bentrok dengan tearDown
        final testViewModel = PalindromeViewModel();
        
        bool wasNotified = false;
        testViewModel.addListener(() => wasNotified = true);

        // Test sebelum dispose
        testViewModel.updateName('John');
        expect(wasNotified, isTrue);

        // Reset notification flag
        wasNotified = false;

        // Dispose viewModel
        testViewModel.dispose();

        // Test bahwa viewModel sudah ter-dispose
        expect(() => testViewModel.updateName('Jane'), throwsFlutterError);
      });
    });

    group('Edge Cases', () {
      test('should handle rapid consecutive updates', () {
        for (int i = 0; i < 100; i++) {
          viewModel.updateName('Name$i');
          viewModel.updateSentence('Sentence$i');
        }

        expect(viewModel.name, equals('Name99'));
        expect(viewModel.sentence, equals('Sentence99'));
      });

      test('should handle very long inputs', () {
        String longName = 'A' * 1000;
        String longSentence = '${'a' * 1000}b${'a' * 1000}';

        viewModel.updateName(longName);
        viewModel.updateSentence(longSentence);

        expect(viewModel.name, equals(longName));
        expect(viewModel.sentence, equals(longSentence));
      });

      test('should handle special characters in inputs', () {
        viewModel.updateName('John@123!');
        viewModel.updateSentence('Hello, World!');

        expect(viewModel.name, equals('John@123!'));
        expect(viewModel.sentence, equals('Hello, World!'));
      });
    });
  });
}