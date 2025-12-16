import 'package:flutter/material.dart';

class Habit {
  final String title;
  final String description;
  final IconData icon;
  bool isCompleted;

  Habit({
    required this.title,
    required this.description,
    required this.icon,
    this.isCompleted = false,
  });
}