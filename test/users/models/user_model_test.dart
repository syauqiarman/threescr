import 'package:flutter_test/flutter_test.dart';
import 'package:threescr/users/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    group('Constructor Tests - Positive Cases', () {
      test('should create UserModel with all required fields', () {
        const user = UserModel(
          id: 1,
          email: 'george.bluth@reqres.in',
          firstName: 'George',
          lastName: 'Bluth',
          avatar: 'https://reqres.in/img/faces/1-image.jpg',
        );

        expect(user.id, equals(1));
        expect(user.email, equals('george.bluth@reqres.in'));
        expect(user.firstName, equals('George'));
        expect(user.lastName, equals('Bluth'));
        expect(user.avatar, equals('https://reqres.in/img/faces/1-image.jpg'));
      });

      test('should create const UserModel', () {
        const user1 = UserModel(
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
          avatar: 'https://example.com/avatar.jpg',
        );

        const user2 = UserModel(
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
          avatar: 'https://example.com/avatar.jpg',
        );

        expect(identical(user1, user2), isTrue);
      });
    });

    group('fromJson Tests - Positive Cases', () {
      test('should create UserModel from valid JSON', () {
        final json = {
          'id': 1,
          'email': 'george.bluth@reqres.in',
          'first_name': 'George',
          'last_name': 'Bluth',
          'avatar': 'https://reqres.in/img/faces/1-image.jpg',
        };

        final user = UserModel.fromJson(json);

        expect(user.id, equals(1));
        expect(user.email, equals('george.bluth@reqres.in'));
        expect(user.firstName, equals('George'));
        expect(user.lastName, equals('Bluth'));
        expect(user.avatar, equals('https://reqres.in/img/faces/1-image.jpg'));
      });

      test('should handle JSON with different data types', () {
        final json = {
          'id': 2,
          'email': 'janet.weaver@reqres.in',
          'first_name': 'Janet',
          'last_name': 'Weaver',
          'avatar': 'https://reqres.in/img/faces/2-image.jpg',
        };

        final user = UserModel.fromJson(json);

        expect(user.id, equals(2));
        expect(user.email, equals('janet.weaver@reqres.in'));
        expect(user.firstName, equals('Janet'));
        expect(user.lastName, equals('Weaver'));
      });
    });

    group('toJson Tests - Positive Cases', () {
      test('should convert UserModel to JSON', () {
        const user = UserModel(
          id: 1,
          email: 'george.bluth@reqres.in',
          firstName: 'George',
          lastName: 'Bluth',
          avatar: 'https://reqres.in/img/faces/1-image.jpg',
        );

        final json = user.toJson();

        expect(json['id'], equals(1));
        expect(json['email'], equals('george.bluth@reqres.in'));
        expect(json['first_name'], equals('George'));
        expect(json['last_name'], equals('Bluth'));
        expect(json['avatar'], equals('https://reqres.in/img/faces/1-image.jpg'));
      });
    });

    group('fullName Getter Tests - Positive Cases', () {
      test('should return correct full name', () {
        const user = UserModel(
          id: 1,
          email: 'george.bluth@reqres.in',
          firstName: 'George',
          lastName: 'Bluth',
          avatar: 'https://reqres.in/img/faces/1-image.jpg',
        );

        expect(user.fullName, equals('George Bluth'));
      });

      test('should handle names with spaces', () {
        const user = UserModel(
          id: 1,
          email: 'test@example.com',
          firstName: 'John Michael',
          lastName: 'Smith Wilson',
          avatar: 'https://example.com/avatar.jpg',
        );

        expect(user.fullName, equals('John Michael Smith Wilson'));
      });
    });

    group('Edge Cases', () {
      test('should handle empty strings', () {
        const user = UserModel(
          id: 0,
          email: '',
          firstName: '',
          lastName: '',
          avatar: '',
        );

        expect(user.id, equals(0));
        expect(user.email, equals(''));
        expect(user.firstName, equals(''));
        expect(user.lastName, equals(''));
        expect(user.avatar, equals(''));
        expect(user.fullName, equals(' '));
      });

      test('should handle special characters', () {
        const user = UserModel(
          id: 1,
          email: 'user@test.co.uk',
          firstName: 'Jean-Pierre',
          lastName: "O'Connor",
          avatar: 'https://example.com/avatar.jpg',
        );

        expect(user.email, equals('user@test.co.uk'));
        expect(user.firstName, equals('Jean-Pierre'));
        expect(user.lastName, equals("O'Connor"));
        expect(user.fullName, equals("Jean-Pierre O'Connor"));
      });

      test('should handle very long names', () {
        const longName = 'VeryLongFirstNameThatExceedsNormalLength';
        const user = UserModel(
          id: 1,
          email: 'test@example.com',
          firstName: longName,
          lastName: longName,
          avatar: 'https://example.com/avatar.jpg',
        );

        expect(user.firstName, equals(longName));
        expect(user.lastName, equals(longName));
        expect(user.fullName, equals('$longName $longName'));
      });
    });
  });

  group('UsersResponseModel Tests', () {
    group('Constructor Tests - Positive Cases', () {
      test('should create UsersResponseModel with all required fields', () {
        const user = UserModel(
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
          avatar: 'https://example.com/avatar.jpg',
        );

        const response = UsersResponseModel(
          page: 1,
          perPage: 10,
          total: 12,
          totalPages: 2,
          data: [user],
        );

        expect(response.page, equals(1));
        expect(response.perPage, equals(10));
        expect(response.total, equals(12));
        expect(response.totalPages, equals(2));
        expect(response.data, hasLength(1));
        expect(response.data.first, equals(user));
      });
    });

    group('fromJson Tests - Positive Cases', () {
      test('should create UsersResponseModel from valid JSON', () {
        final json = {
          'page': 1,
          'per_page': 10,
          'total': 12,
          'total_pages': 2,
          'data': [
            {
              'id': 1,
              'email': 'george.bluth@reqres.in',
              'first_name': 'George',
              'last_name': 'Bluth',
              'avatar': 'https://reqres.in/img/faces/1-image.jpg',
            },
            {
              'id': 2,
              'email': 'janet.weaver@reqres.in',
              'first_name': 'Janet',
              'last_name': 'Weaver',
              'avatar': 'https://reqres.in/img/faces/2-image.jpg',
            },
          ],
        };

        final response = UsersResponseModel.fromJson(json);

        expect(response.page, equals(1));
        expect(response.perPage, equals(10));
        expect(response.total, equals(12));
        expect(response.totalPages, equals(2));
        expect(response.data, hasLength(2));
        expect(response.data.first.firstName, equals('George'));
        expect(response.data.last.firstName, equals('Janet'));
      });

      test('should handle empty data array', () {
        final json = {
          'page': 1,
          'per_page': 10,
          'total': 0,
          'total_pages': 0,
          'data': [],
        };

        final response = UsersResponseModel.fromJson(json);

        expect(response.page, equals(1));
        expect(response.perPage, equals(10));
        expect(response.total, equals(0));
        expect(response.totalPages, equals(0));
        expect(response.data, isEmpty);
      });
    });

    group('Edge Cases', () {
      test('should handle large numbers', () {
        final json = {
          'page': 999,
          'per_page': 100,
          'total': 99999,
          'total_pages': 1000,
          'data': [],
        };

        final response = UsersResponseModel.fromJson(json);

        expect(response.page, equals(999));
        expect(response.perPage, equals(100));
        expect(response.total, equals(99999));
        expect(response.totalPages, equals(1000));
      });
    });
  });
}