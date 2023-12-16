import 'package:flutter/material.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:task_app/tasks/update/ui/update_task_page.dart';
import 'package:provider/provider.dart';

import '../../../delete/ui/delete_task_icon.dart';
import '../../../update/ui/update_completed_icon.dart';
import '../../view_models/tasks_provider.dart';

class TaskListItemWidget extends StatelessWidget {
  final Task task;
  const TaskListItemWidget(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<TasksListProvider>();

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: UpdateTaskCompletedIcon.init(task, provider.onTaskUpdated),
          onTap: () => UpdateTaskPage.navigateTo(task, provider.onTaskUpdated),
          title: Text(
            task.title,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.start,
          ),
          trailing: DeleteTaskIcon.init(task, provider.onTaskDeleted),
        ),
        const Divider(),
      ],
    );
  }
}
