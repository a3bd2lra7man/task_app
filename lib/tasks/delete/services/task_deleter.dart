import 'dart:async';

import 'package:task_app/_common/api/entities/api_request.dart';
import 'package:task_app/tasks/_core/entities/task.dart';

import '../../../../_common/api/services/api.dart';
import '../../../../_common/api/services/network_adapter.dart';
import '../constants/tasks_delete_url.dart';

class TasksDeleter {
  final NetworkAdapter _networkAdapter;

  TasksDeleter() : _networkAdapter = API();

  TasksDeleter.initWith(this._networkAdapter);

  Future<void> delete(Task task) async {
    var url = TasksDeleteUrl.delete(task.id);
    var apiRequest = APIRequest(url);
    apiRequest.addParameters(task.toJson());
    await _networkAdapter.delete(apiRequest);
  }
}
