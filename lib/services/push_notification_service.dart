import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotificationService {
  static Future<void> sendMessage(String messageText, String username) async {
    // Load service account JSON
    final jsonString = await rootBundle.loadString(
      'assets/service-account.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Pass Map to fromJson, not String
    final credentials = auth.ServiceAccountCredentials.fromJson(jsonMap);
    final projectId = jsonMap['project_id'];

    // Create auth client
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await auth.clientViaServiceAccount(credentials, scopes);

    // FCM REST API URL
    final url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
    );

    // Message payload
    final payload = {
      'message': {
        'topic': 'chat',
        'notification': {
          'title': '$username sent a message',
          'body': messageText,
        },
        'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'},
      },
    };

    // Send the request
    await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    client.close();
  }
}
