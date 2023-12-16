import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/_common/api/exceptions/invalid_response_exception.dart';
import 'package:task_app/tasks/_common/forms/task_form_data.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:task_app/tasks/update/view_models.dart/update_task_provider.dart';

import '../../validator_mocks.dart';
import '_common.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  bool? isCallbackCalled;
  onTaskUpdated() {
    isCallbackCalled = true;
  }

  var taskToBeUpdated = Task(id: 123, title: "Old Title", completed: true);
  var formData = TaskFormData(title: 'title', completed: true, description: 'description');
  var validator = MockValidator();

  var mockUpdater = MockTaskUpdater();
  var provider = UpdateTaskProvider.initWith(onTaskUpdated, mockUpdater, validator);

  setUpAll(() {
    registerFallbackValue(TaskFormData(description: '', title: "title", completed: true));
  });

  test('update with invalid data do nothing and call validate for ui', () async {
    when(validator.validate).thenReturn(false);

    await provider.updateTask(taskToBeUpdated);

    verify(validator.validate);
    verifyZeroInteractions(mockUpdater);
  });

  test('update with valid data but api failed', () async {
    when(validator.validate).thenReturn(true);
    when(validator.getFormData).thenReturn(formData);
    var exception = InvalidResponseException("e");
    when(() => mockUpdater.update(any(), any())).thenThrow(exception);

    await provider.updateTask(taskToBeUpdated);

    verifyInOrder([
      validator.validate,
      () => mockUpdater.update(taskToBeUpdated.id, formData),
    ]);
    expect(provider.isError, true);
    expect(provider.errorMessage, exception.userReadableMessage);
    verifyNoMoreInteractions(mockUpdater);
  });

  test('success', () async {
    isCallbackCalled = false;
    when(validator.validate).thenReturn(true);
    formData.title = "New Title";
    formData.completed = false;
    when(validator.getFormData).thenReturn(formData);

    when(() => mockUpdater.update(any(), any())).thenAnswer((_) => Future.value());

    await provider.updateTask(taskToBeUpdated);

    verifyInOrder([
      validator.validate,
      () => mockUpdater.update(taskToBeUpdated.id, formData),
    ]);
    expect(provider.isIdle, true);
    expect(isCallbackCalled, true);
    expect(taskToBeUpdated.title, "New Title");
    expect(taskToBeUpdated.completed, false);
    verifyNoMoreInteractions(mockUpdater);
  });
}
