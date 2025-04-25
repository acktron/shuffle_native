import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuffle_native/providers/auth_provider.dart';
import 'package:shuffle_native/services/web_socket_service.dart';
// import 'package:snicko/services/web_socket_service.dart';

class NotificationPage extends StatefulWidget {
  // final String userId;

  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late WebSocketService _webSocketService;
  late Stream<Map<String, dynamic>> _notificationsStream;
  late StreamSubscription<Map<String, dynamic>> _subscription;
  Map<String, dynamic>? _latestNotification;
  late AuthProvider authProvider;
  

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    _webSocketService = WebSocketService(authProvider.userId.toString());
    _notificationsStream = _webSocketService.notifications;

    // Listen to the notifications stream and update the notification count and UI
    _subscription = _notificationsStream.listen((notification) {
      print('Notification received: $notification');
      setState(() {
        _latestNotification = notification;
        WebSocketService.notificationCount.value++;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _webSocketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: _latestNotification == null
          ? Center(child: Text('No notifications yet.'))
          : ListTile(
              title: Text(_latestNotification!['title']),
              subtitle: Text(_latestNotification!['body']),
            ),
    );
  }
}
