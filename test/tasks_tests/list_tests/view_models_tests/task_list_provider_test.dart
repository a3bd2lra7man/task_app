import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/_common/api/exceptions/invalid_response_exception.dart';
import 'package:task_app/_common/providers/providers_enum.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:task_app/tasks/list/repositories/tasks_repositories.dart';
import 'package:task_app/tasks/list/view_models/tasks_provider.dart';

class MockTasksRepo extends Mock implements TasksRepository {}


void main() {
  var mockRepo = MockTasksRepo();
  var task = Task(id: 1, title: "title", completed: true);
  var provider = TasksListProvider.initWith(mockRepo);
  when(() => mockRepo.tasks).thenReturn([]);
  test('getNextTasks failure case', () async {
    var exception = InvalidResponseException("e");
    when(mockRepo.getNext).thenThrow(exception);

    await provider.getNextTasks();

    verify(mockRepo.getNext);
    expect(provider.isError, true);
    expect(provider.errorMessage, exception.userReadableMessage);
    verifyNoMoreInteractions(mockRepo);
  });

  test('getNextTasks success case', () async {
    when(mockRepo.getNext).thenAnswer((_) => Future.value());

    await provider.getNextTasks();

    verify(mockRepo.getNext);
    expect(provider.isIdle, true);
    verifyNoMoreInteractions(mockRepo);
  });

   test('calling getNextTasks twice call api only one time ', () async {
    when(mockRepo.getNext).thenAnswer((_) => Future.value());

     provider.getNextTasks();
     provider.getNextTasks();
     await Future.delayed(Duration.zero);

    verify(mockRepo.getNext);
    expect(provider.isIdle, true);
    verifyNoMoreInteractions(mockRepo);
  });

  test('refresh calls reset on repo then call get next', () async {
    when(mockRepo.getNext).thenAnswer((_) => Future.value());
    when(mockRepo.reset).thenReturn(null);

    await provider.refresh();

    verifyInOrder([
      mockRepo.reset,
      mockRepo.getNext,
    ]);
    expect(provider.isIdle, true);
    verifyNoMoreInteractions(mockRepo);
  });

  test('on Retry calls get next on Repo', () async {
    when(mockRepo.getNext).thenAnswer((_) => Future.value());

    await provider.onRetry();

    verify(mockRepo.getNext);
    expect(provider.isIdle, true);
    verifyNoMoreInteractions(mockRepo);
  });

  test('onTaskAdded calls onTaskAdded on Repo', () async {
    when(() => mockRepo.onTaskAdded(task)).thenAnswer((_) => Future.value());

    await provider.onTaskAdded(task);

    verify(() => mockRepo.onTaskAdded(task));
    verifyNoMoreInteractions(mockRepo);
  });

  test('onTaskUpdated calls onTaskUpdated on Repo', () async {
    when(() => mockRepo.onTaskUpdated()).thenAnswer((_) => Future.value());

    await provider.onTaskUpdated();

    verify(() => mockRepo.onTaskUpdated());
    verifyNoMoreInteractions(mockRepo);
  });

  test('onTaskDeleted calls onTaskDeleted on Repo', () async {
    when(() => mockRepo.onTaskDeleted(task)).thenAnswer((_) => Future.value());

    await provider.onTaskDeleted(task);

    verify(() => mockRepo.onTaskDeleted(task));
    verifyNoMoreInteractions(mockRepo);
  });

  test("isPageError return true when provider in error status and tasks list is empty", () async {
    provider.changeStatusTo(WidgetStatus.error);
    when(() => mockRepo.tasks).thenReturn([]);

    expect(provider.isPageError, true);
  });

  test("isPageError return false when either provider is not in error status or tasks list is empty", () async {
    // case not in error status
    provider.changeStatusTo(WidgetStatus.loading);
    when(() => mockRepo.tasks).thenReturn([]);

    expect(provider.isPageError, false);

    // case list not empty
    provider.changeStatusTo(WidgetStatus.error);
    when(() => mockRepo.tasks).thenReturn([task]);

    expect(provider.isPageError, false);
  });

  test("isSnackError return true when provider in error status and tasks list is not empty", () async {
    provider.changeStatusTo(WidgetStatus.error);
    when(() => mockRepo.tasks).thenReturn([task]);

    expect(provider.isSnackError, true);
  });

  test("isSnackError return false when either provider is not in error status or tasks list is not empty", () async {
    // case not in error status
    provider.changeStatusTo(WidgetStatus.loading);
    when(() => mockRepo.tasks).thenReturn([task]);

    expect(provider.isSnackError, false);

    // case list is empty
    provider.changeStatusTo(WidgetStatus.error);
    when(() => mockRepo.tasks).thenReturn([]);

    expect(provider.isSnackError, false);
  });

  test("isFirstLoading return true when provider in loading status and tasks list is empty", () async {
    provider.changeStatusTo(WidgetStatus.loading);
    when(() => mockRepo.tasks).thenReturn([]);

    expect(provider.isFirstLoading, true);
  });

  test("isFirstLoading return false when either provider is not in loading status or tasks list is empty", () async {
    // case not in loading status
    provider.changeStatusTo(WidgetStatus.error);
    when(() => mockRepo.tasks).thenReturn([]);

    expect(provider.isFirstLoading, false);

    // case list not empty
    provider.changeStatusTo(WidgetStatus.loading);
    when(() => mockRepo.tasks).thenReturn([task]);

    expect(provider.isFirstLoading, false);
  });

  test("isPaginationLoading return true when provider in loading status and tasks list is not empty", () async {
    provider.changeStatusTo(WidgetStatus.loading);
    when(() => mockRepo.tasks).thenReturn([task]);

    expect(provider.isPaginationLoading, true);
  });

  test("isPaginationLoading return false when either provider is not in loading status or tasks list is empty",
      () async {
    // case not in loading status
    provider.changeStatusTo(WidgetStatus.error);
    when(() => mockRepo.tasks).thenReturn([task]);

    expect(provider.isPaginationLoading, false);

    // case list is empty
    provider.changeStatusTo(WidgetStatus.loading);
    when(() => mockRepo.tasks).thenReturn([]);

    expect(provider.isPaginationLoading, false);
  });
}
