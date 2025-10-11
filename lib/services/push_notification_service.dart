import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotificationService {
  static Future<void> sendMessage(String messageText, String username) async {
    // Load the service account JSON file
    final jsonString = await rootBundle.loadString(
      'assets/service-account.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final credentials = auth.ServiceAccountCredentials.fromJson(jsonString);
    final projectId = jsonMap['project_id'];

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await auth.clientViaServiceAccount(credentials, scopes);

    final url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
    );

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

    await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    client.close();
  }
}
