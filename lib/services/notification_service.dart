import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    // Request notification permissions
    await _fcm.requestPermission();

    // Initialize Flutter Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Get FCM token
    String? token = await _fcm.getToken();
    print("FCM Token: $token");

    // TODO: Send this token to your Django backend
  }

  void setupInteractedMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received a message in the foreground!');

      // Print the entire message data payload
      if (message.data.isNotEmpty) {
        print('Message data: ${message.data}');
      }

      // Print the notification title and body, if available
      if (message.notification != null) {
        print('Notification Title: ${message.notification!.title}');
        print('Notification Body: ${message.notification!.body}');

        // Show the notification
        await _showNotification(
          message.notification!.title,
          message.notification!.body,
        );
      }
    });
  }

  Future<void> _showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel', // Channel ID
      'Default', // Channel name
      channelDescription: 'Default channel for notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
