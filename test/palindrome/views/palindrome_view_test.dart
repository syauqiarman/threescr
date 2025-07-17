import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:threescr/palindrome/views/palindrome_view.dart';
import 'package:threescr/palindrome/viewmodels/palindrome_viewmodel.dart';

void main() {
  group('PalindromeView Tests', () {
    
    Widget createTestWidget({Widget? child}) {
      return MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => PalindromeViewModel(),
          child: child ?? const PalindromeView(),
        ),
      );
    }

    Widget createTestWidgetWithRoutes() {
      return MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => PalindromeViewModel(),
          child: const PalindromeView(),
        ),
        routes: {
          '/welcome': (context) => const Scaffold(
            body: Text('Welcome Screen'),
          ),
        },
      );
    }

    group('UI Rendering', () {
      testWidgets('should render all essential UI elements', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(TextFormField), findsNWidgets(2));
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
        await tester.pumpWidget(createTestWidget());

        final nameField = find.byType(TextFormField).first;
        final palindromeField = find.byType(TextFormField).at(1);
        
        await tester.enterText(nameField, 'John Doe');
        await tester.enterText(palindromeField, 'racecar');
        await tester.pump();

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('racecar'), findsOneWidget);
      });

      testWidgets('should handle special characters and spaces', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final palindromeField = find.byType(TextFormField).at(1);
        
        await tester.enterText(palindromeField, 'kasur rusak');
        await tester.pump();

        expect(find.text('kasur rusak'), findsOneWidget);
      });
    });

    group('Text Input - Negative Cases', () {
      testWidgets('should handle empty input gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final nameField = find.byType(TextFormField).first;
        final palindromeField = find.byType(TextFormField).at(1);

        await tester.enterText(nameField, '');
        await tester.enterText(palindromeField, '');
        await tester.pump();

        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle whitespace-only input', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final palindromeField = find.byType(TextFormField).at(1);

        await tester.enterText(palindromeField, '   ');
        await tester.pump();

        expect(find.text('   '), findsOneWidget);
      });
    });

    group('CHECK Button - Positive Cases', () {
      testWidgets('should show isPalindrome dialog for valid palindromes', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final palindromeField = find.byType(TextFormField).at(1);
        final checkButton = find.text('CHECK');

        await tester.enterText(palindromeField, 'racecar');
        await tester.tap(checkButton);
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Result'), findsOneWidget);
        expect(find.text('isPalindrome'), findsOneWidget);
      });

      testWidgets('should show not palindrome dialog for non-palindromes', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final palindromeField = find.byType(TextFormField).at(1);
        final checkButton = find.text('CHECK');

        await tester.enterText(palindromeField, 'hello');
        await tester.tap(checkButton);
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('not palindrome'), findsOneWidget);
      });

      testWidgets('should close dialog when OK is tapped', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final palindromeField = find.byType(TextFormField).at(1);
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
        await tester.pumpWidget(createTestWidget());

        final checkButton = find.text('CHECK');

        await tester.tap(checkButton);
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Please enter a sentence to check'), findsOneWidget);
      });

      testWidgets('should handle multiple button presses without crashing', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final palindromeField = find.byType(TextFormField).at(1);
        final checkButton = find.text('CHECK');

        await tester.enterText(palindromeField, 'racecar');
        await tester.pumpAndSettle();

        // First tap
        await tester.tap(checkButton);
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('isPalindrome'), findsOneWidget);

        // Close dialog
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Second tap
        await tester.tap(checkButton, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('isPalindrome'), findsOneWidget);
      });
    });

    group('NEXT Button - Positive Cases', () {
      testWidgets('should navigate to welcome screen when name is provided', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidgetWithRoutes());

        final nameField = find.byType(TextFormField).first;
        final nextButton = find.text('NEXT');

        await tester.enterText(nameField, 'John Doe');
        await tester.pump();

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        expect(find.text('Welcome Screen'), findsOneWidget);
      });

      testWidgets('should show snackbar when NEXT button is tapped without name', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final nextButton = find.text('NEXT');

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Please enter your name first'), findsOneWidget);
      });

      testWidgets('should navigate with trimmed name containing spaces', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider(
              create: (_) => PalindromeViewModel(),
              child: const PalindromeView(),
            ),
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

        final nameField = find.byType(TextFormField).first;
        final nextButton = find.text('NEXT');

        await tester.enterText(nameField, '  John Doe  ');
        await tester.pump();

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        expect(find.text('Welcome: John Doe'), findsOneWidget);
      });
    });

    group('NEXT Button - Negative Cases', () {
      testWidgets('should handle rapid button presses without crashing', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final nextButton = find.text('NEXT');

        await tester.tap(nextButton);
        await tester.pump();

        for (int i = 0; i < 3; i++) {
          await tester.tap(nextButton, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 50));
        }
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('should show snackbar for whitespace-only name', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final nameField = find.byType(TextFormField).first;
        final nextButton = find.text('NEXT');

        await tester.enterText(nameField, '   ');
        await tester.pump();

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Please enter your name first'), findsOneWidget);
      });
    });

    group('Provider Integration Tests', () {
      testWidgets('should sync controller with provider state', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final nameField = find.byType(TextFormField).first;
        final palindromeField = find.byType(TextFormField).at(1);

        // Enter data
        await tester.enterText(nameField, 'John Doe');
        await tester.enterText(palindromeField, 'racecar');
        await tester.pump();

        // Verify data is in controllers
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('racecar'), findsOneWidget);

        // Test palindrome check (uses provider)
        final checkButton = find.text('CHECK');
        await tester.tap(checkButton);
        await tester.pumpAndSettle();

        expect(find.text('isPalindrome'), findsOneWidget);
      });

      testWidgets('should handle provider state during navigation', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidgetWithRoutes());

        final nameField = find.byType(TextFormField).first;
        final nextButton = find.text('NEXT');

        // Enter name via controller
        await tester.enterText(nameField, 'Provider Test');
        await tester.pump();

        // Navigate (uses provider state)
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        expect(find.text('Welcome Screen'), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('should handle complete flow - positive case', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidgetWithRoutes());

        final nameField = find.byType(TextFormField).first;
        final palindromeField = find.byType(TextFormField).at(1);
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

        // Navigate
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        expect(find.text('Welcome Screen'), findsOneWidget);
      });

      testWidgets('should handle complete flow - negative case', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final checkButton = find.text('CHECK');

        await tester.tap(checkButton);
        await tester.pumpAndSettle();
        
        expect(find.text('Please enter a sentence to check'), findsOneWidget);
      });
    });
  });
}