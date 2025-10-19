import 'package:chat_app/app/app.dart';
import 'package:chat_app/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables. For mobile/desktop this reads from project root '.env'.
  // For web (if you added assets/.env and included it in pubspec.yaml) use 'assets/.env'.
  await dotenv.load(fileName: '.env');

  // 🧭 Transparent system bars + correct icon colors
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Ensure dotenv is loaded before calling Firebase.initializeApp because
  // DefaultFirebaseOptions reads values from dotenv.env at runtime.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const App());
}
