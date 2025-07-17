import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threescr/main.dart';
import 'package:threescr/palindrome/views/palindrome_view.dart';

void main() {
  group('Main App Tests', () {
    
    group('MyApp Widget Tests - Positive Cases', () {
      testWidgets('should create MyApp widget successfully', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        expect(find.byType(MyApp), findsOneWidget);
        expect(find.byType(MaterialApp), findsOneWidget);
      });

      testWidgets('should have correct app title', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final MaterialApp materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(materialApp.title, equals('Flutter Demo'));
      });

      testWidgets('should use Material3 theme', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final MaterialApp materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(materialApp.theme?.useMaterial3, isTrue);
      });

      testWidgets('should have PalindromeView as home', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final MaterialApp materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(materialApp.home, isA<PalindromeView>());
        expect(find.byType(PalindromeView), findsOneWidget);
      });
    });

    group('App Integration Tests - Positive Cases', () {
      testWidgets('should render complete app with all UI elements', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        // Verify app structure
        expect(find.byType(MyApp), findsOneWidget);
        expect(find.byType(MaterialApp), findsOneWidget);
        expect(find.byType(PalindromeView), findsOneWidget);
        
        // Verify PalindromeView elements are present
        expect(find.byType(TextField), findsNWidgets(2));
        expect(find.byType(ElevatedButton), findsNWidgets(2));
        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Palindrome'), findsOneWidget);
        expect(find.text('CHECK'), findsOneWidget);
        expect(find.text('NEXT'), findsOneWidget);
      });

      testWidgets('should handle user input correctly', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final nameField = find.byType(TextField).first;
        final palindromeField = find.byType(TextField).at(1);
        
        await tester.enterText(nameField, 'Test User');
        await tester.enterText(palindromeField, 'racecar');
        await tester.pump();
        
        expect(find.text('Test User'), findsOneWidget);
        expect(find.text('racecar'), findsOneWidget);
      });

      testWidgets('should handle button interactions', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final palindromeField = find.byType(TextField).at(1);
        final checkButton = find.text('CHECK');
        
        await tester.enterText(palindromeField, 'racecar');
        await tester.tap(checkButton);
        await tester.pumpAndSettle();
        
        expect(find.byType(AlertDialog), findsOneWidget);
      });
    });

    group('App Integration Tests - Negative Cases', () {
      testWidgets('should handle empty input gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final checkButton = find.text('CHECK');
        
        await tester.tap(checkButton);
        await tester.pumpAndSettle();
        
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Please enter a sentence to check'), findsOneWidget);
      });

      testWidgets('should not crash during initialization', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        // Verify no exceptions are thrown during initial render
        expect(tester.takeException(), isNull);
        expect(find.byType(MyApp), findsOneWidget);
      });

      testWidgets('should handle rapid user interactions', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final nextButton = find.text('NEXT');
        
        // Tap button multiple times rapidly
        await tester.tap(nextButton);
        await tester.tap(nextButton, warnIfMissed: false);
        await tester.pumpAndSettle();
        
        expect(find.byType(SnackBar), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('App State Management Tests', () {
      testWidgets('should maintain input state during rebuilds', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final nameField = find.byType(TextField).first;
        await tester.enterText(nameField, 'Test User');
        await tester.pump();
        
        // Verify input is there
        expect(find.text('Test User'), findsOneWidget);
        
        // Rebuild app
        await tester.pumpWidget(const MyApp());
        
        // State should be maintained
        expect(find.text('Test User'), findsOneWidget);
      });

      testWidgets('should handle widget disposal gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        // Verify widget is there
        expect(find.byType(MyApp), findsOneWidget);
        
        // Remove widget
        await tester.pumpWidget(const SizedBox());
        
        // Should not crash
        expect(tester.takeException(), isNull);
      });
    });

    group('Performance Tests', () {
      testWidgets('should render within reasonable time', (WidgetTester tester) async {
        final stopwatch = Stopwatch()..start();
        
        await tester.pumpWidget(const MyApp());
        
        stopwatch.stop();
        
        // Should render within 1 second (very generous threshold)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(find.byType(MyApp), findsOneWidget);
      });

      testWidgets('should handle multiple rebuilds efficiently', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        // Multiple rebuilds should not cause performance issues
        for (int i = 0; i < 3; i++) {
          await tester.pumpWidget(const MyApp());
          expect(find.byType(MyApp), findsOneWidget);
        }
        
        expect(tester.takeException(), isNull);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle invalid operations gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        // Try to interact with non-existent elements
        expect(find.text('NonExistentText'), findsNothing);
        expect(find.byType(FloatingActionButton), findsNothing);
        
        // App should still be functional
        expect(find.byType(MyApp), findsOneWidget);
        expect(find.byType(PalindromeView), findsOneWidget);
      });

      testWidgets('should recover from user errors', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        
        final palindromeField = find.byType(TextField).at(1);
        final checkButton = find.text('CHECK');
        
        // First, trigger an error with empty input
        await tester.tap(checkButton);
        await tester.pumpAndSettle();
        
        expect(find.text('Please enter a sentence to check'), findsOneWidget);
        
        // Close error dialog
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        
        // Now use valid input
        await tester.enterText(palindromeField, 'racecar');
        await tester.tap(checkButton);
        await tester.pumpAndSettle();
        
        expect(find.text('isPalindrome'), findsOneWidget);
      });
    });
  });
}