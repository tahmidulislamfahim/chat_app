import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS not configured');
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS not configured');
      case TargetPlatform.windows:
        throw UnsupportedError('Windows not configured');
      case TargetPlatform.linux:
        throw UnsupportedError('Linux not configured');
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  static FirebaseOptions get android {
    final env = dotenv.env;

    final apiKey = env['FIREBASE_API_KEY'];
    final appId = env['FIREBASE_APP_ID'];
    final messagingSenderId = env['FIREBASE_MESSAGING_SENDER_ID'];
    final projectId = env['FIREBASE_PROJECT_ID'];
    final storageBucket = env['FIREBASE_STORAGE_BUCKET']; // optional

    if (apiKey == null ||
        appId == null ||
        messagingSenderId == null ||
        projectId == null) {
      throw StateError(
        'Missing one or more required Firebase configuration environment variables. '
        'Check .env for FIREBASE_API_KEY, FIREBASE_APP_ID, '
        'FIREBASE_MESSAGING_SENDER_ID, FIREBASE_PROJECT_ID.',
      );
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: storageBucket, // can be null
    );
  }
}
