import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/tasks_service.dart';
import '../models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TasksService _tasksService = TasksService();

  final int _urgentDaysThreshold = 5;

  String _formatDate(DateTime date) {
    return DateFormat("dd.MM.yyyy").format(date);
  }

  bool _isDeadlineUrgent(DateTime deadline) {
    final now = DateTime.now();
    final deadlineDate = DateTime(deadline.year, deadline.month, deadline.day);
    final nowDate = DateTime(now.year, now.month, now.day);

    final difference = deadlineDate.difference(nowDate).inDays;

    return difference <= _urgentDaysThreshold && difference >= 0;
  }

  void _confirmDeletionDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final taskTitle = _tasksService.tasks[index].title;

        return AlertDialog(
          title: const Text("Підтвердіть видалення"),
          content: Text("Ви впевнені, що хочете видалити завдання: \"$taskTitle\"?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Скасувати"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Видалити", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTask(index);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) {
    setState(() {
      _tasksService.deleteTask(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Завдання видалено!"), duration: Duration(seconds: 2)),
    );
  }

  Future<void> _pickDeadlineDate(StateSetter dialogSetState, DateTime? initialDate, Function(DateTime) onPicked) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      dialogSetState(() {
        onPicked(picked);
      });
    }
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController commentController = TextEditingController();
    DateTime? localSelectedDate;

    final FocusNode titleFocusNode = FocusNode();

    void _titleChangeHandler() {
      setState(() {});
    }

    void addTask() {
      if (titleController.text.isNotEmpty && localSelectedDate != null) {
        final newTask = Task(
          title: titleController.text,
          deadline: localSelectedDate!,
          comment: commentController.text.isEmpty ? "Без коментаря" : commentController.text,
          isUrgent: _isDeadlineUrgent(localSelectedDate!),
        );

        setState(() {
          _tasksService.addTask(newTask);
        });

        titleController.removeListener(_titleChangeHandler);
        titleController.dispose();
        commentController.dispose();

        Navigator.of(context).pop();
      }
    }

    titleController.addListener(_titleChangeHandler);

    showDialog(
      context: context,
      builder: (BuildContext context) {

        Future.microtask(() => titleFocusNode.requestFocus());

        return StatefulBuilder(
          builder: (context, dialogSetState) {

            void handleDatePick() {
              _pickDeadlineDate(dialogSetState, localSelectedDate, (pickedDate) {
                localSelectedDate = pickedDate;
              });
            }

            return AlertDialog(
              title: const Text("Створити нове завдання"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      focusNode: titleFocusNode,
                      decoration: const InputDecoration(labelText: "Назва завдання"),
                    ),
                    TextField(
                      controller: commentController,
                      decoration: const InputDecoration(labelText: "Короткий коментар"),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      title: Text(
                        localSelectedDate == null
                            ? "Оберіть дедлайн"
                            : "Дедлайн: ${_formatDate(localSelectedDate!)}",
                        style: TextStyle(
                          color: localSelectedDate == null ? Colors.grey.shade600 : Colors.black,
                          fontWeight: localSelectedDate == null ? FontWeight.normal : FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: handleDatePick,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    titleController.removeListener(_titleChangeHandler);
                    titleController.dispose();
                    commentController.dispose();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Скасувати"),
                ),
                ElevatedButton(
                  onPressed: (titleController.text.isNotEmpty && localSelectedDate != null)
                      ? addTask
                      : null,
                  child: const Text("Створити"),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      titleFocusNode.dispose();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Task> currentTasks = _tasksService.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Завдання та дедлайни", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.red.shade700,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      body:
      currentTasks.isEmpty
          ?
      Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_turned_in_outlined, size: 80, color: Colors.grey.shade300),
              const SizedBox(height: 20),
              const Text(
                "Ваш список завдань порожній",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Натисніть на кнопку "+" у правому нижньому куті, щоб створити свій перший дедлайн або завдання.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )
          :
      ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: currentTasks.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final task = currentTasks[index];
          final isUrgent = _isDeadlineUrgent(task.deadline);

          final Color indicatorColor = isUrgent ? Colors.red.shade700 : Colors.blue.shade700;
          final Color titleColor = isUrgent ? Colors.red.shade900 : Colors.black87;

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isUrgent ? BorderSide(color: indicatorColor, width: 2) : BorderSide.none,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _confirmDeletionDialog(index),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: indicatorColor),
                      const SizedBox(width: 5),
                      Text(
                        "Дедлайн: ${_formatDate(task.deadline)}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isUrgent ? FontWeight.w600 : FontWeight.normal,
                          color: indicatorColor,
                        ),
                      ),
                      if (isUrgent)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("Терміново", style: TextStyle(color: Colors.red.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    task.comment,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}