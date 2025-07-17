import 'package:flutter_test/flutter_test.dart';
import 'package:threescr/welcome/models/welcome_model.dart';

void main() {
  group('WelcomeModel Tests', () {
    group('Constructor Tests', () {
      test('should create WelcomeModel with required fields', () {
        const model = WelcomeModel(
          userName: 'John Doe',
          selectedUserName: 'Jane Smith',
        );

        expect(model.userName, equals('John Doe'));
        expect(model.selectedUserName, equals('Jane Smith'));
      });
    });

    group('Factory Constructor Tests', () {
      test('should create empty WelcomeModel with default values', () {
        final model = WelcomeModel.empty();

        expect(model.userName, equals(''));
        expect(model.selectedUserName, equals('Selected User Name'));
      });
    });

    group('CopyWith Tests', () {
      test('should copy with new userName', () {
        const original = WelcomeModel(
          userName: 'John',
          selectedUserName: 'Jane',
        );

        final copied = original.copyWith(userName: 'Bob');

        expect(copied.userName, equals('Bob'));
        expect(copied.selectedUserName, equals('Jane'));
      });

      test('should copy with new selectedUserName', () {
        const original = WelcomeModel(
          userName: 'John',
          selectedUserName: 'Jane',
        );

        final copied = original.copyWith(selectedUserName: 'Alice');

        expect(copied.userName, equals('John'));
        expect(copied.selectedUserName, equals('Alice'));
      });
    });
  });
}