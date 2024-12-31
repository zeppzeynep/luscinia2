import 'package:flutter/material.dart';
import '../widgets/progressbar_widget.dart';
import '../widgets/current_exercise_widget.dart';

import '../widgets/play_button_widget.dart';
import '../widgets/microphone_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Luscinia - Ses Egzersizi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            // Scrollbar widget
            Expanded(
              flex: 1,
              child: ProgressbarWidget(),
            ),
            SizedBox(height: 10),
            // Seviye metni widget
            Expanded(
              flex: 1,
              child: Center(
                child: CurrentExerciseWidget(),
              ),
            ),
            SizedBox(height: 20),
            // Piyano widget
            Expanded(
              flex: 4,
              child: PlayButtonWidget(),
            ),
            SizedBox(height: 10),
            // Mikrofon ve ses dalgaları widget
            Expanded(
              flex: 2,
              child: MicrophoneWidget(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
