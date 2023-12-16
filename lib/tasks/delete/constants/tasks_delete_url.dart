import 'package:task_app/_common/constants/base_url.dart';

class TasksDeleteUrl {
  static String delete(int id) {
    return "$basicUrl/todos/$id";
  }
}
