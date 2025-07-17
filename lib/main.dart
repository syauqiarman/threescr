import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threescr/palindrome/views/palindrome_view.dart';
import 'package:threescr/welcome/views/welcome_view.dart';
import 'package:threescr/users/views/user_view.dart';
import 'package:threescr/palindrome/viewmodels/palindrome_viewmodel.dart';
import 'package:threescr/welcome/viewmodels/welcome_viewmodel.dart';
import 'package:threescr/users/viewmodels/user_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PalindromeViewModel()),
        ChangeNotifierProvider(create: (_) => WelcomeViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MaterialApp(
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
            return UserView(onUserSelected: args ?? (String name) {});
          },
        },
      ),
    );
  }
}