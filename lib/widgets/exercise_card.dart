import 'package:flutter/material.dart';
import '../models/exercise_type.dart';
import '../screens/home_screen.dart';

class ExerciseCard extends StatefulWidget {
  final ExerciseType exerciseType;

  const ExerciseCard({
    Key? key,
    required this.exerciseType,
  }) : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          widget.exerciseType.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.exerciseType.description),
                const SizedBox(height: 16),
                ...widget.exerciseType.exercises.map(
                  (exercise) => ListTile(
                    title: Text(exercise.name),
                    subtitle: Text(exercise.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            exercise: exercise,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
      ),
    );
  }
}
