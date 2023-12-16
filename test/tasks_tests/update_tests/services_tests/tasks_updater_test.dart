import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/_common/api/entities/api_request.dart';
import 'package:task_app/_common/api/entities/api_response.dart';
import 'package:task_app/_common/api/exceptions/api_exception.dart';
import 'package:task_app/_common/constants/base_url.dart';
import 'package:task_app/tasks/_common/forms/task_form_data.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:task_app/tasks/update/constants/tasks_update_url.dart';
import 'package:task_app/tasks/update/services/task_updater.dart';

import '../../../_common/mocks/network_mock.dart';

main() {
  Map<String, dynamic> successfulResponse = {"id": 1};
  var mockNetworkAdapter = MockNetworkAdapter();
  var updatedTask = TaskFormData(title: "title", completed: true, description: '');
  var task = Task(id: 1, title: "title", completed: true);
  TasksUpdater updater = TasksUpdater.initWith(mockNetworkAdapter);

  setUpAll(() {
    registerFallbackValue(APIRequest("Url"));
  });

  test("api request url is built correctly", () async {
    var url = TasksUpdateUrl.update(task.id);

    expect(url, "$basicUrl/todos/${task.id}");
  });

  group("update function", () {
    test('throws NetworkFailureException when network adapter fails', () async {
      when(() => mockNetworkAdapter.put(any())).thenThrow(NetworkFailureException("e"));
      try {
        var _ = await updater.update(task.id,updatedTask);
        fail('failed to throw the network adapter failure exception');
      } catch (e) {
        expect(e is NetworkFailureException, true);
      }
    });

    test('success', () async {
      when(() => mockNetworkAdapter.put(any())).thenAnswer((_) => Future.value(APIResponse(successfulResponse)));
      try {
        await updater.update(task.id, updatedTask);
        verify(() => mockNetworkAdapter.put(any()));
      } catch (e) {
        fail('failed to complete successfully. exception thrown $e');
      }
    });
  });

  group("updateCompleted function", () {
    test('throws NetworkFailureException when network adapter fails', () async {
      when(() => mockNetworkAdapter.put(any())).thenThrow(NetworkFailureException("e"));
      try {
        var _ = await updater.updateCompleted(task.id, true);
        fail('failed to throw the network adapter failure exception');
      } catch (e) {
        expect(e is NetworkFailureException, true);
      }
    });

    test('success', () async {
      when(() => mockNetworkAdapter.put(any())).thenAnswer((_) => Future.value(APIResponse(successfulResponse)));
      try {
        var _ = await updater.updateCompleted(task.id, true);
        verify(() => mockNetworkAdapter.put(any()));
      } catch (e) {
        fail('failed to complete successfully. exception thrown $e');
      }
    });
  });
}
