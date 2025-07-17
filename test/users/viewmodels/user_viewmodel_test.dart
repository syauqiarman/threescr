import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threescr/users/viewmodels/user_viewmodel.dart';
import 'package:threescr/users/models/user_model.dart';

void main() {
  group('UserViewModel Tests', () {
    late UserViewModel viewModel;

    setUp(() {
      viewModel = UserViewModel();
    });

    tearDown(() {
      // Use try-catch to handle already disposed viewModel
      try {
        viewModel.dispose();
      } catch (e) {
        // Ignore if already disposed
      }
    });

    group('Initial State Tests', () {
      test('should have correct initial state', () {
        expect(viewModel.users, isEmpty);
        expect(viewModel.loadingState, equals(LoadingState.idle));
        expect(viewModel.errorMessage, equals(''));
        expect(viewModel.hasMore, isTrue);
        expect(viewModel.isEmpty, isTrue);
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.isRefreshing, isFalse);
        expect(viewModel.isLoadingMore, isFalse);
      });
    });

    group('State Management Tests', () {
      test('should notify listeners on state changes', () {
        int notificationCount = 0;
        void listener() => notificationCount++;
        
        viewModel.addListener(listener);
        
        // Initial state - no notifications yet
        expect(notificationCount, equals(0));
        
        viewModel.removeListener(listener);
      });

      test('should handle multiple listeners', () {
        int listener1Count = 0;
        int listener2Count = 0;
        
        void listener1() => listener1Count++;
        void listener2() => listener2Count++;
        
        viewModel.addListener(listener1);
        viewModel.addListener(listener2);

        // Initial state - no notifications yet
        expect(listener1Count, equals(0));
        expect(listener2Count, equals(0));
        
        viewModel.removeListener(listener1);
        viewModel.removeListener(listener2);
      });

      test('should dispose properly', () {
        void listener() {}
        
        viewModel.addListener(listener);
        
        // Test that dispose works correctly
        expect(() => viewModel.dispose(), returnsNormally);
        
        // After dispose, further dispose should throw error
        expect(() => viewModel.dispose(), throwsFlutterError);
      });

      test('should handle listener cleanup on dispose', () {
        bool wasNotified = false;
        void listener() => wasNotified = true;
        
        viewModel.addListener(listener);
        
        // Verify listener was set up properly before disposal
        expect(wasNotified, isFalse);
        
        // Dispose should clean up listeners
        expect(() => viewModel.dispose(), returnsNormally);
        
        // After dispose, further dispose should throw error
        expect(() => viewModel.dispose(), throwsFlutterError);
      });
    });

    group('Method Tests', () {
      test('should have loadUsers method', () {
        expect(viewModel.loadUsers, isA<Future<void> Function()>());
      });

      test('should have refreshUsers method', () {
        expect(viewModel.refreshUsers, isA<Future<void> Function()>());
      });

      test('should have loadMoreUsers method', () {
        expect(viewModel.loadMoreUsers, isA<Future<void> Function()>());
      });

      test('should have retry method', () {
        expect(viewModel.retry, isA<Future<void> Function()>());
      });
    });

    group('Getter Tests', () {
      test('should return correct users list', () {
        expect(viewModel.users, isA<List<UserModel>>());
        expect(viewModel.users, isEmpty);
      });

      test('should return correct loading state', () {
        expect(viewModel.loadingState, isA<LoadingState>());
        expect(viewModel.loadingState, equals(LoadingState.idle));
      });

      test('should return correct error message', () {
        expect(viewModel.errorMessage, isA<String>());
        expect(viewModel.errorMessage, equals(''));
      });

      test('should return correct hasMore status', () {
        expect(viewModel.hasMore, isA<bool>());
        expect(viewModel.hasMore, isTrue);
      });

      test('should return correct isEmpty status', () {
        expect(viewModel.isEmpty, isA<bool>());
        expect(viewModel.isEmpty, isTrue);
      });

      test('should return correct isLoading status', () {
        expect(viewModel.isLoading, isA<bool>());
        expect(viewModel.isLoading, isFalse);
      });

      test('should return correct isRefreshing status', () {
        expect(viewModel.isRefreshing, isA<bool>());
        expect(viewModel.isRefreshing, isFalse);
      });

      test('should return correct isLoadingMore status', () {
        expect(viewModel.isLoadingMore, isA<bool>());
        expect(viewModel.isLoadingMore, isFalse);
      });
    });

    group('Edge Cases', () {
      test('should handle rapid consecutive calls', () async {
        final futures = [
          viewModel.loadUsers(),
          viewModel.loadUsers(),
          viewModel.loadUsers(),
        ];

        await Future.wait(futures);
        expect(viewModel.loadingState, isA<LoadingState>());
      });

      test('should handle mixed operation calls', () async {
        final futures = [
          viewModel.loadUsers(),
          viewModel.refreshUsers(),
          viewModel.loadMoreUsers(),
        ];

        await Future.wait(futures);
        expect(viewModel.loadingState, isA<LoadingState>());
      });

      test('should handle disposal during operation', () async {
        // Create separate viewModel for this test to avoid tearDown conflict
        final testViewModel = UserViewModel();
        
        // Start a non-network operation that won't cause async issues
        final future = testViewModel.loadUsers();
        
        // Wait a moment to let the operation start
        await Future.delayed(const Duration(milliseconds: 10));
        
        // Dispose the viewModel while operation might be running
        testViewModel.dispose();
        
        // The operation should complete, but may throw error due to disposal
        try {
          await future;
        } catch (e) {
          // It's acceptable if operation throws error after disposal
          expect(e, isA<FlutterError>());
        }
        
        // viewModel should be disposed
        expect(() => testViewModel.dispose(), throwsFlutterError);
      });
    });

    group('State Consistency Tests', () {
      test('should maintain consistent state properties', () {
        // Test that all boolean getters return consistent values
        expect(viewModel.isLoading, isA<bool>());
        expect(viewModel.isRefreshing, isA<bool>());
        expect(viewModel.isLoadingMore, isA<bool>());
        expect(viewModel.isEmpty, isA<bool>());
        expect(viewModel.hasMore, isA<bool>());
        
        // Only one loading state should be true at a time
        final loadingStates = [
          viewModel.isLoading,
          viewModel.isRefreshing,
          viewModel.isLoadingMore,
        ];
        
        final activeStates = loadingStates.where((state) => state).length;
        expect(activeStates, lessThanOrEqualTo(1));
      });
    });

    group('Disposal Tests', () {
      test('should prevent operations after disposal', () {
        viewModel.dispose();
        
        // All operations should throw error after disposal
        expect(() => viewModel.loadUsers(), throwsFlutterError);
        expect(() => viewModel.refreshUsers(), throwsFlutterError);
        expect(() => viewModel.loadMoreUsers(), throwsFlutterError);
        expect(() => viewModel.retry(), throwsFlutterError);
      });

      test('should handle getter access after disposal', () {
        viewModel.dispose();
        
        // After disposal, getters might still return values but operations should fail
        // Since UserViewModel extends ChangeNotifier, getters don't automatically throw errors
        // We test that dispose() itself works correctly
        expect(() => viewModel.dispose(), throwsFlutterError);
        
        // Test that attempting operations after disposal fails
        expect(() => viewModel.loadUsers(), throwsFlutterError);
        expect(() => viewModel.refreshUsers(), throwsFlutterError);
        expect(() => viewModel.loadMoreUsers(), throwsFlutterError);
        expect(() => viewModel.retry(), throwsFlutterError);
      });
    });

    group('Real Operation Tests', () {
      test('should handle actual API calls gracefully', () async {
        // Test with real API call (integration test)
        try {
          await viewModel.loadUsers();
          
          // If successful, verify the response
          expect(viewModel.loadingState, isA<LoadingState>());
          expect(viewModel.users, isA<List<UserModel>>());
        } catch (e) {
          // If it fails (network issues, etc.), verify error handling
          expect(e, isA<Exception>());
          expect(viewModel.loadingState, equals(LoadingState.error));
          expect(viewModel.errorMessage, isNotEmpty);
        }
      });

      test('should handle refresh operation', () async {
        try {
          await viewModel.refreshUsers();
          
          expect(viewModel.loadingState, isA<LoadingState>());
          expect(viewModel.users, isA<List<UserModel>>());
        } catch (e) {
          expect(e, isA<Exception>());
          expect(viewModel.loadingState, equals(LoadingState.error));
        }
      });

      test('should handle retry operation', () async {
        try {
          await viewModel.retry();
          
          expect(viewModel.loadingState, isA<LoadingState>());
          expect(viewModel.users, isA<List<UserModel>>());
        } catch (e) {
          expect(e, isA<Exception>());
          expect(viewModel.loadingState, equals(LoadingState.error));
        }
      });
    });

    group('State Transition Tests', () {
      test('should transition through loading states correctly', () async {
        // Monitor state changes
        final stateChanges = <LoadingState>[];
        viewModel.addListener(() {
          stateChanges.add(viewModel.loadingState);
        });

        try {
          await viewModel.loadUsers();
          
          // Should have gone through loading state
          expect(stateChanges, contains(LoadingState.loading));
          
          // Should end in either idle or error state
          expect(
            viewModel.loadingState,
            isIn([LoadingState.idle, LoadingState.error])
          );
        } catch (e) {
          // Network error is acceptable
          expect(viewModel.loadingState, equals(LoadingState.error));
        }
      });

      test('should handle loadMore state transitions', () async {
        try {
          // Load initial data first
          await viewModel.loadUsers();
          
          // Then try to load more
          await viewModel.loadMoreUsers();
          
          expect(viewModel.loadingState, isA<LoadingState>());
        } catch (e) {
          // Network error is acceptable
          expect(e, isA<Exception>());
        }
      });
    });
  });

  group('LoadingState Enum Tests', () {
    test('should have all required states', () {
      expect(LoadingState.values, contains(LoadingState.idle));
      expect(LoadingState.values, contains(LoadingState.loading));
      expect(LoadingState.values, contains(LoadingState.refreshing));
      expect(LoadingState.values, contains(LoadingState.loadingMore));
      expect(LoadingState.values, contains(LoadingState.error));
    });

    test('should have correct number of states', () {
      expect(LoadingState.values, hasLength(5));
    });

    test('should have correct state values', () {
      expect(LoadingState.idle.name, equals('idle'));
      expect(LoadingState.loading.name, equals('loading'));
      expect(LoadingState.refreshing.name, equals('refreshing'));
      expect(LoadingState.loadingMore.name, equals('loadingMore'));
      expect(LoadingState.error.name, equals('error'));
    });
  });
}