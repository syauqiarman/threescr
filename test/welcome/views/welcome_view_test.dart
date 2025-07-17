import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threescr/welcome/views/welcome_view.dart';

void main() {
  group('WelcomeView Tests', () {
    
    group('UI Rendering Tests - Positive Cases', () {
      testWidgets('should render all UI elements correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: 'John Doe'),
          ),
        );

        expect(find.text('Welcome'), findsOneWidget);
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Selected User Name'), findsOneWidget);
        expect(find.text('Choose a User'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should display correct userName from parameter', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: 'Test User'),
          ),
        );

        expect(find.text('Test User'), findsOneWidget);
      });

      testWidgets('should have correct AppBar title', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: 'John Doe'),
          ),
        );

        expect(find.text('Second Screen'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      });

      testWidgets('should display welcome section correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: 'John Doe'),
          ),
        );

        expect(find.text('Welcome'), findsOneWidget);
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Selected User Name'), findsOneWidget);
      });
    });

    group('UI Rendering Tests - Negative Cases', () {
      testWidgets('should handle empty userName', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: ''),
          ),
        );

        expect(find.text(''), findsOneWidget);
        expect(find.text('Selected User Name'), findsOneWidget);
      });

      testWidgets('should handle special characters in userName', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: 'John@123!'),
          ),
        );

        expect(find.text('John@123!'), findsOneWidget);
        expect(find.text('Selected User Name'), findsOneWidget);
      });

      testWidgets('should handle long userName', (WidgetTester tester) async {
        const longName = 'This is a very long user name that might cause layout issues';
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: longName),
          ),
        );

        expect(find.text(longName), findsOneWidget);
        expect(find.text('Selected User Name'), findsOneWidget);
      });
    });

    group('Button Interaction Tests - Positive Cases', () {
      testWidgets('should handle Choose a User button press with proper navigation', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const WelcomeView(userName: 'John Doe'),
            routes: {
              '/users': (context) => const Scaffold(
                body: Text('Users Screen'),
              ),
            },
          ),
        );

        final button = find.text('Choose a User');
        await tester.tap(button);
        await tester.pumpAndSettle();

        expect(find.text('Users Screen'), findsOneWidget);
      });

      testWidgets('should find back button in AppBar', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: 'John Doe'),
          ),
        );

        expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      });

      testWidgets('should handle back button press', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            initialRoute: '/welcome',
            routes: {
              '/': (context) => const Scaffold(body: Text('Home')),
              '/welcome': (context) => const WelcomeView(userName: 'John Doe'),
            },
          ),
        );

        final backButton = find.byIcon(Icons.arrow_back_ios);
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
      });
    });

    group('Button Interaction Tests - Negative Cases', () {
      testWidgets('should handle button press without navigation setup', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const WelcomeView(userName: 'John Doe'),
            // Add onUnknownRoute to handle navigation errors gracefully
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Text('Route not found'),
                ),
              );
            },
          ),
        );

        final button = find.text('Choose a User');
        
        // This should navigate to unknown route handler
        await tester.tap(button);
        await tester.pumpAndSettle();
        
        // Should show the unknown route page
        expect(find.text('Route not found'), findsOneWidget);
      });

      testWidgets('should handle multiple button presses', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const WelcomeView(userName: 'John Doe'),
            routes: {
              '/users': (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Users'),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: const Text('Users Screen'),
              ),
            },
          ),
        );

        final button = find.text('Choose a User');
        
        // First tap
        await tester.tap(button);
        await tester.pumpAndSettle();
        
        expect(find.text('Users Screen'), findsOneWidget);
        
        // Go back using the back button
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
        
        // Should be back to welcome screen
        expect(find.text('John Doe'), findsOneWidget);
        
        // Second tap
        await tester.tap(button);
        await tester.pumpAndSettle();
        
        expect(find.text('Users Screen'), findsOneWidget);
      });

      testWidgets('should handle rapid button presses', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const WelcomeView(userName: 'John Doe'),
            routes: {
              '/users': (context) => const Scaffold(
                body: Text('Users Screen'),
              ),
            },
          ),
        );

        final button = find.text('Choose a User');
        
        // Rapid taps
        for (int i = 0; i < 3; i++) {
          await tester.tap(button, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 50));
        }
        await tester.pumpAndSettle();
        
        // Should still navigate successfully
        expect(find.text('Users Screen'), findsOneWidget);
      });
    });

    group('State Management Tests', () {
      testWidgets('should maintain state correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: 'John Doe'),
          ),
        );

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Selected User Name'), findsOneWidget);

        // Simulate rebuild
        await tester.pump();

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Selected User Name'), findsOneWidget);
      });

      testWidgets('should handle widget disposal gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: 'John Doe'),
          ),
        );

        expect(find.text('John Doe'), findsOneWidget);

        // Replace with empty widget
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: Text('Empty Screen')),
          ),
        );

        expect(find.text('Empty Screen'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Layout Tests', () {
      testWidgets('should have proper layout structure', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: 'John Doe'),
          ),
        );

        // Check for main structural elements
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should handle different screen sizes', (WidgetTester tester) async {
        // Test with smaller screen
        await tester.binding.setSurfaceSize(const Size(300, 600));
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: 'John Doe'),
          ),
        );

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Choose a User'), findsOneWidget);

        // Test with larger screen
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: 'John Doe'),
          ),
        );

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Choose a User'), findsOneWidget);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle widget creation without errors', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: 'John Doe'),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(WelcomeView), findsOneWidget);
      });

      testWidgets('should handle navigation gracefully with proper error handling', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const WelcomeView(userName: 'John Doe'),
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Text('Error handled'),
                ),
              );
            },
          ),
        );

        // Try to tap button - should navigate to error handler
        final button = find.text('Choose a User');
        await tester.tap(button);
        await tester.pumpAndSettle();

        // Should show error handling page
        expect(find.text('Error handled'), findsOneWidget);
      });

      testWidgets('should handle invalid user input', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeView(userName: 'John Doe'),
          ),
        );

        // Try to find non-existent elements
        expect(find.text('Non-existent text'), findsNothing);
        expect(find.byType(FloatingActionButton), findsNothing);
        
        // Widget should still be functional
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Choose a User'), findsOneWidget);
      });
    });
  });
}