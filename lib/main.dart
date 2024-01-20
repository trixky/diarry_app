import 'package:diaryapp/firebase_options.dart';
import 'package:diaryapp/layout/layout.dart';
import 'package:diaryapp/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Help links:
// - https://www.youtube.com/watch?v=k7TVYn5jwQk
// - https://www.youtube.com/watch?v=u3RrUjqOg_A
// - https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/learn/lecture/37736668#overview

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          return const Layout();
        },
      ),
    );
  }
}
