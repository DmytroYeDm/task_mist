import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _idController;
  late final TextEditingController _facultyController;
  late final TextEditingController _specController;
  late final TextEditingController _interestsController;

  bool _isEditing = false;

  final TextStyle _nameStyle = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.blueGrey,
  );

  void _updateSaveButtonState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _profileService.name);
    _idController = TextEditingController(text: _profileService.studentId);
    _facultyController = TextEditingController(text: _profileService.faculty);
    _specController = TextEditingController(text: _profileService.specialization);
    _interestsController = TextEditingController(text: _profileService.interests);

    _nameController.addListener(_updateSaveButtonState);
    _idController.addListener(_updateSaveButtonState);
    _facultyController.addListener(_updateSaveButtonState);
    _specController.addListener(_updateSaveButtonState);
    _interestsController.addListener(_updateSaveButtonState);

    if (_profileService.isProfileEmpty) {
      _isEditing = true;
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateSaveButtonState);
    _idController.removeListener(_updateSaveButtonState);
    _facultyController.removeListener(_updateSaveButtonState);
    _specController.removeListener(_updateSaveButtonState);
    _interestsController.removeListener(_updateSaveButtonState);

    _nameController.dispose();
    _idController.dispose();
    _facultyController.dispose();
    _specController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  bool _canSave() {
    final isRequiredFieldsFilled = _nameController.text.isNotEmpty &&
        _idController.text.isNotEmpty &&
        _facultyController.text.isNotEmpty &&
        _specController.text.isNotEmpty;

    final isIdValid = _idController.text.length == 8;

    return isRequiredFieldsFilled && isIdValid;
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _profileService.updateProfile(
        name: _nameController.text,
        studentId: _idController.text,
        faculty: _facultyController.text,
        specialization: _specController.text,
        interests: _interestsController.text,
      );

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Профіль успішно оновлено!")),
      );
    }
  }

  Widget _buildInfoBlock(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildEditModeUI() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: AssetImage(ProfileService.photoAssetPath),
          ),
          const SizedBox(height: 30),

          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Ім\'я та прізвище"),
            style: _nameStyle.copyWith(fontSize: 22),
            textAlign: TextAlign.center,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Будь ласка, введіть ім\'я та прізвище";
              }
              return null;
            },
            onChanged: (value) => _updateSaveButtonState(),
          ),

          TextFormField(
            controller: _idController,
            decoration: const InputDecoration(
              labelText: "Студентський ID (8 цифр)",
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Поле не може бути порожнім";
              }
              if (value.length != 8) {
                return "Студентський ID повинен містити рівно 8 цифр";
              }
              return null;
            },
            onChanged: (value) => _updateSaveButtonState(),
          ),

          TextFormField(
            controller: _facultyController,
            decoration: const InputDecoration(labelText: "Факультет"),
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Zа-яА-ЯіІїЇєЄґҐ'\s]")),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Будь ласка, введіть факультет";
              }
              return null;
            },
            onChanged: (value) => _updateSaveButtonState(),
          ),

          TextFormField(
            controller: _specController,
            decoration: const InputDecoration(labelText: "Спеціалізація"),
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Zа-яА-ЯіІїЇєЄґҐ'\s]")),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Будь ласка, введіть спеціалізацію";
              }
              return null;
            },
            onChanged: (value) => _updateSaveButtonState(),
          ),

          TextFormField(
            controller: _interestsController,
            decoration: const InputDecoration(
                labelText: "Інтереси, хобі, навички (Необов'язково)"
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            onChanged: (value) => _updateSaveButtonState(),
          ),

          const SizedBox(height: 40),

          ElevatedButton.icon(
            onPressed: _canSave() ? _saveProfile : null,
            icon: const Icon(Icons.save),
            label: const Text("Зберегти профіль"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeUI() {
    if (_profileService.isProfileEmpty) {
      return const Text('Профіль не заповнено. Натисніть "Редагувати".');
    }

    final interestsValue = _profileService.interests.isNotEmpty
        ? _profileService.interests : '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 80,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: AssetImage(ProfileService.photoAssetPath),
          ),
        ),

        const SizedBox(height: 30),

        Text(_profileService.name, style: _nameStyle, textAlign: TextAlign.center),
        const SizedBox(height: 5),

        Text(
          "Студентський ID: ${_profileService.studentId}",
          style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 40),

        const Divider(height: 1, thickness: 1, color: Colors.black12),
        const SizedBox(height: 20),

        _buildInfoBlock("Факультет", _profileService.faculty),
        const SizedBox(height: 20),
        _buildInfoBlock("Спеціалізація", _profileService.specialization),

        const SizedBox(height: 20),
        _buildInfoBlock("Інтереси та навички", interestsValue),

        const SizedBox(height: 40),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Академічний Рік: 2025/2026",
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Редагування профілю" : "Профіль студента", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.cancel : Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  _nameController.text = _profileService.name;
                  _idController.text = _profileService.studentId;
                  _facultyController.text = _profileService.faculty;
                  _specController.text = _profileService.specialization;
                  _interestsController.text = _profileService.interests;

                  _formKey.currentState?.reset();
                }
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: _isEditing ? _buildEditModeUI() : _buildViewModeUI(),
        ),
      ),
    );
  }
}