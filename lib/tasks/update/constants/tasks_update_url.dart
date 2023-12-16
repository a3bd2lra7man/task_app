import 'package:task_app/_common/constants/base_url.dart';

class TasksUpdateUrl {
  static String update(int id) {
    return "$basicUrl/todos/$id";
  }
}
