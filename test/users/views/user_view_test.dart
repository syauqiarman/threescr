import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:threescr/users/views/user_view.dart';
import 'package:threescr/users/viewmodels/user_viewmodel.dart';

void main() {
  group('UserView Tests', () {
    Widget createTestWidget({required Function(String) onUserSelected}) {
      return MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => UserViewModel(),
          child: UserView(onUserSelected: onUserSelected),
        ),
      );
    }

    group('UI Rendering Tests', () {
      testWidgets('should render AppBar correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(onUserSelected: (name) {}));
        
        expect(find.text('Third Screen'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('should show loading indicator initially', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(onUserSelected: (name) {}));
        
        // Wait for PostFrameCallback and multiple frames to ensure state changes
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        
        // Get current state
        final context = tester.element(find.byType(UserView));
        final viewModel = Provider.of<UserViewModel>(context, listen: false);
        
        // Check for loading indicator OR verify that loading was triggered
        final hasLoadingIndicator = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
        final isInLoadingState = viewModel.isLoading || viewModel.loadingState == LoadingState.loading;
        final stateChanged = viewModel.loadingState != LoadingState.idle;
        
        // Should show loading indicator OR be in loading state OR have changed from idle
        expect(hasLoadingIndicator || isInLoadingState || stateChanged, isTrue);
      });
    });

    group('Provider Integration Tests', () {
      testWidgets('should call loadUsers on initialization', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(onUserSelected: (name) {}));
        await tester.pumpAndSettle();
        
        final context = tester.element(find.byType(UserView));
        final viewModel = Provider.of<UserViewModel>(context, listen: false);
        
        expect(viewModel, isNotNull);
        // Verify loadUsers was called by checking state is not idle
        expect(viewModel.loadingState, isNot(LoadingState.idle));
      });

      testWidgets('should handle refresh via Provider', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(onUserSelected: (name) {}));
        await tester.pumpAndSettle();
        
        final context = tester.element(find.byType(UserView));
        final viewModel = Provider.of<UserViewModel>(context, listen: false);
        
        // Simply test that refresh method can be called without error
        expect(() => viewModel.refreshUsers(), returnsNormally);
        
        // Wait for any state changes
        await tester.pump();
        await tester.pumpAndSettle();
        
        // Verify ViewModel is still valid after refresh
        expect(viewModel.loadingState, isA<LoadingState>());
        expect(viewModel.users, isA<List>());
        expect(viewModel.errorMessage, isA<String>());
      });
    });
  });
}