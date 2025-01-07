import 'package:flutter/material.dart';
import '../models/exercise_type.dart';
import '../widgets/exercise_card.dart';

class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        title: const Text('EGZERSİZLER'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: exerciseTypes
            .map((type) => ExerciseCard(exerciseType: type))
            .toList(),
      ),
    );
  }
}
