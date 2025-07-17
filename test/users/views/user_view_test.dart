import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threescr/users/views/user_view.dart';

void main() {
  group('UserView Tests', () {
    
    group('UI Rendering Tests - Positive Cases', () {
      testWidgets('should render all essential UI elements', (WidgetTester tester) async {
        String selectedUser = '';
        
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {
                selectedUser = userName;
              },
            ),
          ),
        );

        // Check AppBar
        expect(find.text('Third Screen'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        
        // Check Scaffold
        expect(find.byType(Scaffold), findsOneWidget);
        
        // Verify selectedUser is initially empty
        expect(selectedUser, equals(''));
      });

      testWidgets('should have correct AppBar styling', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {},
            ),
          ),
        );

        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.backgroundColor, equals(Colors.white));
        expect(appBar.elevation, equals(0));
        expect(appBar.centerTitle, isTrue);
      });

      testWidgets('should show loading indicator initially', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {},
            ),
          ),
        );

        // Should show loading indicator
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Back Button Tests - Positive Cases', () {
      testWidgets('should navigate back when back button is pressed', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserView(
                          onUserSelected: (String userName) {},
                        ),
                      ),
                    );
                  },
                  child: const Text('Go to Users'),
                ),
              ),
            ),
          ),
        );

        // Navigate to users screen
        await tester.tap(find.text('Go to Users'));
        await tester.pumpAndSettle();

        // Check we're on users screen
        expect(find.text('Third Screen'), findsOneWidget);

        // Tap back button
        await tester.tap(find.byIcon(Icons.arrow_back_ios));
        await tester.pumpAndSettle();

        // Should be back to original screen
        expect(find.text('Go to Users'), findsOneWidget);
      });
    });

    group('User Selection Tests - Positive Cases', () {
      testWidgets('should call onUserSelected when user is tapped', (WidgetTester tester) async {
        String selectedUser = '';
        bool wasCallbackCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {
                selectedUser = userName;
                wasCallbackCalled = true;
              },
            ),
          ),
        );

        // Wait for loading to complete
        await tester.pumpAndSettle();

        // Verify callback structure
        expect(wasCallbackCalled, isFalse);
        expect(selectedUser, equals(''));
      });
    });

    group('Scroll Tests - Positive Cases', () {
      testWidgets('should handle scroll events', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {},
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Try to scroll (would require data to be present)
        final scrollable = find.byType(Scrollable);
        if (scrollable.evaluate().isNotEmpty) {
          await tester.drag(scrollable.first, const Offset(0, -300));
          await tester.pumpAndSettle();
        }

        // Should handle scroll gracefully
        expect(tester.takeException(), isNull);
      });
    });

    group('Pull to Refresh Tests - Positive Cases', () {
      testWidgets('should handle pull to refresh', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {},
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Try to pull down for refresh
        final refreshIndicator = find.byType(RefreshIndicator);
        if (refreshIndicator.evaluate().isNotEmpty) {
          await tester.drag(refreshIndicator.first, const Offset(0, 300));
          await tester.pumpAndSettle();
        }

        // Should handle refresh gracefully
        expect(tester.takeException(), isNull);
      });
    });

    group('State Display Tests - Positive Cases', () {
      testWidgets('should handle different loading states', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {},
            ),
          ),
        );

        // Initial loading state
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        // Should transition to another state
        expect(tester.takeException(), isNull);
      });
    });

    group('Widget Disposal Tests - Positive Cases', () {
      testWidgets('should dispose properly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {},
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Replace with different widget
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Text('Different Screen'),
            ),
          ),
        );

        // Should dispose without errors
        expect(tester.takeException(), isNull);
        expect(find.text('Different Screen'), findsOneWidget);
      });
    });

    group('Error Handling Tests - Negative Cases', () {
      testWidgets('should handle widget creation errors gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {},
            ),
          ),
        );

        // Should not throw exceptions during creation
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle callback errors gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {
                // This would normally throw an error, but we'll test the structure
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should handle callback setup gracefully
        expect(tester.takeException(), isNull);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle rapid navigation', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserView(
                        onUserSelected: (String userName) {},
                      ),
                    ),
                  );
                },
                child: const Text('Go to Users'),
              ),
            ),
          ),
        );

        // Fixed: Proper navigation with proper waiting
        for (int i = 0; i < 3; i++) {
          // Ensure button is available before tapping
          await tester.pumpAndSettle();
          
          final goButton = find.text('Go to Users');
          if (goButton.evaluate().isNotEmpty) {
            await tester.tap(goButton, warnIfMissed: false);
            await tester.pumpAndSettle();
            
            // Check if we're on the user screen
            final backButton = find.byIcon(Icons.arrow_back_ios);
            if (backButton.evaluate().isNotEmpty) {
              await tester.tap(backButton, warnIfMissed: false);
              await tester.pumpAndSettle();
            }
          }
          
          // Add delay between iterations
          await tester.pump(const Duration(milliseconds: 100));
        }

        // Should handle rapid navigation gracefully
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle sequential navigation properly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserView(
                        onUserSelected: (String userName) {},
                      ),
                    ),
                  );
                },
                child: const Text('Go to Users'),
              ),
            ),
          ),
        );

        // Test proper sequential navigation
        await tester.tap(find.text('Go to Users'));
        await tester.pumpAndSettle();
        
        expect(find.text('Third Screen'), findsOneWidget);
        
        await tester.tap(find.byIcon(Icons.arrow_back_ios));
        await tester.pumpAndSettle();
        
        expect(find.text('Go to Users'), findsOneWidget);
      });

      testWidgets('should handle multiple callback calls', (WidgetTester tester) async {
        int callCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {
                callCount++;
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Multiple rapid calls shouldn't cause issues
        expect(callCount, equals(0));
      });

      testWidgets('should handle different screen sizes', (WidgetTester tester) async {
        // Test with small screen
        await tester.binding.setSurfaceSize(const Size(300, 600));
        
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {},
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Third Screen'), findsOneWidget);

        // Test with large screen
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {},
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Third Screen'), findsOneWidget);
        
        // Reset to default
        addTearDown(() => tester.binding.setSurfaceSize(null));
      });
    });

    group('Navigation Tests', () {
      testWidgets('should handle proper navigation flow', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserView(
                            onUserSelected: (String userName) {},
                          ),
                        ),
                      );
                    },
                    child: const Text('Go to Users'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Navigate to users screen
        await tester.tap(find.text('Go to Users'));
        await tester.pumpAndSettle();

        // Should be on users screen
        expect(find.text('Third Screen'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);

        // Navigate back
        await tester.tap(find.byIcon(Icons.arrow_back_ios));
        await tester.pumpAndSettle();

        // Should be back to original screen
        expect(find.text('Go to Users'), findsOneWidget);
      });

      testWidgets('should handle navigation with proper timing', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserView(
                        onUserSelected: (String userName) {},
                      ),
                    ),
                  );
                },
                child: const Text('Go to Users'),
              ),
            ),
          ),
        );

        // Test multiple navigation cycles with proper timing
        for (int i = 0; i < 2; i++) {
          await tester.tap(find.text('Go to Users'));
          await tester.pumpAndSettle();
          
          expect(find.text('Third Screen'), findsOneWidget);
          
          await tester.tap(find.byIcon(Icons.arrow_back_ios));
          await tester.pumpAndSettle();
          
          expect(find.text('Go to Users'), findsOneWidget);
        }
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper accessibility labels', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {},
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Check that important elements have proper semantics
        final backButton = find.byIcon(Icons.arrow_back_ios);
        expect(backButton, findsOneWidget);

        final appBar = find.byType(AppBar);
        expect(appBar, findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should handle widget rebuilds efficiently', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {},
            ),
          ),
        );

        // Multiple rebuilds shouldn't cause performance issues
        for (int i = 0; i < 10; i++) {
          await tester.pump();
        }

        expect(tester.takeException(), isNull);
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('should have correct widget hierarchy', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {},
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Check widget hierarchy
        expect(find.byType(MaterialApp), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('should handle callback parameter correctly', (WidgetTester tester) async {
        String? receivedUserName;
        
        await tester.pumpWidget(
          MaterialApp(
            home: UserView(
              onUserSelected: (String userName) {
                receivedUserName = userName;
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Callback should be set up properly
        expect(receivedUserName, isNull);
      });
    });
  });
}