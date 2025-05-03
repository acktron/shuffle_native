import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shuffle_native/services/api_service.dart';
// import 'main.dart'; // to access navigatorKey
import 'package:shuffle_native/app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  if (message.notification != null) {
    print('Notification Title: ${message.notification!.title}');
    print('Notification Body: ${message.notification!.body}');

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'default_channel',
          'Default',
          channelDescription: 'Default channel for notifications',
          importance: Importance.high,
          priority: Priority.high,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      platformChannelSpecifics,
      payload: message.data['redirectTo'],
    );
  }
}

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _fcm.requestPermission();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          print('Notification tapped with payload: ${details.payload} redirecting...');
          if (details.payload == 'requestpage') {
            navigatorKey.currentState?.pushNamed('/requestpage');
          }
        }
      },
    );

    String? token = await _fcm.getToken();
    print("FCM Token: $token");

    ApiService().sendFCMToken(token!);

    _fcm.onTokenRefresh.listen((String newToken) {
      print("FCM Token refreshed: $newToken");
      ApiService().sendFCMToken(newToken);
    });

    // Handle notification taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked with data: ${message.data}');
      if (message.data['redirectTo'] == 'requestpage') {
        navigatorKey.currentState?.pushNamed('/requestpage');
      }
    });
  }

  void setupInteractedMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received a message in the foreground!');

      if (message.notification != null) {
        print('Notification Title: ${message.notification!.title}');
        print('Notification Body: ${message.notification!.body}');

        await _showNotification(
          message.notification!.title,
          message.notification!.body,
          payload: message.data['redirectTo'],
        );
      }

      // Log message data payload
      if (message.data.isNotEmpty) {
        print('Message data: ${message.data}');
      }
    });
  }

  Future<void> _showNotification(String? title, String? body, {String? payload}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'default_channel',
          'Default',
          channelDescription: 'Default channel for notifications',
          importance: Importance.high,
          priority: Priority.high,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    print('Showing notification with title: $title and body: $body');
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
