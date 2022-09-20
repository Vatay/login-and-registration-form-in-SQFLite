import 'package:flutter/material.dart';
import 'package:form/screens/persons_list_screen.dart';
import 'package:form/screens/sign_in.dart';
import 'package:form/screens/sign_up_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forms',
      theme: ThemeData.dark(),
      home: SignUpScreen(),
      routes: {
        '/sign_up': (context) => SignUpScreen(),
        '/sign_in': (context) => SignInScreen(),
        '/persons': (context) => PersonsListScreen(),
      },
    );
  }
}
