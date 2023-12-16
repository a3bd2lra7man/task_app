import 'package:flutter/material.dart';

class TasksListErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  const TasksListErrorWidget({super.key, required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            textAlign: TextAlign.center,
          ),
          TextButton(onPressed: onRetry, child: const Text("Retry"))
        ],
      ),
    );
  }
}
