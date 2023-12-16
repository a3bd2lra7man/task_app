import 'package:task_app/_common/exceptions/app_exception.dart';
import 'package:task_app/_common/providers/app_provider.dart';
import 'package:task_app/_common/providers/providers_enum.dart';
import 'package:task_app/tasks/_core/entities/task.dart';

import '../../../_common/widgets/snack_bar.dart';
import '../services/task_deleter.dart';

class DeleteTaskProvider extends AppProvider {
  final void Function(Task) onTaskDeleted;
  final TasksDeleter _deleter;

  DeleteTaskProvider({required this.onTaskDeleted}) : _deleter = TasksDeleter();

  DeleteTaskProvider.initWith(this.onTaskDeleted, this._deleter);

  Future<void> deleteTask(Task task) async {
    changeStatusTo(WidgetStatus.loading);
    try {
      await _deleter.delete(task);
      changeStatusTo(WidgetStatus.idle);
      onTaskDeleted(task);
    } on AppException catch (e) {
      errorMessage = e.userReadableMessage;
      showErrorSnackBar(e.userReadableMessage);
      changeStatusTo(WidgetStatus.error);
    }
  }
}
