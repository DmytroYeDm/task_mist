import 'package:flutter/material.dart';
import 'tasks.dart';
import 'profile.dart';
import 'health.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _buildNavigationBlock({
    required String title,
    required String description,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.2),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Головна сторінка", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "Ласкаво просимо!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1E88E5)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "Ваш особистий помічник для керування навчанням, завданнями та здоров'ям. Оберіть розділ нижче.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            _buildNavigationBlock(
              title: "Перейти до завдань",
              description: "Керування дедлайнами, курсовими роботами та завданнями.",
              onPressed: () => _navigateTo(context, const TasksScreen()),
              color: Colors.blue,
            ),

            _buildNavigationBlock(
              title: "Мій профіль (ID)",
              description: "Ваші особисті дані, група, спеціальність та номер студентського квитка.",
              onPressed: () => _navigateTo(context, const ProfileScreen()),
              color: Colors.blue,
            ),

            _buildNavigationBlock(
              title: "Здоров'я та звички",
              description: "Вправи для очей, поради для концентрації та фітнес-нагадування.",
              onPressed: () => _navigateTo(context, const HealthScreen()),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}