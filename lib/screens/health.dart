import 'package:flutter/material.dart';
import '../models/habit_model.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  final List<Habit> _habits = [
    Habit(
        title: "Випити 1.5 літрів води",
        description: "Підтримка гідратації організму.",
        icon: Icons.local_drink),
    Habit(
        title: "Робити перерви кожну годину при роботі за комп'ютером",
        description: "Розслаблення очей",
        icon: Icons.visibility),
    Habit(
        title: "Фізична активність (30 хв)",
        description: "Легка розминка або прогулянка.",
        icon: Icons.fitness_center),
    Habit(
        title: "Мати три прийоми їжі за день",
        description: "Підтримка регулярного та збалансованого харчування.",
        icon: Icons.fastfood),
    Habit(
        title: "Лягти спати до 10",
        description: "Забезпечення відновлення організму.",
        icon: Icons.bedtime),
    Habit(
      title: "Почати день з зарядки",
      description: "Активація організму та підвищення рівня енергії зранку.",
      icon: Icons.directions_run,
    ),
    Habit(
      title: "Обмежити використання телефону впродовж дня",
      description: "Зменшення цифрової залежності та підвищення концентрації.",
      icon: Icons.phone_android,
    ),
    Habit(
      title: "Не накручувати себе",
      description: "Зниження стресу та покращення емоційного стану.",
      icon: Icons.self_improvement,
    )
  ];

  void _checkHealth() {
    final completedCount =
        _habits.where((habit) => habit.isCompleted).length;
    final totalCount = _habits.length;

    String title;
    String message;
    IconData icon;
    Color color;

    if (completedCount == totalCount) {
      title = "Чудовий результат!";
      message = "Ви виконали всі звички. Сподіваємось, що завтра буде такий же результат";
      icon = Icons.star;
      color = Colors.green;
    } else if (completedCount >= totalCount * 0.5) {
      title = "Добре!";
      message =
      "Ви виконали більшість звичок. Непоганий день! Спробуйте завтра виконати більше";
      icon = Icons.thumb_up;
      color = Colors.amber;
    } else {
      title = "Погано!";
      message =
      "Ви виконали менше половини звичок. Не слід забувати про своє здоров'я";
      icon = Icons.warning;
      color = Colors.red;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 10),
              Text(title, style: TextStyle(color: color)),
            ],
          ),
          content: Text(
              "$message (Виконано: $completedCount з $totalCount)"),
          actions: <Widget>[
            TextButton(
              child: const Text("Зрозуміло"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildHabitCard(Habit habit, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
            color: habit.isCompleted ? Colors.green.shade400 : Colors.red,
            width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: habit.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationThickness: 2,
                      decorationColor: Colors.black,
                    ),
                    maxLines: 1, // <--- Виправлення: обмежуємо заголовок
                    overflow: TextOverflow.ellipsis, // <--- Виправлення: додаємо "..."
                  ),
                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Icon(habit.icon, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          habit.description,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Checkbox(
              value: habit.isCompleted,
              activeColor: Colors.green,
              onChanged: (bool? newValue) {
                setState(() {
                  habit.isCompleted = newValue!;
                });
              },
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
        title: const Text("Здоров\'я та звички", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Сьогоднішні цілі для фокусу:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),

            ..._habits.asMap().entries.map((entry) {
              return _buildHabitCard(entry.value, entry.key);
            }).toList(),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: _checkHealth,
              icon: const Icon(Icons.favorite_border),
              label: const Text("Перевірити здоров\'я"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}