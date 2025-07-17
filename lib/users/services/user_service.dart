import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static const String _baseUrl = 'https://reqres.in/api';
  static const String _apiKey = 'reqres-free-v1';
  
  Future<UsersResponseModel> getUsers({int page = 1, int perPage = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users?page=$page&per_page=$perPage'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'Flutter-App',
          'x-api-key': _apiKey,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return UsersResponseModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw _ApiRequiresAuthException('API key invalid or expired');
      } else if (response.statusCode == 404) {
        throw Exception('API endpoint not found.');
      } else if (response.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } on _ApiRequiresAuthException {
      rethrow;
    } on http.ClientException {
      throw Exception('Network connection failed. Please check your internet connection.');
    } on FormatException {
      throw Exception('Invalid response format from server.');
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No internet connection. Please check your network.');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout. Please try again.');
      } else {
        throw Exception('Network error: $e');
      }
    }
  }
}

// Custom exception untuk API authentication
class _ApiRequiresAuthException implements Exception {
  final String message;
  _ApiRequiresAuthException(this.message);
  
  @override
  String toString() => message;
}