import 'dart:async';

import 'package:task_app/_common/api/entities/api_request.dart';

import '../../../_common/api/exceptions/invalid_response_exception.dart';
import '../../../_common/api/services/api.dart';
import '../../../_common/api/services/network_adapter.dart';
import '../constants/tasks_list_url.dart';

class TasksFetcher {
  final NetworkAdapter _networkAdapter;

  TasksFetcher() : _networkAdapter = API();

  TasksFetcher.initWith(this._networkAdapter);

  Future<List> getNext(int currentPage, int perPage) async {
    var url = TasksListUrl.get(currentPage, perPage);
    var apiRequest = APIRequest(url);
    var apiResponse = await _networkAdapter.get(apiRequest);
    if (apiResponse.data is! List) throw InvalidResponseException("Tasks Service File : Invalid Request Body");
    return apiResponse.data;
  }
}
