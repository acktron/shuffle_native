import 'package:flutter/material.dart';
import 'package:shuffle_native/constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketService {
  final WebSocketChannel channel;

  WebSocketService(String userId)
      : channel = WebSocketChannel.connect(
          Uri.parse('ws://$baseUrl/ws/notifications/$userId/'),
        );

  // Listen to WebSocket messages
  Stream<Map<String, dynamic>> get notifications => channel.stream.map((message) {
        return json.decode(message);
      });

  // Close the WebSocket connection
  void dispose() {
    channel.sink.close();
  }
}
