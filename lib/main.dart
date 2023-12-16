import 'package:flutter/material.dart';

import '_common/theme/text_theme.dart';
import 'tasks/list/ui/pages/task_list_page.dart';

void main() {
  runApp(const TasksApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class TasksApp extends StatelessWidget {
  const TasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: TasksListPage.init(),
      theme: ThemeData(
        useMaterial3: true,
        textTheme: textTheme
      ),
    );
  }
}
