import 'package:task_app/tasks/_core/entities/task.dart';

class TaskFormData {
  String title;
  String description;
  bool completed;

  TaskFormData({required this.title, required this.completed, required this.description});

  Map<String, dynamic> toJson() => {
        'title': title,
        'completed': completed,
        'description': description,
      };

  Task toTask(int id) {
    return Task(
      id: id,
      title: title,
      completed: completed,
      description: description,
    );
  }
}
