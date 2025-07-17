import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:threescr/welcome/views/welcome_view.dart';
import 'package:threescr/welcome/viewmodels/welcome_viewmodel.dart';

void main() {
  group('WelcomeView Tests', () {
    
    Widget createTestWidget({required String userName}) {
      return MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => WelcomeViewModel(),
          child: WelcomeView(userName: userName),
        ),
      );
    }

    Widget createTestWidgetWithRoutes({required String userName}) {
      return MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => WelcomeViewModel(),
          child: WelcomeView(userName: userName),
        ),
        routes: {
          '/users': (context) => const Scaffold(
            body: Text('Users Screen'),
          ),
        },
      );
    }

    Widget createTestWidgetWithNavigationCallback({required String userName}) {
      return MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => WelcomeViewModel(),
          child: WelcomeView(userName: userName),
        ),
        routes: {
          '/users': (context) {
            final callback = ModalRoute.of(context)?.settings.arguments as Function(String)?;
            
            // Simulate user selection after navigation is complete
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (callback != null) {
                callback('Selected User');
              }
            });
            
            return const Scaffold(
              body: Text('Users Screen'),
            );
          },
        },
      );
    }
    
    group('UI Rendering Tests - Positive Cases', () {
      testWidgets('should render all UI elements correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'John Doe'));
        await tester.pumpAndSettle();

        // Check AppBar elements
        expect(find.text('Second Screen'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);

        // Check body elements
        expect(find.text('Welcome'), findsOneWidget);
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Selected User Name'), findsOneWidget);
        expect(find.text('Choose a User'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should display correct userName from parameter', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'Test User'));
        await tester.pumpAndSettle();

        expect(find.text('Test User'), findsOneWidget);
      });

      testWidgets('should have correct AppBar styling', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'John Doe'));
        await tester.pumpAndSettle();

        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.backgroundColor, equals(Colors.white));
        expect(appBar.elevation, equals(0));
        expect(appBar.centerTitle, isTrue);
      });

      testWidgets('should have properly styled choose user button', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'John Doe'));
        await tester.pumpAndSettle();

        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.style?.backgroundColor?.resolve({}), equals(Colors.transparent));
        expect(button.style?.foregroundColor?.resolve({}), equals(Colors.white));
        expect(button.style?.elevation?.resolve({}), equals(0));
      });
    });

    group('UI Rendering Tests - Negative Cases', () {
      testWidgets('should handle empty userName', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: ''));
        await tester.pumpAndSettle();

        expect(find.text(''), findsOneWidget);
        expect(find.text('Selected User Name'), findsOneWidget);
        expect(find.text('Choose a User'), findsOneWidget);
      });

      testWidgets('should handle special characters in userName', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'John@123!'));
        await tester.pumpAndSettle();

        expect(find.text('John@123!'), findsOneWidget);
        expect(find.text('Selected User Name'), findsOneWidget);
      });

      testWidgets('should handle long userName', (WidgetTester tester) async {
        const longName = 'This is a very long user name that might cause layout issues';
        await tester.pumpWidget(createTestWidget(userName: longName));
        await tester.pumpAndSettle();

        expect(find.text(longName), findsOneWidget);
        expect(find.text('Selected User Name'), findsOneWidget);
      });
    });

    group('Button Interaction Tests - Positive Cases', () {
      testWidgets('should handle Choose a User button press with proper navigation', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidgetWithRoutes(userName: 'John Doe'));
        await tester.pumpAndSettle();

        final button = find.text('Choose a User');
        await tester.tap(button);
        await tester.pumpAndSettle();

        expect(find.text('Users Screen'), findsOneWidget);
      });

      testWidgets('should handle navigation with callback', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidgetWithNavigationCallback(userName: 'John Doe'));
        await tester.pumpAndSettle();

        // Tap choose user button
        final button = find.text('Choose a User');
        await tester.tap(button);
        await tester.pumpAndSettle();

        expect(find.text('Users Screen'), findsOneWidget);
        
        // Navigate back using proper method
        final navigator = Navigator.of(tester.element(find.text('Users Screen')));
        navigator.pop();
        await tester.pumpAndSettle();

        // The callback should have updated the selected user name
        expect(find.text('Selected User'), findsOneWidget);
      });

      testWidgets('should handle back button press', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            initialRoute: '/welcome',
            routes: {
              '/': (context) => const Scaffold(body: Text('Home')),
              '/welcome': (context) => ChangeNotifierProvider(
                create: (_) => WelcomeViewModel(),
                child: const WelcomeView(userName: 'John Doe'),
              ),
            },
          ),
        );
        await tester.pumpAndSettle();

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
            home: ChangeNotifierProvider(
              create: (_) => WelcomeViewModel(),
              child: const WelcomeView(userName: 'John Doe'),
            ),
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Text('Route not found'),
                ),
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        final button = find.text('Choose a User');
        await tester.tap(button);
        await tester.pumpAndSettle();

        expect(find.text('Route not found'), findsOneWidget);
      });

      testWidgets('should handle rapid button presses', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidgetWithRoutes(userName: 'John Doe'));
        await tester.pumpAndSettle();

        final button = find.text('Choose a User');
        
        // Rapid presses
        for (int i = 0; i < 3; i++) {
          await tester.tap(button, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 50));
        }
        await tester.pumpAndSettle();

        expect(find.text('Users Screen'), findsOneWidget);
      });
    });

    group('Provider Integration Tests', () {
      testWidgets('should initialize with correct userName via Provider', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'Provider Test'));
        await tester.pumpAndSettle();

        expect(find.text('Provider Test'), findsOneWidget);
      });

      testWidgets('should update selectedUserName via Provider', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'John Doe'));
        await tester.pumpAndSettle();

        // Initial state
        expect(find.text('Selected User Name'), findsOneWidget);

        // Simulate user selection via Provider
        final context = tester.element(find.byType(WelcomeView));
        Provider.of<WelcomeViewModel>(context, listen: false)
            .updateSelectedUserName('Jane Smith');
        await tester.pumpAndSettle();

        expect(find.text('Jane Smith'), findsOneWidget);
        expect(find.text('Selected User Name'), findsNothing);
      });

      testWidgets('should handle Provider state changes reactively', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'Initial User'));
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(WelcomeView));
        final viewModel = Provider.of<WelcomeViewModel>(context, listen: false);

        // Test userName change
        viewModel.initializeWithName('Updated User');
        await tester.pumpAndSettle();

        expect(find.text('Updated User'), findsOneWidget);
        expect(find.text('Initial User'), findsNothing);

        // Test selectedUserName change
        viewModel.updateSelectedUserName('Selected User');
        await tester.pumpAndSettle();

        expect(find.text('Selected User'), findsOneWidget);
      });

      testWidgets('should handle Consumer rebuilds correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'John Doe'));
        await tester.pumpAndSettle();

        // Find Consumer widget
        expect(find.byType(Consumer<WelcomeViewModel>), findsOneWidget);

        // Verify Consumer is working by checking UI updates
        final context = tester.element(find.byType(WelcomeView));
        Provider.of<WelcomeViewModel>(context, listen: false)
            .updateSelectedUserName('Consumer Test');
        await tester.pumpAndSettle();

        expect(find.text('Consumer Test'), findsOneWidget);
      });
    });

    group('Navigation Integration Tests', () {
      testWidgets('should handle navigation arguments correctly', (WidgetTester tester) async {
        Function(String)? capturedCallback;
        
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider(
              create: (_) => WelcomeViewModel(),
              child: const WelcomeView(userName: 'John Doe'),
            ),
            routes: {
              '/users': (context) {
                capturedCallback = ModalRoute.of(context)?.settings.arguments as Function(String)?;
                return const Scaffold(
                  body: Text('Users Screen'),
                );
              },
            },
          ),
        );
        await tester.pumpAndSettle();

        final button = find.text('Choose a User');
        await tester.tap(button);
        await tester.pumpAndSettle();

        expect(capturedCallback, isNotNull);
        expect(capturedCallback, isA<Function>());
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle widget creation without errors', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'John Doe'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(WelcomeView), findsOneWidget);
      });

      testWidgets('should handle widget disposal gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'John Doe'));
        await tester.pumpAndSettle();

        expect(find.text('John Doe'), findsOneWidget);

        // Replace with empty widget
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: Text('Empty Screen')),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Empty Screen'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle Provider disposal correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'John Doe'));
        await tester.pumpAndSettle();

        // Verify Provider is working
        final context = tester.element(find.byType(WelcomeView));
        final viewModel = Provider.of<WelcomeViewModel>(context, listen: false);
        
        expect(viewModel, isNotNull);
        expect(viewModel.userName, equals('John Doe'));

        // Dispose widget
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: Text('Disposed')),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Disposed'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('State Management Tests', () {
      testWidgets('should preserve state during rebuilds', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'John Doe'));
        await tester.pumpAndSettle();

        // Update state
        final context = tester.element(find.byType(WelcomeView));
        Provider.of<WelcomeViewModel>(context, listen: false)
            .updateSelectedUserName('Test User');
        await tester.pumpAndSettle();

        expect(find.text('Test User'), findsOneWidget);

        // Trigger rebuild
        await tester.pump();

        // State should be preserved
        expect(find.text('Test User'), findsOneWidget);
      });

      testWidgets('should handle multiple Provider updates', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'John Doe'));
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(WelcomeView));
        final viewModel = Provider.of<WelcomeViewModel>(context, listen: false);

        // Multiple updates
        viewModel.updateSelectedUserName('User 1');
        await tester.pumpAndSettle();
        expect(find.text('User 1'), findsOneWidget);

        viewModel.updateSelectedUserName('User 2');
        await tester.pumpAndSettle();
        expect(find.text('User 2'), findsOneWidget);

        viewModel.updateSelectedUserName('User 3');
        await tester.pumpAndSettle();
        expect(find.text('User 3'), findsOneWidget);
      });
    });

    group('Layout Tests', () {
      testWidgets('should have proper layout structure', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'John Doe'));
        await tester.pumpAndSettle();

        // Check for main structural elements
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should handle different screen sizes', (WidgetTester tester) async {
        // Test with smaller screen
        await tester.binding.setSurfaceSize(const Size(300, 600));
        await tester.pumpWidget(createTestWidget(userName: 'John Doe'));
        await tester.pumpAndSettle();

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Choose a User'), findsOneWidget);

        // Test with larger screen
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(createTestWidget(userName: 'John Doe'));
        await tester.pumpAndSettle();

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Choose a User'), findsOneWidget);
        
        // Reset to default
        addTearDown(() => tester.binding.setSurfaceSize(null));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle rapid state changes without performance issues', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'John Doe'));
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(WelcomeView));
        final viewModel = Provider.of<WelcomeViewModel>(context, listen: false);

        // Rapid state changes
        for (int i = 0; i < 5; i++) {
          viewModel.updateSelectedUserName('User $i');
          await tester.pump(const Duration(milliseconds: 10));
        }
        await tester.pumpAndSettle();

        expect(find.text('User 4'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle unicode characters in userName', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'João 中文 😊'));
        await tester.pumpAndSettle();

        expect(find.text('João 中文 😊'), findsOneWidget);
        expect(find.text('Selected User Name'), findsOneWidget);
      });

      testWidgets('should handle null-like values gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(userName: 'null'));
        await tester.pumpAndSettle();

        expect(find.text('null'), findsOneWidget);
        expect(find.text('Selected User Name'), findsOneWidget);
      });
    });

    group('User Change Handling Tests', () {
      testWidgets('should reset selectedUserName when user changes', (WidgetTester tester) async {
        // Use a single provider instance across widget rebuilds
        final viewModel = WelcomeViewModel();
        
        // Setup with User A
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider.value(
              value: viewModel,
              child: const WelcomeView(userName: 'User A'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Select Rachel
        viewModel.updateSelectedUserName('Rachel');
        await tester.pumpAndSettle();

        expect(find.text('Rachel'), findsOneWidget);

        // Manually trigger user change (simulating what happens in real app)
        viewModel.initializeWithName('User B');
        await tester.pumpAndSettle();

        // Should reset to default
        expect(find.text('Selected User Name'), findsOneWidget);
        expect(find.text('Rachel'), findsNothing);
        expect(find.text('User B'), findsOneWidget);
        
        viewModel.dispose();
      });

      testWidgets('should preserve selectedUserName when same user', (WidgetTester tester) async {
        final viewModel = WelcomeViewModel();
        
        // Setup with User A
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider.value(
              value: viewModel,
              child: const WelcomeView(userName: 'User A'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Select Rachel
        viewModel.updateSelectedUserName('Rachel');
        await tester.pumpAndSettle();

        expect(find.text('Rachel'), findsOneWidget);

        // Same user again
        viewModel.initializeWithName('User A');
        await tester.pumpAndSettle();

        // Should preserve selection
        expect(find.text('Rachel'), findsOneWidget);
        expect(find.text('User A'), findsOneWidget);
        
        viewModel.dispose();
      });
    });
  });
}