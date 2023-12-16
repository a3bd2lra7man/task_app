import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/tasks/_common/forms/form_validator.dart';

import '../widgets/primary_edit_text.dart';

class TaskForm extends StatelessWidget {
  static Widget init(TaskFormValidator validator) {
    return ChangeNotifierProvider(create: (_) => validator, child: const TaskForm._());
  }

  const TaskForm._();

  @override
  Widget build(BuildContext context) {
    var validator = context.watch<TaskFormValidator>();
    return Form(
      key: validator.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                "Title",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(width: 8),
              Text("*", style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryEditText(
            controller: validator.titleController,
            validator: validator.isTitleValid,
          ),
          const SizedBox(height: 24),
          Text(
            "Description",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          PrimaryEditText(
            controller: validator.descriptionController,
            minLines: 4,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                "Completed",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Transform.scale(
                scale: 1.4,
                child: Checkbox(
                  value: validator.isCompleted,
                  onChanged: validator.onCompletedChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
