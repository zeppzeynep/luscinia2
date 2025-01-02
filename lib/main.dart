import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/exercise_list_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luscinia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Başlangıç ekranı olarak WelcomeScreen'i göster
      home: const WelcomeScreen(),
      // Route'ları tanımla
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/exercise-list': (context) => const ExerciseListScreen(),
      },
    );
  }
}
