import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/notifications/data/datasources/notification_local_datasource.dart';
import '../../features/notifications/data/models/notification_model.dart';

/// Top-level handler for FCM messages received when the app is in the background/terminated.
/// Must be a top-level (non-class) function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final prefs = await SharedPreferences.getInstance();
  final datasource = NotificationLocalDataSourceImpl(prefs);
  await datasource.save(_toModel(message));
}

class FcmService {
  FcmService._();
  static final FcmService instance = FcmService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  static const _channelId = 'smart_gate_alerts';
  static const _channelName = 'Smart Gate Alerts';

  /// Broadcast stream so the NotificationBloc can react to foreground messages.
  final _messageController = StreamController<RemoteMessage>.broadcast();
  Stream<RemoteMessage> get onMessage => _messageController.stream;

  Future<void> init(NotificationLocalDataSource localDataSource) async {
    await _requestPermission();
    await _setupLocalNotifications();

    // Register the top-level background handler once.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Foreground: save + show heads-up notification + broadcast.
    FirebaseMessaging.onMessage.listen((message) async {
      final model = _toModel(message);
      await localDataSource.save(model);
      _showLocalNotification(model);
      _messageController.add(message);
    });

    // User tapped a notification while app was in background (not terminated).
    FirebaseMessaging.onMessageOpenedApp.listen(_messageController.add);
  }

  Future<String?> getToken() => _messaging.getToken();

  // ---------------------------------------------------------------------------

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _setupLocalNotifications() async {
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  void _showLocalNotification(NotificationModel model) {
    _localNotifications.show(
      model.id.hashCode,
      model.title,
      model.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }
}

NotificationModel _toModel(RemoteMessage message) {
  return NotificationModel.fromFcm(
    id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
    title: message.notification?.title ?? message.data['title'] ?? 'Smart Gate',
    body: message.notification?.body ?? message.data['body'] ?? '',
    data: message.data.map((k, v) => MapEntry(k, v.toString())),
  );
}
