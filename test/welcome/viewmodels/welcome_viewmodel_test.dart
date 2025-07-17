import 'package:flutter_test/flutter_test.dart';
import 'package:threescr/welcome/viewmodels/welcome_viewmodel.dart';

void main() {
  group('WelcomeViewModel Tests', () {
    late WelcomeViewModel viewModel;

    setUp(() {
      viewModel = WelcomeViewModel();
    });

    group('User Change Detection Tests', () {
      test('should detect user change correctly', () {
        // Initial state
        expect(viewModel.hasUserChanged('John'), isTrue);
        
        // Initialize with John
        viewModel.initializeWithName('John');
        expect(viewModel.hasUserChanged('John'), isFalse);
        expect(viewModel.hasUserChanged('Jane'), isTrue);
      });

      test('should reset selectedUserName when user changes', () {
        // Initialize with John
        viewModel.initializeWithName('John');
        viewModel.updateSelectedUserName('Rachel');
        expect(viewModel.selectedUserName, equals('Rachel'));
        
        // Change to different user
        viewModel.initializeWithName('Jane');
        expect(viewModel.selectedUserName, equals('Selected User Name'));
        expect(viewModel.userName, equals('Jane'));
      });

      test('should preserve selectedUserName when same user', () {
        // Initialize with John
        viewModel.initializeWithName('John');
        viewModel.updateSelectedUserName('Rachel');
        expect(viewModel.selectedUserName, equals('Rachel'));
        
        // Same user again
        viewModel.initializeWithName('John');
        expect(viewModel.selectedUserName, equals('Rachel'));
        expect(viewModel.userName, equals('John'));
      });

      test('should handle trimmed names correctly', () {
        viewModel.initializeWithName('  John  ');
        viewModel.updateSelectedUserName('Rachel');
        
        // Same name with different whitespace
        viewModel.initializeWithName('John');
        expect(viewModel.selectedUserName, equals('Rachel'));
        
        // Different name
        viewModel.initializeWithName('  Jane  ');
        expect(viewModel.selectedUserName, equals('Selected User Name'));
      });
    });

    group('Reset State Tests', () {
      test('should reset complete state', () {
        viewModel.initializeWithName('John');
        viewModel.updateSelectedUserName('Rachel');
        
        viewModel.resetState();
        
        expect(viewModel.userName, equals(''));
        expect(viewModel.selectedUserName, equals('Selected User Name'));
      });

      test('should reset only selectedUser', () {
        viewModel.initializeWithName('John');
        viewModel.updateSelectedUserName('Rachel');
        
        viewModel.resetSelectedUser();
        
        expect(viewModel.userName, equals('John'));
        expect(viewModel.selectedUserName, equals('Selected User Name'));
      });
    });

    group('Edge Cases', () {
      test('should handle empty string transitions', () {
        viewModel.initializeWithName('John');
        viewModel.updateSelectedUserName('Rachel');
        
        // Empty string should not change state
        viewModel.initializeWithName('');
        expect(viewModel.userName, equals('John'));
        expect(viewModel.selectedUserName, equals('Rachel'));
      });

      test('should handle whitespace-only names', () {
        viewModel.initializeWithName('John');
        viewModel.updateSelectedUserName('Rachel');
        
        // Whitespace-only should not change state
        viewModel.initializeWithName('   ');
        expect(viewModel.userName, equals('John'));
        expect(viewModel.selectedUserName, equals('Rachel'));
      });

      test('should handle case sensitivity', () {
        viewModel.initializeWithName('John');
        viewModel.updateSelectedUserName('Rachel');
        
        // Different case should reset
        viewModel.initializeWithName('john');
        expect(viewModel.selectedUserName, equals('Selected User Name'));
      });
    });
  });
}