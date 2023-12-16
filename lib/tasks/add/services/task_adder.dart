import 'dart:async';

import 'package:task_app/_common/api/entities/api_request.dart';
import 'package:task_app/tasks/_core/entities/task.dart';

import '../../../../_common/api/exceptions/invalid_response_exception.dart';
import '../../../../_common/api/services/api.dart';
import '../../../../_common/api/services/network_adapter.dart';
import '../../_common/forms/task_form_data.dart';
import '../constants/tasks_add_url.dart';

class TasksAdder {
  final NetworkAdapter _networkAdapter;

  TasksAdder() : _networkAdapter = API();

  TasksAdder.initWith(this._networkAdapter);

  Future<Task> add(TaskFormData newTask) async {
    var url = TasksAddUrl.add();
    var apiRequest = APIRequest(url);
    apiRequest.addParameters(newTask.toJson());
    var apiResponse = await _networkAdapter.post(apiRequest);
    if (apiResponse.data is! Map || apiResponse.data?['id'] is! int) {
      throw InvalidResponseException("Tasks Adder File : Invalid Request Body");
    }
    var id = apiResponse.data['id'];
    return newTask.toTask(id);
  }
}
