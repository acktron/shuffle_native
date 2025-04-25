import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shuffle_native/services/web_socket_service.dart';
// import 'package:snicko/services/web_socket_service.dart';

class NotificationPage extends StatefulWidget {
  final String userId;

  NotificationPage({required this.userId});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late WebSocketService _webSocketService;
  late Stream<Map<String, dynamic>> _notificationsStream;
  late StreamSubscription<Map<String, dynamic>> _subscription;
  Map<String, dynamic>? _latestNotification;

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService(widget.userId);
    _notificationsStream = _webSocketService.notifications;

    // Listen to the notifications stream and update the notification count and UI
    _subscription = _notificationsStream.listen((notification) {
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
