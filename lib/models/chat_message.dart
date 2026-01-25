import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatCollection {
  final String title;
  final IconData? icon;

  ChatCollection({required this.title, this.icon});
}
