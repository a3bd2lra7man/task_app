// ignore_for_file: null_argument_to_non_null_type

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/_common/api/entities/api_request.dart';
import 'package:task_app/_common/api/entities/api_response.dart';
import 'package:task_app/_common/api/exceptions/api_exception.dart';
import 'package:task_app/_common/api/exceptions/invalid_response_exception.dart';
import 'package:task_app/_common/constants/base_url.dart';
import 'package:task_app/tasks/list/constants/tasks_list_url.dart';
import 'package:task_app/tasks/list/services/task_list_fetcher.dart';

import '../../../_common/mocks/network_mock.dart';
import '../_mocks/tasks_list_response.dart';

void main() {
  var successfulResponse = tasksListResponse;
  var mockNetworkAdapter = MockNetworkAdapter();
  var tasksListFetcher = TasksFetcher.initWith(mockNetworkAdapter);

  setUpAll(() {
    registerFallbackValue(APIRequest("Url"));
  });

  test('api request url is built correctly', () async {
    var currentPage = 1;
    var perPage = 15;

    var url = TasksListUrl.get(currentPage, perPage);

    expect(url, "$basicUrl/todos?_start=${currentPage * perPage}&_limit=$perPage");
  });

  test('throws NetworkFailureException when network request fails', () async {
    when(() => mockNetworkAdapter.get(any())).thenThrow(NetworkFailureException("e"));

    try {
      var _ = await tasksListFetcher.getNext(1, 15);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when response is null', () async {
    when(() => mockNetworkAdapter.get(any())).thenAnswer((_) => Future.value(APIResponse(null)));

    try {
      var _ = await tasksListFetcher.getNext(1, 15);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws InvalidResponseException when response is of the wrong format', () async {
    when(() => mockNetworkAdapter.get(any())).thenAnswer((_) => Future.value(APIResponse("data")));
    try {
      var _ = await tasksListFetcher.getNext(1, 15);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    when(() => mockNetworkAdapter.get(any())).thenAnswer((_) => Future.value(APIResponse(successfulResponse)));
    try {
      var requestItems = await tasksListFetcher.getNext(1, 15);
      expect(requestItems, isNotEmpty);
      verify(() => mockNetworkAdapter.get(any()));
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });
}
