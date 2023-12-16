import 'package:task_app/_common/exceptions/app_exception.dart';
import 'package:task_app/_common/providers/app_provider.dart';
import 'package:task_app/_common/providers/providers_enum.dart';
import 'package:task_app/tasks/_common/forms/form_validator.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:task_app/tasks/add/services/task_adder.dart';

import '../../../_common/widgets/snack_bar.dart';

class AddTaskProvider extends AppProvider {
  final void Function(Task) onTaskAdded;
  final TasksAdder _adder;
  final TaskFormValidator validator;

  AddTaskProvider({required this.onTaskAdded})
      : _adder = TasksAdder(),
        validator = TaskFormValidator();

  AddTaskProvider.initWith(this.onTaskAdded, this._adder, this.validator);

  Future<void> addTask() async {
    if (!validator.validate()) {
      return;
    }

    changeStatusTo(WidgetStatus.loading);
    try {
      var newTask = validator.getFormData();
      var task = await _adder.add(newTask);
      changeStatusTo(WidgetStatus.idle);
      onTaskAdded(task);
    } on AppException catch (e) {
      errorMessage = e.userReadableMessage;
      showErrorSnackBar(e.userReadableMessage);
      changeStatusTo(WidgetStatus.error);
    }
  }
}
