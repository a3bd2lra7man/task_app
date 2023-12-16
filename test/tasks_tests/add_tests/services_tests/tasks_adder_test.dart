import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/_common/api/entities/api_request.dart';
import 'package:task_app/_common/api/entities/api_response.dart';
import 'package:task_app/_common/api/exceptions/api_exception.dart';
import 'package:task_app/_common/api/exceptions/invalid_response_exception.dart';
import 'package:task_app/_common/constants/base_url.dart';
import 'package:task_app/tasks/_common/forms/task_form_data.dart';
import 'package:task_app/tasks/add/constants/tasks_add_url.dart';
import 'package:task_app/tasks/add/services/task_adder.dart';

import '../../../_common/mocks/network_mock.dart';

main() {
  Map<String, dynamic> successfulResponse = {"id": 1};
  var mockNetworkAdapter = MockNetworkAdapter();
  var newTask = TaskFormData(title: "title", completed: true, description: '');

  TasksAdder _adder = TasksAdder.initWith(mockNetworkAdapter);

  setUpAll(() {
    registerFallbackValue(APIRequest("Url"));
  });

  test("api request url is built correctly", () async {
    var url = TasksAddUrl.add();

    expect(url, "$basicUrl/todos");
  });

  test('throws NetworkFailureException when network adapter fails', () async {
    when(() => mockNetworkAdapter.post(any())).thenThrow(NetworkFailureException("e"));
    try {
      var _ = await _adder.add(newTask);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when response is null', () async {
    when(() => mockNetworkAdapter.post(any())).thenAnswer((_) => Future.value(APIResponse(null)));

    try {
      var _ = await _adder.add(newTask);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws InvalidResponseException when response is of the wrong format', () async {
    when(() => mockNetworkAdapter.post(any())).thenAnswer((_) => Future.value(APIResponse("data")));
    try {
      var _ = await _adder.add(newTask);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    when(() => mockNetworkAdapter.post(any())).thenAnswer((_) => Future.value(APIResponse(successfulResponse)));
    try {
      var response = await _adder.add(newTask);
      expect(response.id, successfulResponse['id']);
      expect(response.title, newTask.title);
      expect(response.completed, newTask.completed);
      verify(() => mockNetworkAdapter.post(any()));
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });
}
