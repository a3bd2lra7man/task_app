import 'package:task_app/_common/exceptions/app_exception.dart';
import 'package:task_app/_common/providers/app_provider.dart';
import 'package:task_app/_common/providers/providers_enum.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:task_app/tasks/update/services/task_updater.dart';

import '../../../_common/widgets/snack_bar.dart';

class UpdateTasksCompletedStatusProvider extends AppProvider {
  final void Function() onTaskUpdated;
  final TasksUpdater _updater;

  UpdateTasksCompletedStatusProvider(Task task, {required this.onTaskUpdated}) : _updater = TasksUpdater();

  UpdateTasksCompletedStatusProvider.initWith(this.onTaskUpdated, this._updater);

  Future<void> updateTask(Task task, bool? value) async {
    if (value == null) return;
    changeStatusTo(WidgetStatus.loading);
    try {
      await _updater.updateCompleted(task.id, value);
      task.completed = value;
      changeStatusTo(WidgetStatus.idle);
      onTaskUpdated();
    } on AppException catch (e) {
      errorMessage = e.userReadableMessage;
      showErrorSnackBar(e.userReadableMessage);
      changeStatusTo(WidgetStatus.error);
    }
  }
}
