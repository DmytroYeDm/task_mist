import 'package:flutter/material.dart';

class Task {
  final String title;
  final DateTime deadline;
  final String comment;
  final bool isUrgent;

  Task({
    required this.title,
    required this.deadline,
    required this.comment,
    this.isUrgent = false,
  });
}