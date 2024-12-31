import 'package:flutter/material.dart';

class CurrentExerciseWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Seviye: 8', // Seviye numarasını burada güncelle
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
