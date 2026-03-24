# 🎤 Voice Training App

This project is a Flutter-based mobile application designed to help users improve their vocal skills through interactive exercises and real-time audio analysis.

## 📌 About the Project

This application was developed as a personal project to explore mobile development with Flutter and audio processing concepts.

The main goal of the app is to provide users with voice exercises and analyze their pitch in real-time, helping them practice and improve their vocal control.

## ✨ Features

- 🎶 Real-time pitch detection
- 📊 Visual feedback for voice analysis
- 🎤 Interactive voice exercises
- 📱 Clean and simple user interface

## 🛠️ Technologies Used

- Flutter (Dart)
- Platform Channels (Flutter ↔ Native communication)
- Native audio processing (Android - Kotlin)
- **TarsosDSP** `2.5` (pitch detection engine)


## ⚙️ How It Works

1. The user starts a voice exercise from the UI.
2. Flutter communicates with the native Android layer using MethodChannel.
3. The native side records audio using `AudioRecord`.
4. The recorded audio is analyzed to detect pitch.
5. Results are sent back to Flutter and displayed to the user.

## 🚧 What I Learned

- Basics of Flutter app development
- Working with platform-specific code (Flutter & Kotlin integration)
- Handling real-time audio data
- Structuring a mobile application



## ▶️ Getting Started

To run this project locally:

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
flutter pub get
flutter run
