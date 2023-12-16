import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TasksListLoader extends StatelessWidget {
  const TasksListLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).highlightColor,
      highlightColor: Colors.white,
      child: ListView(
        children: [
          const Divider(),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, __) => const TasksListItemLoader(),
            separatorBuilder: (__, _) => const Divider(),
            itemCount: 20,
          ),
        ],
      ),
    );
  }
}

class TasksListItemLoader extends StatelessWidget {
  const TasksListItemLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      title: SizedBox(
        height: 24,
        width: double.maxFinite,
        child: Container(
          color: Colors.white,
        ),
      ),
      leading: SizedBox(
        width: 28,
        height: 28,
        child: Icon(
          Icons.circle_outlined,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
      ),
      trailing: SizedBox(
        width: 28,
        height: 28,
        child: Icon(
          Icons.delete,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
      ),
    );
  }
}
