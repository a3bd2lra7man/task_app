import 'package:flutter/material.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:provider/provider.dart';

import '../view_models.dart/delete_task_provider.dart';

class DeleteTaskIcon extends StatelessWidget {
  static Widget init(Task task, Function(Task) onTaskDeleted) {
    return ChangeNotifierProvider(
      create: (_) => DeleteTaskProvider(onTaskDeleted: onTaskDeleted),
      child: DeleteTaskIcon._(task),
    );
  }

  final Task task;

  const DeleteTaskIcon._(this.task);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<DeleteTaskProvider>();
    return SizedBox(
      width: 28,
      height: 28,
      child: provider.isLoading
          ? const Center(child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator()))
          : InkWell(
              onTap: () {
                provider.deleteTask(task);
              },
              child: Icon(
                Icons.delete_outline_rounded,
                color: Colors.grey[800],
              ),
            ),
    );
  }
}
