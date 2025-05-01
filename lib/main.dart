import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuffle_native/app.dart';
import 'package:shuffle_native/providers/auth_provider.dart';
import 'package:shuffle_native/services/api_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shuffle_native/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ApiClient.init(); // Initialize Dio client and interceptors

  await NotificationService().initNotifications();
  NotificationService().setupInteractedMessage();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider()..checkLoginStatus(),
      child: const App(),
    ),
  );
}