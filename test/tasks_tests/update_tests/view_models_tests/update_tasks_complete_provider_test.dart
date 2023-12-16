import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/_common/api/exceptions/invalid_response_exception.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:task_app/tasks/update/view_models.dart/update_task_completed_provider.dart';

import '_common.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  bool? isCallbackCalled;
  onTaskUpdated() {
    isCallbackCalled = true;
  }

  var taskToBeUpdated = Task(id: 1, title: "Old Title", completed: true, description: '');

  var mockUpdater = MockTaskUpdater();
  var provider = UpdateTasksCompletedStatusProvider.initWith(onTaskUpdated, mockUpdater);

  setUpAll(() {
    registerFallbackValue(taskToBeUpdated);
  });

  test('when api failed', () async {
    var exception = InvalidResponseException("e");
    when(() => mockUpdater.updateCompleted(any(), any())).thenThrow(exception);

    await provider.updateTask(taskToBeUpdated, false);

    verify(() => mockUpdater.updateCompleted(taskToBeUpdated.id, false));
    expect(provider.isError, true);
    expect(provider.errorMessage, exception.userReadableMessage);
    verifyNoMoreInteractions(mockUpdater);
  });

  test('success', () async {
    isCallbackCalled = false;
    taskToBeUpdated.completed = false;
    when(() => mockUpdater.updateCompleted(any(), any())).thenAnswer((_) => Future.value());

    await provider.updateTask(taskToBeUpdated, true);
    verify(() => mockUpdater.updateCompleted(taskToBeUpdated.id, true));
    expect(provider.isIdle, true);
    expect(isCallbackCalled, true);
    expect(taskToBeUpdated.completed, true);
    verifyNoMoreInteractions(mockUpdater);
  });
}
