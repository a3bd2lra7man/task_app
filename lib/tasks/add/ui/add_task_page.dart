import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:task_app/tasks/add/view_models.dart/add_task_provider.dart';
import 'package:provider/provider.dart';

import '../../../_common/screen_navigator/screen_navigator.dart';
import '../../_common/forms/task_form.dart';
import '../../_common/widgets/primary_button.dart';

class AddNewTaskPage extends StatelessWidget {
  static navigateTo(Function(Task) onTaskAdded) {
    ScreenNavigator.navigateTo(
      ChangeNotifierProvider(
        create: (_) => AddTaskProvider( onTaskAdded: (task) {
          ScreenNavigator.pop();
          onTaskAdded(task);
        }),
        child: const AddNewTaskPage._(),
      ),
      slideDirection: SlideDirection.fromBottom,
    );
  }

  const AddNewTaskPage._();

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AddTaskProvider>();
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Task"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: TaskForm.init(provider.validator),
                ),
              ),
              provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(
                      text: "Add",
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        provider.addTask();
                      },
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
