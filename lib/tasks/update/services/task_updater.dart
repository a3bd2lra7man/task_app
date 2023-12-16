import 'dart:async';

import 'package:task_app/_common/api/entities/api_request.dart';

import '../../../../_common/api/services/api.dart';
import '../../../../_common/api/services/network_adapter.dart';
import '../../_common/forms/task_form_data.dart';
import '../constants/tasks_update_url.dart';

class TasksUpdater {
  final NetworkAdapter _networkAdapter;

  TasksUpdater() : _networkAdapter = API();

  TasksUpdater.initWith(this._networkAdapter);

  Future<void> update(int id, TaskFormData updatedTask) async {
    var url = TasksUpdateUrl.update(id);
    var apiRequest = APIRequest(url);
    apiRequest.addParameters(updatedTask.toJson());
    await _networkAdapter.put(apiRequest);
  }

  Future<void> updateCompleted(int id, bool completed) async {
    var url = TasksUpdateUrl.update(id);
    var apiRequest = APIRequest(url);
    apiRequest.addParameter('completed', completed);
    await _networkAdapter.put(apiRequest);
  }
}
