class ExerciseType {
  final String title;
  final String description;
  final List<Exercise> exercises;

  ExerciseType({
    required this.title,
    required this.description,
    required this.exercises,
  });
}

class Exercise {
  final String name;
  final String description;
  final List<ExerciseStep> steps;

  Exercise({
    required this.name,
    required this.description,
    required this.steps,
  });
}

class ExerciseStep {
  final int stepNumber;
  final String audioPath;
  final String title;
  final String description;

  ExerciseStep({
    required this.stepNumber,
    required this.audioPath,
    required this.title,
    required this.description,
  });
}

final List<ExerciseType> exerciseTypes = [
  ExerciseType(
    title: 'Vowels',
    description: 'Sesli harflerin doğru telaffuzu için egzersizler',
    exercises: [
      Exercise(
        name: 'Vowels Exercise',
        description: 'Temel sesli harf egzersizi',
        steps: [
          ExerciseStep(
            stepNumber: 1,
            audioPath: 'assets/audio/vowel/vowel1.mp3',
            title: '1. Adım: DO',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 2,
            audioPath: 'assets/audio/vowel/vowel2.mp3',
            title: '2. Adım: RE',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 3,
            audioPath: 'assets/audio/vowel/vowel3.mp3',
            title: '3. Adım: Mİ',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 4,
            audioPath: 'assets/audio/vowel/vowel4.mp3',
            title: '4. Adım: FA',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 5,
            audioPath: 'assets/audio/vowel/vowel5.mp3',
            title: '5. Adım: SOL',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 6,
            audioPath: 'assets/audio/vowel/vowel6.mp3',
            title: '6. Adım: LA',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 7,
            audioPath: 'assets/audio/vowel/vowel7.mp3',
            title: '7. Adım: Sİ',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 8,
            audioPath: 'assets/audio/vowel/vowel8.mp3',
            title: '8. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 9,
            audioPath: 'assets/audio/vowel/vowel9.mp3',
            title: '9. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 10,
            audioPath: 'assets/audio/vowel/vowel10.mp3',
            title: '10. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 11,
            audioPath: 'assets/audio/vowel/vowel11.mp3',
            title: '11. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 12,
            audioPath: 'assets/audio/vowel/vowel12.mp3',
            title: '12. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 13,
            audioPath: 'assets/audio/vowel/vowel13.mp3',
            title: '13. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 14,
            audioPath: 'assets/audio/vowel/vowel14.mp3',
            title: '14. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 15,
            audioPath: 'assets/audio/vowel/vowel15.mp3',
            title: '15. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 16,
            audioPath: 'assets/audio/vowel/vowel16.mp3',
            title: '16. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 17,
            audioPath: 'assets/audio/vowel/vowel17.mp3',
            title: '17. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 18,
            audioPath: 'assets/audio/vowel/vowel18.mp3',
            title: '18. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 19,
            audioPath: 'assets/audio/vowel/vowel19.mp3',
            title: '19. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 20,
            audioPath: 'assets/audio/vowel/vowel20.mp3',
            title: '20. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 21,
            audioPath: 'assets/audio/vowel/vowel21.mp3',
            title: '21. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 22,
            audioPath: 'assets/audio/vowel/vowel22.mp3',
            title: '22. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 23,
            audioPath: 'assets/audio/vowel/vowel23.mp3',
            title: '23. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 24,
            audioPath: 'assets/audio/vowel/vowel24.mp3',
            title: '24. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
          ExerciseStep(
            stepNumber: 25,
            audioPath: 'assets/audio/vowel/vowel25.mp3',
            title: '25. Adım: X',
            description: 'Doğru notayı a-e-i-o-u sesleriyle çalışın',
          ),
        ],
      ),
      // Diğer egzersizler...
    ],
  ),

  ExerciseType(
    title: 'Vocal Dynamics',
    description: 'This vocal exercise trains your voice to be more dynamic.',
    exercises: [
      Exercise(
        name: 'Vocal Dynamics',
        description: 'x',
        steps: [
          ExerciseStep(
            stepNumber: 1,
            audioPath: 'assets/audio/vocal_dynamics/vd1.mp3',
            title: '1. Adım: DO',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 2,
            audioPath: 'assets/audio/vocal_dynamics/vd2.mp3',
            title: '2. Adım: DO#',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 3,
            audioPath: 'assets/audio/vocal_dynamics/vd3.mp3',
            title: '3. Adım: RE',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 4,
            audioPath: 'assets/audio/vocal_dynamics/vd4.mp3',
            title: '4. Adım: RE#',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 5,
            audioPath: 'assets/audio/vocal_dynamics/vd5.mp3',
            title: '5. Adım: Mİ',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 6,
            audioPath: 'assets/audio/vocal_dynamics/vd6.mp3',
            title: '6. Adım: FA',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 7,
            audioPath: 'assets/audio/vocal_dynamics/vd7.mp3',
            title: '7. Adım: FA#',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 8,
            audioPath: 'assets/audio/vocal_dynamics/vd8.mp3',
            title: '8. Adım: SOL',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 9,
            audioPath: 'assets/audio/vocal_dynamics/vd9.mp3',
            title: '9. Adım: SOL#',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 10,
            audioPath: 'assets/audio/vocal_dynamics/vd10.mp3',
            title: '10. Adım: LA',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 11,
            audioPath: 'assets/audio/vocal_dynamics/vd11.mp3',
            title: '11. Adım: LA#',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 12,
            audioPath: 'assets/audio/vocal_dynamics/vd12.mp3',
            title: '12. Adım: Sİ',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 13,
            audioPath: 'assets/audio/vocal_dynamics/vd13.mp3',
            title: '13. Adım: DO',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 14,
            audioPath: 'assets/audio/vocal_dynamics/vd14.mp3',
            title: '14. Adım: Sİ',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 15,
            audioPath: 'assets/audio/vocal_dynamics/vd15.mp3',
            title: '15. Adım: X',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 16,
            audioPath: 'assets/audio/vocal_dynamics/vd16.mp3',
            title: '16. Adım: X',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 17,
            audioPath: 'assets/audio/vocal_dynamics/vd17.mp3',
            title: '17. Adım: X',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 18,
            audioPath: 'assets/audio/vocal_dynamics/vd18.mp3',
            title: '18. Adım: X',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 19,
            audioPath: 'assets/audio/vocal_dynamics/vd19.mp3',
            title: '19. Adım: X',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 20,
            audioPath: 'assets/audio/vocal_dynamics/vd20.mp3',
            title: '20. Adım: X',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 21,
            audioPath: 'assets/audio/vocal_dynamics/vd21.mp3',
            title: '21. Adım: X',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 22,
            audioPath: 'assets/audio/vocal_dynamics/vd22.mp3',
            title: '22. Adım: X',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 23,
            audioPath: 'assets/audio/vocal_dynamics/vd23.mp3',
            title: '23. Adım: X',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 24,
            audioPath: 'assets/audio/vocal_dynamics/vd24.mp3',
            title: '24. Adım: X',
            description: 'x',
          ),
          ExerciseStep(
            stepNumber: 25,
            audioPath: 'assets/audio/vocal_dynamics/vd25.mp3',
            title: '25. Adım: X',
            description: 'x',
          )
        ],
      ),
      // Diğer egzersizler...
    ],
  ),
  // Diğer egzersiz türleri...
];
