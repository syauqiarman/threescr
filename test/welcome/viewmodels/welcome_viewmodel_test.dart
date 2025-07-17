import 'package:flutter_test/flutter_test.dart';
import 'package:threescr/welcome/viewmodels/welcome_viewmodel.dart';

void main() {
  group('WelcomeViewModel Tests', () {
    late WelcomeViewModel viewModel;

    setUp(() {
      viewModel = WelcomeViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initial State Tests', () {
      test('should have empty initial state', () {
        expect(viewModel.userName, equals(''));
        expect(viewModel.selectedUserName, equals('Selected User Name'));
      });
    });

    group('Update Methods Tests', () {
      test('should update userName correctly', () {
        viewModel.updateUserName('John Doe');
        expect(viewModel.userName, equals('John Doe'));
      });

      test('should update selectedUserName correctly', () {
        viewModel.updateSelectedUserName('Jane Smith');
        expect(viewModel.selectedUserName, equals('Jane Smith'));
      });

      test('should initialize with name', () {
        viewModel.initializeWithName('Test User');
        expect(viewModel.userName, equals('Test User'));
      });

      test('should reset selected user', () {
        viewModel.updateSelectedUserName('Jane Smith');
        viewModel.resetSelectedUser();
        expect(viewModel.selectedUserName, equals('Selected User Name'));
      });
    });

    group('Notification Tests', () {
      test('should notify listeners on userName update', () {
        bool wasNotified = false;
        viewModel.addListener(() => wasNotified = true);

        viewModel.updateUserName('John');
        expect(wasNotified, isTrue);
      });

      test('should notify listeners on selectedUserName update', () {
        bool wasNotified = false;
        viewModel.addListener(() => wasNotified = true);

        viewModel.updateSelectedUserName('Jane');
        expect(wasNotified, isTrue);
      });
    });
  });
}