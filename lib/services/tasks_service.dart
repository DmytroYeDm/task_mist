import '../models/task_model.dart';

class TasksService {
  static final TasksService _instance = TasksService._internal();

  factory TasksService() {
    return _instance;
  }

  TasksService._internal();

  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
  }
}