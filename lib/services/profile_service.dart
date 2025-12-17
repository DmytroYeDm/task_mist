import 'package:flutter/material.dart';

class ProfileService {
  static final ProfileService _instance = ProfileService._internal();

  factory ProfileService() {
    return _instance;
  }

  ProfileService._internal();

  static const String photoAssetPath = "lib/assets/photo.png";

  String _name = '';
  String _studentId = '';
  String _faculty = '';
  String _specialization = '';
  String _interests = '';

  String get name => _name;
  String get studentId => _studentId;
  String get faculty => _faculty;
  String get specialization => _specialization;
  String get interests => _interests;

  void updateProfile({
    required String name,
    required String studentId,
    required String faculty,
    required String specialization,
    required String interests,
  }) {
    _name = name;
    _studentId = studentId;
    _faculty = faculty;
    _specialization = specialization;
    _interests = interests;
  }

  bool get isProfileEmpty => _name.isEmpty;
}