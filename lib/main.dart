import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:let_us_webtoon/login_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Let Us Webtoon',
      theme: ThemeData(
        useMaterial3: true, // Enable Material 3 styling
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple, // Customize primary color
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orangeAccent, // Customize dark mode primary color
            brightness: Brightness.dark,
          ),
          textTheme: const TextTheme(
            displaySmall:
                TextStyle(color: Colors.orangeAccent), // Customize font color
            displayMedium:
                TextStyle(color: Colors.orangeAccent), // Customize font color
            displayLarge:
                TextStyle(color: Colors.orangeAccent), // Customize font color
            headlineSmall:
                TextStyle(color: Colors.orangeAccent), // Customize font color
            headlineMedium:
                TextStyle(color: Colors.orangeAccent), // Customize font color
            headlineLarge:
                TextStyle(color: Colors.orangeAccent), // Customize font color
            titleSmall:
                TextStyle(color: Colors.orangeAccent), // Customize font color
            titleMedium:
                TextStyle(color: Colors.orangeAccent), // Customize font color
            titleLarge:
                TextStyle(color: Colors.orangeAccent), // Customize font color
            labelLarge:
                TextStyle(color: Colors.orangeAccent), // Customize font color
            labelMedium:
                TextStyle(color: Colors.orangeAccent), // Customize font color
            labelSmall:
                TextStyle(color: Colors.orangeAccent), // Customize font color
            bodySmall:
                TextStyle(color: Colors.orangeAccent), // Customize font color
            bodyMedium:
                TextStyle(color: Colors.orangeAccent), // Customize font color
            bodyLarge:
                TextStyle(color: Colors.orangeAccent), // Customize font color
          ),
          iconTheme: const IconThemeData(color: Colors.amberAccent)),
      themeMode: ThemeMode.dark, // Always use dark theme
      home: const LoginScreen(),
    );
  }
}
