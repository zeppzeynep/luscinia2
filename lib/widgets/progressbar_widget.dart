import 'package:flutter/material.dart';

class ProgressbarWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressbarWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: currentStep / totalSteps,
        ),
        const SizedBox(height: 8),
        Text(
          'Adım $currentStep / $totalSteps',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
