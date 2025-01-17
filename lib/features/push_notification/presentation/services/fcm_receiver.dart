
import 'package:core/utils/app_logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tmail_ui_user/features/push_notification/domain/exceptions/fcm_exception.dart';
import 'package:tmail_ui_user/features/push_notification/presentation/services/fcm_service.dart';

@pragma('vm:entry-point')
Future<void> handleFirebaseBackgroundMessage(RemoteMessage message) async {
  log('FcmReceiver::handleFirebaseBackgroundMessage():messageId: ${message.messageId}');
  log('FcmReceiver::handleFirebaseBackgroundMessage(): ${message.data}');
  FcmService.instance.handleFirebaseBackgroundMessage(message);
}

class FcmReceiver {
  FcmReceiver._internal();

  static final FcmReceiver _instance = FcmReceiver._internal();

  static FcmReceiver get instance => _instance;

  void onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(FcmService.instance.handleFirebaseForegroundMessage);
  }

  void onBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(handleFirebaseBackgroundMessage);
  }

  void getFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken(vapidKey: kIsWeb ? dotenv.get('FIREBASE_WEB_VAPID_PUBLIC_KEY', fallback: '') : null);
      log('FcmReceiver::onFcmToken():token: $token');
      FcmService.instance.handleRefreshToken(token);
    } catch(e) {
      log('FcmReceiver::onFcmToken():exception: $e');
      throw NotLoadedFCMTokenException();
    }
  }

  void onRefreshFcmToken() {
    FirebaseMessaging.instance.onTokenRefresh.listen(FcmService.instance.handleRefreshToken);
  }
}