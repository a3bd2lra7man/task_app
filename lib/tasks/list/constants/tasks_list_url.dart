import 'package:task_app/_common/constants/base_url.dart';

class TasksListUrl {
  static String get(int currentPage, int perPage) {
    return "$basicUrl/todos?_start=${currentPage * perPage}&_limit=$perPage";
  }
}
