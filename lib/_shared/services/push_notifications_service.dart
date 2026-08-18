import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meno/_core/_core.dart' show MLogger;

class PushNotificationsService with MLogger {
  const PushNotificationsService(this._fcm);

  final FirebaseMessaging _fcm;

  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;

  Stream<RemoteMessage> get onMessageOpenedApp {
    return FirebaseMessaging.onMessageOpenedApp;
  }

  Future<NotificationSettings> requestPermissions() {
    return _fcm.requestPermission(provisional: true);
  }

  Future<RemoteMessage?> getInitialMessage() => _fcm.getInitialMessage();

  Future<String?> getToken() async {
    try {
      final token = await _fcm.getToken();
      log.d('PUSH NOTIFICATION TOKEN: $token');
      return token;
    } on Exception catch (error) {
      log.e('Error getting token', error: error);
      return null;
    }
  }
}
