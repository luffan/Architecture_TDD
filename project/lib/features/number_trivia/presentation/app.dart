import 'package:architecture_tdd/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        hintColor: Colors.green.shade600,
      ),
      home: NumberTriviaPage(),
    );
  }
}