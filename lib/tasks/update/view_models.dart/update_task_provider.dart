import 'package:task_app/_common/exceptions/app_exception.dart';
import 'package:task_app/_common/providers/app_provider.dart';
import 'package:task_app/_common/providers/providers_enum.dart';
import 'package:task_app/tasks/_common/forms/form_validator.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:task_app/tasks/update/services/task_updater.dart';

import '../../../_common/widgets/snack_bar.dart';

class UpdateTaskProvider extends AppProvider {
  final void Function() onTaskUpdated;
  final TasksUpdater _updater;
  final TaskFormValidator validator;

  UpdateTaskProvider(Task task, {required this.onTaskUpdated})
      : _updater = TasksUpdater(),
        validator = TaskFormValidator.fromTask(task);

  UpdateTaskProvider.initWith(this.onTaskUpdated, this._updater, this.validator);

  Future<void> updateTask(Task task) async {
    if (!validator.validate()) return;

    changeStatusTo(WidgetStatus.loading);
    try {
      var updatedTask = validator.getFormData();
      await _updater.update(task.id, updatedTask);
      task.completed = updatedTask.completed;
      task.title = updatedTask.title;
      task.description = updatedTask.description;
      changeStatusTo(WidgetStatus.idle);
      onTaskUpdated();
    } on AppException catch (e) {
      errorMessage = e.userReadableMessage;
      showErrorSnackBar(e.userReadableMessage);
      changeStatusTo(WidgetStatus.error);
    }
  }
}
