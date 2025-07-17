import 'package:flutter/material.dart';
import 'package:threescr/palindrome/views/palindrome_view.dart';
import 'package:threescr/welcome/views/welcome_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/palindrome',
      routes: {
        '/palindrome': (context) => const PalindromeView(),
        '/welcome': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String?;
          return WelcomeView(userName: args ?? '');
        },
        '/users': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Function(String)?;
          return UsersView(onUserSelected: args ?? (String name) {});
        },
      },
    );
  }
}

// Temporary placeholder for UsersView
class UsersView extends StatelessWidget {
  final Function(String) onUserSelected;
  
  const UsersView({super.key, required this.onUserSelected});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: const Center(
        child: Text('Users Screen - Will be implemented next'),
      ),
    );
  }
}