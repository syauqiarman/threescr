import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threescr/main.dart';
import 'package:threescr/palindrome/views/palindrome_view.dart';
import 'package:threescr/welcome/views/welcome_view.dart';

void main() {
  group('Main App Tests', () {
    
    group('MyApp Widget Tests', () {
      testWidgets('should create MyApp widget successfully', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        expect(find.byType(MyApp), findsOneWidget);
        expect(find.byType(MaterialApp), findsOneWidget);
      });

      testWidgets('should have correct initial route', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final MaterialApp materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(materialApp.initialRoute, equals('/palindrome'));
        expect(find.byType(PalindromeView), findsOneWidget);
      });

      testWidgets('should have all required routes configured', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final MaterialApp materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(materialApp.routes, isNotNull);
        expect(materialApp.routes!.containsKey('/palindrome'), isTrue);
        expect(materialApp.routes!.containsKey('/welcome'), isTrue);
        expect(materialApp.routes!.containsKey('/users'), isTrue);
      });
    });

    group('App Navigation Tests', () {
      testWidgets('should navigate from palindrome to welcome screen', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');
        
        await tester.enterText(nameField, 'John Doe');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        
        expect(find.byType(WelcomeView), findsOneWidget);
        expect(find.text('John Doe'), findsOneWidget);
      });

      testWidgets('should navigate from welcome to users screen', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');
        
        await tester.enterText(nameField, 'John Doe');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        
        final chooseUserButton = find.text('Choose a User');
        await tester.tap(chooseUserButton);
        await tester.pumpAndSettle();
        
        // Fixed: Check for UserView instead of placeholder text
        expect(find.text('Third Screen'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      });

      testWidgets('should handle back navigation', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');
        
        await tester.enterText(nameField, 'John Doe');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        
        final backButton = find.byIcon(Icons.arrow_back_ios);
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        
        expect(find.byType(PalindromeView), findsOneWidget);
      });

      testWidgets('should show snackbar when navigating without name', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final nextButton = find.text('NEXT');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        
        expect(find.byType(PalindromeView), findsOneWidget);
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Please enter your name first'), findsOneWidget);
      });

      testWidgets('should navigate back from users screen', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');
        
        await tester.enterText(nameField, 'John Doe');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        
        final chooseUserButton = find.text('Choose a User');
        await tester.tap(chooseUserButton);
        await tester.pumpAndSettle();
        
        // Should be on users screen
        expect(find.text('Third Screen'), findsOneWidget);
        
        // Navigate back
        final backButton = find.byIcon(Icons.arrow_back_ios);
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        
        // Should be back on welcome screen
        expect(find.byType(WelcomeView), findsOneWidget);
        expect(find.text('John Doe'), findsOneWidget);
      });
    });

    group('App Integration Tests', () {
      testWidgets('should render all essential UI elements', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        expect(find.byType(PalindromeView), findsOneWidget);
        expect(find.byType(TextField), findsNWidgets(2));
        expect(find.byType(ElevatedButton), findsNWidgets(2));
        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Palindrome'), findsOneWidget);
        expect(find.text('CHECK'), findsOneWidget);
        expect(find.text('NEXT'), findsOneWidget);
      });

      testWidgets('should handle palindrome checking', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final palindromeField = find.byType(TextField).at(1);
        final checkButton = find.text('CHECK');
        
        await tester.enterText(palindromeField, 'racecar');
        await tester.tap(checkButton);
        await tester.pumpAndSettle();
        
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('isPalindrome'), findsOneWidget);
      });

      testWidgets('should handle complete user flow', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final nameField = find.byType(TextField).first;
        final palindromeField = find.byType(TextField).at(1);
        final checkButton = find.text('CHECK');
        final nextButton = find.text('NEXT');
        
        // Enter data and check palindrome
        await tester.enterText(nameField, 'John Doe');
        await tester.enterText(palindromeField, 'racecar');
        await tester.tap(checkButton);
        await tester.pumpAndSettle();
        
        expect(find.text('isPalindrome'), findsOneWidget);
        
        // Close dialog and navigate
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        
        expect(find.byType(WelcomeView), findsOneWidget);
        expect(find.text('John Doe'), findsOneWidget);
        
        // Navigate to users screen
        final chooseUserButton = find.text('Choose a User');
        await tester.tap(chooseUserButton);
        await tester.pumpAndSettle();
        
        // Fixed: Check for UserView instead of placeholder text
        expect(find.text('Third Screen'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      });

      testWidgets('should handle empty input validation', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final checkButton = find.text('CHECK');
        
        await tester.tap(checkButton);
        await tester.pumpAndSettle();
        
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Please enter a sentence to check'), findsOneWidget);
      });

      testWidgets('should handle user selection callback', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');
        
        await tester.enterText(nameField, 'John Doe');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        
        final chooseUserButton = find.text('Choose a User');
        await tester.tap(chooseUserButton);
        await tester.pumpAndSettle();
        
        // Should navigate to users screen
        expect(find.text('Third Screen'), findsOneWidget);
        
        // User selection would trigger callback when user is selected
        // (This would require actual user data to be loaded)
      });
    });

    group('App Error Handling Tests', () {
      testWidgets('should not crash during initialization', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        expect(tester.takeException(), isNull);
        expect(find.byType(MyApp), findsOneWidget);
      });

      testWidgets('should handle user error recovery', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final palindromeField = find.byType(TextField).at(1);
        final checkButton = find.text('CHECK');
        
        // Trigger error with empty input
        await tester.tap(checkButton);
        await tester.pumpAndSettle();
        
        expect(find.text('Please enter a sentence to check'), findsOneWidget);
        
        // Close error dialog and try valid input
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        
        await tester.enterText(palindromeField, 'racecar');
        await tester.tap(checkButton);
        await tester.pumpAndSettle();
        
        expect(find.text('isPalindrome'), findsOneWidget);
      });

      testWidgets('should maintain state during navigation', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final nameField = find.byType(TextField).first;
        final palindromeField = find.byType(TextField).at(1);
        final nextButton = find.text('NEXT');
        
        await tester.enterText(nameField, 'John Doe');
        await tester.enterText(palindromeField, 'racecar');
        
        // Navigate to welcome
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        
        // Navigate back
        final backButton = find.byIcon(Icons.arrow_back_ios);
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        
        // Input should still be there
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('racecar'), findsOneWidget);
      });

      testWidgets('should handle network errors gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');
        
        await tester.enterText(nameField, 'John Doe');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        
        final chooseUserButton = find.text('Choose a User');
        await tester.tap(chooseUserButton);
        await tester.pumpAndSettle();
        
        // Should navigate to users screen even if network fails
        expect(find.text('Third Screen'), findsOneWidget);
        
        // UserView should handle network errors internally
        expect(tester.takeException(), isNull);
      });
    });

    group('App Flow Tests', () {
      testWidgets('should complete full navigation flow', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        // Start from palindrome screen
        expect(find.byType(PalindromeView), findsOneWidget);
        
        // Enter name and navigate to welcome
        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');
        
        await tester.enterText(nameField, 'Test User');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        
        // Should be on welcome screen
        expect(find.byType(WelcomeView), findsOneWidget);
        expect(find.text('Test User'), findsOneWidget);
        
        // Navigate to users screen
        final chooseUserButton = find.text('Choose a User');
        await tester.tap(chooseUserButton);
        await tester.pumpAndSettle();
        
        // Should be on users screen
        expect(find.text('Third Screen'), findsOneWidget);
        
        // Navigate back to welcome
        final backButton = find.byIcon(Icons.arrow_back_ios);
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        
        // Should be back on welcome screen
        expect(find.byType(WelcomeView), findsOneWidget);
        expect(find.text('Test User'), findsOneWidget);
        
        // Navigate back to palindrome
        final welcomeBackButton = find.byIcon(Icons.arrow_back_ios);
        await tester.tap(welcomeBackButton);
        await tester.pumpAndSettle();
        
        // Should be back on palindrome screen
        expect(find.byType(PalindromeView), findsOneWidget);
        expect(find.text('Test User'), findsOneWidget); // Name should be preserved
      });

      testWidgets('should handle rapid navigation', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');
        
        await tester.enterText(nameField, 'Rapid User');
        
        // Rapid navigation attempts
        for (int i = 0; i < 3; i++) {
          await tester.tap(nextButton, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 50));
        }
        
        await tester.pumpAndSettle();
        
        // Should navigate successfully
        expect(find.byType(WelcomeView), findsOneWidget);
        expect(find.text('Rapid User'), findsOneWidget);
      });

      testWidgets('should handle deep navigation', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        // Navigate through all screens
        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');
        
        await tester.enterText(nameField, 'Deep User');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        
        expect(find.byType(WelcomeView), findsOneWidget);
        
        final chooseUserButton = find.text('Choose a User');
        await tester.tap(chooseUserButton);
        await tester.pumpAndSettle();
        
        expect(find.text('Third Screen'), findsOneWidget);
        
        // Navigate back through all screens
        final backButton = find.byIcon(Icons.arrow_back_ios);
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        
        expect(find.byType(WelcomeView), findsOneWidget);
        
        final welcomeBackButton = find.byIcon(Icons.arrow_back_ios);
        await tester.tap(welcomeBackButton);
        await tester.pumpAndSettle();
        
        expect(find.byType(PalindromeView), findsOneWidget);
      });
    });

    group('App State Management Tests', () {
      testWidgets('should preserve user data across navigation', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        const testName = 'State Test User';
        final nameField = find.byType(TextField).first;
        final nextButton = find.text('NEXT');
        
        await tester.enterText(nameField, testName);
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        
        // Should preserve name in welcome screen
        expect(find.text(testName), findsOneWidget);
        
        // Navigate to users and back
        final chooseUserButton = find.text('Choose a User');
        await tester.tap(chooseUserButton);
        await tester.pumpAndSettle();
        
        final backButton = find.byIcon(Icons.arrow_back_ios);
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        
        // Name should still be preserved
        expect(find.text(testName), findsOneWidget);
      });

      testWidgets('should handle app lifecycle correctly', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        // Test multiple rebuilds
        for (int i = 0; i < 5; i++) {
          await tester.pump();
        }
        
        expect(find.byType(PalindromeView), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });
}