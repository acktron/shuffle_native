import 'package:flutter/material.dart';
import '../models/notification.dart';

class NotificationProvider with ChangeNotifier {
  final List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification); // Latest on top
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}
