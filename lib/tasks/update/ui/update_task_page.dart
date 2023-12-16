import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:provider/provider.dart';

import '../../../_common/screen_navigator/screen_navigator.dart';
import '../../_common/forms/task_form.dart';
import '../../_common/widgets/primary_button.dart';
import '../view_models.dart/update_task_provider.dart';

class UpdateTaskPage extends StatelessWidget {
  static navigateTo(Task task, Function onTaskUpdated) {
    ScreenNavigator.navigateTo(
      ChangeNotifierProvider(
        create: (_) => UpdateTaskProvider(task, onTaskUpdated: () {
          ScreenNavigator.pop();
          onTaskUpdated();
        }),
        child: UpdateTaskPage._(task),
      ),
    );
  }

  final Task task;
  const UpdateTaskPage._(this.task);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<UpdateTaskProvider>();
    return KeyboardDismissOnTap(
      child: AbsorbPointer(
        absorbing: provider.isLoading,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Update Task"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: TaskForm.init(provider.validator),
                  ),
                ),
                provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : PrimaryButton(
                        text: "Update",
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          provider.updateTask(task);
                        },
                      ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
