import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/_common/api/entities/api_request.dart';
import 'package:task_app/_common/api/entities/api_response.dart';
import 'package:task_app/_common/api/exceptions/api_exception.dart';
import 'package:task_app/_common/constants/base_url.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:task_app/tasks/delete/constants/tasks_delete_url.dart';
import 'package:task_app/tasks/delete/services/task_deleter.dart';

import '../../../_common/mocks/network_mock.dart';

main() {
  Map<String, dynamic> successfulResponse = {"id": 1};
  var mockNetworkAdapter = MockNetworkAdapter();
  var task = Task(id: 123, title: "title", completed: true);

  TasksDeleter deleter = TasksDeleter.initWith(mockNetworkAdapter);

  setUpAll(() {
    registerFallbackValue(APIRequest("Url"));
  });

  test("api request url is built correctly", () async {
    var url = TasksDeleteUrl.delete(task.id);

    expect(url, "$basicUrl/todos/123");
  });

  test('throws NetworkFailureException when network adapter fails', () async {
    when(() => mockNetworkAdapter.delete(any())).thenThrow(NetworkFailureException("e"));
    try {
      var _ = await deleter.delete(task);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    when(() => mockNetworkAdapter.delete(any())).thenAnswer((_) => Future.value(APIResponse(successfulResponse)));
    try {
      await deleter.delete(task);
      verify(() => mockNetworkAdapter.delete(any()));
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });
}
