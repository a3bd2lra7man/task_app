import 'package:flutter/material.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:provider/provider.dart';

import '../view_models.dart/update_task_completed_provider.dart';

class UpdateTaskCompletedIcon extends StatelessWidget {
  static init(Task task, Function onTaskUpdated) {
    return ChangeNotifierProvider(
      create: (_) => UpdateTasksCompletedStatusProvider(task, onTaskUpdated: () {
        onTaskUpdated();
      }),
      child: UpdateTaskCompletedIcon._(task),
    );
  }

  final Task task;
  const UpdateTaskCompletedIcon._(this.task);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<UpdateTasksCompletedStatusProvider>();
    return SizedBox(
      width: 28,
      height: 28,
      child: provider.isLoading
          ? const Center(child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator()))
          : InkWell(
              child: Icon(
                task.completed ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              onTap: () => provider.updateTask(task, !task.completed),
            ),
    );
  }
}
