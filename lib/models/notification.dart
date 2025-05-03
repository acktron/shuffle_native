class AppNotification {
  final String title;
  final String body;
  final String? redirectTo;
  final DateTime timestamp;

  AppNotification({
    required this.title,
    required this.body,
    this.redirectTo,
    required this.timestamp,
  });
}
