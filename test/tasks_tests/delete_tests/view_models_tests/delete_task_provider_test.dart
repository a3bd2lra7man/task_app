import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/_common/api/exceptions/invalid_response_exception.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:task_app/tasks/delete/services/task_deleter.dart';
import 'package:task_app/tasks/delete/view_models.dart/delete_task_provider.dart';

class MockTaskDeleter extends Mock implements TasksDeleter {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var isCallbackCalled = false;
  onTaskDeleted(v) {
    isCallbackCalled = true;
  }

  var task = Task(id: 123, title: "title", completed: true);

  var mockDeleter = MockTaskDeleter();
  var provider = DeleteTaskProvider.initWith(onTaskDeleted, mockDeleter);

  test('failed to delete task', () async {
    var exception = InvalidResponseException("e");
    when(() => mockDeleter.delete(task)).thenThrow(exception);

    await provider.deleteTask(task);

    expect(provider.isError, true);
    expect(provider.errorMessage, exception.userReadableMessage);
  });

  test('success', () async {
    isCallbackCalled = false;
    when(() => mockDeleter.delete(task)).thenAnswer((_) => Future.value());

    await provider.deleteTask(task);

    expect(provider.isIdle, true);
    expect(isCallbackCalled, true);
  });
}
