import 'package:flutter/material.dart';
import 'package:task_app/tasks/add/ui/add_task_page.dart';
import 'package:task_app/tasks/list/ui/widgets/task_list_item.dart';
import 'package:task_app/tasks/list/ui/widgets/tasks_list_error_widget.dart';
import 'package:task_app/tasks/list/view_models/tasks_provider.dart';
import 'package:provider/provider.dart';

import '../loader/task_list_loader.dart';

class TasksListPage extends StatefulWidget {
  static Widget init() {
    return ChangeNotifierProvider(create: (_) => TasksListProvider(), child: const TasksListPage._());
  }

  const TasksListPage._();

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<TasksListProvider>().getNextTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<TasksListProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks List"),
        actions: [
          IconButton(
            onPressed: () {
              AddNewTaskPage.navigateTo((task) async {
                await provider.onTaskAdded(task);
                _scrollController.animateTo(0, duration: const Duration(milliseconds: 100), curve: Curves.bounceIn);
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: provider.isPageError
                ?
                // when there is no tasks and error in the same time
                TasksListErrorWidget(errorMessage: provider.errorMessage, onRetry: provider.onRetry)
                : provider.isFirstLoading
                    ? const TasksListLoader()
                    : provider.isTasksEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "There is no tasks \n please check your internet connection",
                                textAlign: TextAlign.center,
                              ),
                              TextButton(onPressed: provider.onRetry, child: const Text("Retry"))
                            ],
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              provider.refresh();
                            },
                            child: ListView(
                              controller: _scrollController,
                              children: [
                                const Divider(),
                                ListView.separated(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: provider.tasks.length,
                                  itemBuilder: (context, index) => TaskListItemWidget(provider.tasks[index]),
                                  separatorBuilder: (__, _) => const Divider(),
                                ),
                                if (provider.isPaginationLoading) const Center(child: CircularProgressIndicator()),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
          ),
          // when there is tasks and error in the same time
          if (provider.isSnackError)
            Container(
              color: Colors.red,
              width: double.maxFinite,
              child: Text(
                provider.errorMessage,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
