import 'package:flutter/material.dart';
import 'package:task_app/tasks/_common/forms/task_form_data.dart';
import 'package:task_app/tasks/_core/entities/task.dart';

class TaskFormValidator extends ChangeNotifier {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isCompleted = false;
  GlobalKey<FormState> formKey;

  TaskFormValidator() : formKey = GlobalKey();

  TaskFormValidator.initWith(this.formKey);

  TaskFormValidator.fromTask(Task task) : formKey = GlobalKey() {
    titleController.text = task.title;
    descriptionController.text = task.description;
    isCompleted = task.completed;
  }

  void onCompletedChanged(bool? value) {
    if (value == null) return;
    isCompleted = value;
    notifyListeners();
  }

  String? isTitleValid(String? value) {
    return value == null || value.isEmpty ? "Please Enter Task Title" : null;
  }

  bool validate() {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }

  TaskFormData getFormData() {
    return TaskFormData(
      title: titleController.text,
      description: descriptionController.text,
      completed: isCompleted,
    );
  }
}
