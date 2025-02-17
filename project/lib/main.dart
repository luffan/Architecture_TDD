import 'package:architecture_tdd/di/injectable.dart';
import 'package:architecture_tdd/features/number_trivia/presentation/app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const App());
}

