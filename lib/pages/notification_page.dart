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

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService(widget.userId);
    _notificationsStream = _webSocketService.notifications;
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: _notificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No notifications yet.'));
          }

          final notification = snapshot.data!;
          final title = notification['title'];
          final body = notification['body'];

          return ListTile(
            title: Text(title),
            subtitle: Text(body),
          );
        },
      ),
    );
  }
}
