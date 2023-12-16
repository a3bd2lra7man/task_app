import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/_common/api/exceptions/invalid_response_exception.dart';
import 'package:task_app/tasks/_common/forms/task_form_data.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:task_app/tasks/add/services/task_adder.dart';
import 'package:task_app/tasks/add/view_models.dart/add_task_provider.dart';

import '../../validator_mocks.dart';

class MockTaskAdder extends Mock implements TasksAdder {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Task? taskAdded;
  onTaskAdded(v) {
    taskAdded = v;
  }

  var newTask = TaskFormData(title: 'title', completed: true, description: 'description');
  var validator = MockValidator();
  var mockAdder = MockTaskAdder();
  var provider = AddTaskProvider.initWith(onTaskAdded, mockAdder, validator);

  setUpAll(() {
    registerFallbackValue(newTask);
  });

  test('add with invalid data do nothing and call validate for ui', () async {
    when(validator.validate).thenReturn(false);

    await provider.addTask();

    verify(validator.validate);
    verifyZeroInteractions(mockAdder);
  });

  test('add with valid data but api failed', () async {
    when(validator.validate).thenReturn(true);
    when(validator.getFormData).thenReturn(newTask);
    var exception = InvalidResponseException("e");
    when(() => mockAdder.add(any())).thenThrow(exception);

    await provider.addTask();

    verifyInOrder([
      validator.validate,
      () => mockAdder.add(any()),
    ]);
    expect(provider.isError, true);
    expect(provider.errorMessage, exception.userReadableMessage);
    verifyNoMoreInteractions(mockAdder);
  });

  test('success', () async {
    taskAdded = null;
    when(validator.validate).thenReturn(true);
    when(validator.getFormData).thenReturn(newTask);
    var task = Task(id: 1, title: "title1", completed: true);
    when(() => mockAdder.add(any())).thenAnswer((_) => Future.value(task));

    await provider.addTask();

    verifyInOrder([
      validator.validate,
      () => mockAdder.add(any()),
    ]);
    expect(provider.isIdle, true);
    expect(taskAdded, task);
    verifyNoMoreInteractions(mockAdder);
  });
}
