import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threescr/palindrome/views/palindrome_view.dart';

void main() {
  group('PalindromeView Tests', () {
    
    group('UI Rendering', () {
      testWidgets('should render all essential UI elements', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        expect(find.byType(TextField), findsNWidgets(2));
        expect(find.byType(ElevatedButton), findsNWidgets(2));
        expect(find.byIcon(Icons.person_add_alt_1), findsOneWidget);
        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Palindrome'), findsOneWidget);
        expect(find.text('CHECK'), findsOneWidget);
        expect(find.text('NEXT'), findsOneWidget);
      });
    });

    group('Text Input - Positive Cases', () {
      testWidgets('should accept valid text input', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final nameField = find.byType(TextField).first;
        final palindromeField = find.byType(TextField).at(1);
        
        await tester.enterText(nameField, 'John Doe');
        await tester.enterText(palindromeField, 'racecar');
        await tester.pump();

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('racecar'), findsOneWidget);
      });

      testWidgets('should handle special characters and spaces', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final palindromeField = find.byType(TextField).at(1);
        
        await tester.enterText(palindromeField, 'kasur rusak');
        await tester.pump();

        expect(find.text('kasur rusak'), findsOneWidget);
      });
    });

    group('Text Input - Negative Cases', () {
      testWidgets('should handle empty input gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final nameField = find.byType(TextField).first;
        final palindromeField = find.byType(TextField).at(1);

        await tester.enterText(nameField, '');
        await tester.enterText(palindromeField, '');
        await tester.pump();

        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle whitespace-only input', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final palindromeField = find.byType(TextField).at(1);

        await tester.enterText(palindromeField, '   ');
        await tester.pump();

        expect(find.text('   '), findsOneWidget);
      });
    });

    group('CHECK Button - Positive Cases', () {
      testWidgets('should show isPalindrome dialog for valid palindromes', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final palindromeField = find.byType(TextField).at(1);
        final checkButton = find.text('CHECK');

        await tester.enterText(palindromeField, 'racecar');
        await tester.tap(checkButton);
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Result'), findsOneWidget);
        expect(find.text('isPalindrome'), findsOneWidget);
      });

      testWidgets('should show not palindrome dialog for non-palindromes', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final palindromeField = find.byType(TextField).at(1);
        final checkButton = find.text('CHECK');

        await tester.enterText(palindromeField, 'hello');
        await tester.tap(checkButton);
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('not palindrome'), findsOneWidget);
      });

      testWidgets('should close dialog when OK is tapped', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final palindromeField = find.byType(TextField).at(1);
        final checkButton = find.text('CHECK');

        await tester.enterText(palindromeField, 'racecar');
        await tester.tap(checkButton);
        await tester.pumpAndSettle();

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    group('CHECK Button - Negative Cases', () {
      testWidgets('should show error dialog for empty input', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final checkButton = find.text('CHECK');

        await tester.tap(checkButton);
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Please enter a sentence to check'), findsOneWidget);
      });

      testWidgets('should handle multiple button presses without crashing', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final palindromeField = find.byType(TextField).at(1);
        final checkButton = find.text('CHECK');

        await tester.enterText(palindromeField, 'racecar');
        await tester.pumpAndSettle();

        // First tap - should work normally
        await tester.tap(checkButton);
        await tester.pumpAndSettle();

        // Verify dialog appeared
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('isPalindrome'), findsOneWidget);

        // Close the dialog first
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Now test second tap - should not crash
        await tester.tap(checkButton, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Should show dialog again
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('isPalindrome'), findsOneWidget);
      });
    });

    group('NEXT Button - Positive Cases', () {
      testWidgets('should show snackbar when NEXT button is tapped', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final nextButton = find.text('NEXT');

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('You have pressed the Next button'), findsOneWidget);
      });
    });

    group('NEXT Button - Negative Cases', () {
      testWidgets('should handle rapid button presses without crashing', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final nextButton = find.text('NEXT');

        // First tap
        await tester.tap(nextButton);
        await tester.pump();

        // Rapid taps with delay and warning suppression
        for (int i = 0; i < 3; i++) {
          await tester.tap(nextButton, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 50));
        }
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(SnackBar), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('should handle complete flow - positive case', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final nameField = find.byType(TextField).first;
        final palindromeField = find.byType(TextField).at(1);
        final checkButton = find.text('CHECK');
        final nextButton = find.text('NEXT');

        // Enter valid data
        await tester.enterText(nameField, 'John');
        await tester.enterText(palindromeField, 'racecar');

        // Check palindrome
        await tester.tap(checkButton);
        await tester.pumpAndSettle();
        expect(find.text('isPalindrome'), findsOneWidget);

        // Close dialog
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Tap next
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('should handle complete flow - negative case', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final checkButton = find.text('CHECK');

        // Try to check without input
        await tester.tap(checkButton);
        await tester.pumpAndSettle();
        
        expect(find.text('Please enter a sentence to check'), findsOneWidget);
      });
    });
  });
}