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
      testWidgets('should navigate to welcome screen when name is provided', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const PalindromeView(),
            routes: {
              '/welcome': (context) => const Scaffold(
                body: Text('Welcome Screen'),
              ),
            },
          ),
        );

        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');

        // Enter name first
        await tester.enterText(nameField, 'John Doe');
        await tester.pump();

        // Tap NEXT button
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        // Should navigate to welcome screen
        expect(find.text('Welcome Screen'), findsOneWidget);
      });

      testWidgets('should show snackbar when NEXT button is tapped without name', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final nextButton = find.text('NEXT');

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Please enter your name first'), findsOneWidget);
      });

      testWidgets('should navigate with trimmed name containing spaces', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const PalindromeView(),
            routes: {
              '/welcome': (context) {
                final args = ModalRoute.of(context)?.settings.arguments as String?;
                return Scaffold(
                  body: Text('Welcome: $args'),
                );
              },
            },
          ),
        );

        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');

        // Enter name with leading/trailing spaces
        await tester.enterText(nameField, '  John Doe  ');
        await tester.pump();

        // Tap NEXT button
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        // Should navigate with trimmed name
        expect(find.text('Welcome: John Doe'), findsOneWidget);
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

      testWidgets('should handle navigation error gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const PalindromeView(),
            // No routes defined - should handle navigation error
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Text('Route not found'),
                ),
              );
            },
          ),
        );

        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');

        // Enter name first
        await tester.enterText(nameField, 'John Doe');
        await tester.pump();

        // Tap NEXT button - should navigate to unknown route handler
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        // Should show error handling page
        expect(find.text('Route not found'), findsOneWidget);
      });

      testWidgets('should show snackbar for whitespace-only name', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');

        // Enter whitespace-only name
        await tester.enterText(nameField, '   ');
        await tester.pump();

        // Tap NEXT button
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        // Should show snackbar because trimmed result is empty
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Please enter your name first'), findsOneWidget);
      });
    });

    group('NEXT Button - Edge Cases', () {
      testWidgets('should handle special characters in name during navigation', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const PalindromeView(),
            routes: {
              '/welcome': (context) {
                final args = ModalRoute.of(context)?.settings.arguments as String?;
                return Scaffold(
                  body: Text('Welcome: $args'),
                );
              },
            },
          ),
        );

        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');

        // Enter name with special characters
        await tester.enterText(nameField, 'João da Silva @123!');
        await tester.pump();

        // Tap NEXT button
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        // Should navigate with special characters preserved
        expect(find.text('Welcome: João da Silva @123!'), findsOneWidget);
      });

      testWidgets('should handle very long name during navigation', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const PalindromeView(),
            routes: {
              '/welcome': (context) {
                final args = ModalRoute.of(context)?.settings.arguments as String?;
                return Scaffold(
                  body: Text('Welcome: ${args?.length} chars'),
                );
              },
            },
          ),
        );

        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');

        // Enter very long name
        final longName = 'A' * 100;
        await tester.enterText(nameField, longName);
        await tester.pump();

        // Tap NEXT button
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        // Should navigate with long name
        expect(find.text('Welcome: 100 chars'), findsOneWidget);
      });

      testWidgets('should handle navigation with multiple SnackBars', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final nextButton = find.text('NEXT');

        // First tap - should show first snackbar
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Please enter your name first'), findsOneWidget);

        // Wait for snackbar to dismiss
        await tester.pump(const Duration(seconds: 3));

        // Second tap - should show another snackbar
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Please enter your name first'), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('should handle complete flow - positive case', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const PalindromeView(),
            routes: {
              '/welcome': (context) => const Scaffold(
                body: Text('Welcome Screen'),
              ),
            },
          ),
        );

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

        // Tap next - should navigate to welcome screen
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        expect(find.text('Welcome Screen'), findsOneWidget);
      });

      testWidgets('should handle complete flow - negative case', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final checkButton = find.text('CHECK');

        // Try to check without input
        await tester.tap(checkButton);
        await tester.pumpAndSettle();
        
        expect(find.text('Please enter a sentence to check'), findsOneWidget);
      });

      testWidgets('should handle NEXT button without name', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: PalindromeView()));

        final nextButton = find.text('NEXT');

        // Try to tap NEXT without entering name
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        
        expect(find.text('Please enter your name first'), findsOneWidget);
      });
    });
  });
}