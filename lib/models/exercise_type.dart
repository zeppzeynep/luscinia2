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
    title: 'Vowel',
    description: 'Sesli harflerin doğru telaffuzu için egzersizler',
    exercises: [
      Exercise(
        name: 'Vowel Exercise',
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
        ],
      ),
      // Diğer egzersizler...
    ],
  ),
  ExerciseType(
    title: 'Articulation',
    description: 'Artikülasyon geliştirme egzersizleri',
    exercises: [
      // Articulation egzersizleri...
    ],
  ),
  // Diğer egzersiz türleri...
];
