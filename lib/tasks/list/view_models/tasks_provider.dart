import 'package:task_app/_common/exceptions/app_exception.dart';
import 'package:task_app/_common/providers/app_provider.dart';
import 'package:task_app/_common/providers/providers_enum.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:task_app/tasks/list/repositories/tasks_repositories.dart';


class TasksListProvider extends AppProvider {
  final TasksRepository _repository;
  List<Task> get tasks => _repository.tasks;

  TasksListProvider() : _repository = TasksRepository() {
    getNextTasks();
  }

  TasksListProvider.initWith(this._repository);

  Future<void> getNextTasks() async {
    if (isLoading) return;
    changeStatusTo(WidgetStatus.loading);
    try {
      await _repository.getNext();
      changeStatusTo(WidgetStatus.idle);
    } on AppException catch (e) {
      errorMessage = e.userReadableMessage;
      changeStatusTo(WidgetStatus.error);
    }
  }

  Future<void> refresh() async {
    _repository.reset();
    await getNextTasks();
  }

  Future onRetry() async {
    await getNextTasks();
  }

  onTaskAdded(Task newTask) async {
    await _repository.onTaskAdded(newTask);
    notifyListeners();
  }

  onTaskUpdated() async {
    await _repository.onTaskUpdated();
    notifyListeners();
  }

  onTaskDeleted(Task task) async {

    await _repository.onTaskDeleted(task);
    notifyListeners();
  }

  bool get isPageError => isError && tasks.isEmpty;

  bool get isSnackError => isError && tasks.isNotEmpty;

  bool get isFirstLoading => isLoading && tasks.isEmpty;

  bool get isPaginationLoading => isLoading && tasks.isNotEmpty;

  bool get isTasksEmpty => tasks.isEmpty;

}
