import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/models/task_list_wrapper_model.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/data/network_caller/network_caller.dart';
import 'package:task_manager_app/data/utilities/urls.dart';
import 'package:task_manager_app/ui/widgets/centered_progress-indicator.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

import '../widgets/task_item.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  List<TaskModel> completedTaskList = [];
  bool _getCompletedTaskInProgress = false;
  @override
  void initState() {
    super.initState();
    _getCompletedTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            _getCompletedTask();
          },
          child: Visibility(
            visible: _getCompletedTaskInProgress == false,
            replacement: const CenteredProgressIndicator(),
            child: ListView.builder(
              itemCount: completedTaskList.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  taskModel: completedTaskList[index],
                  onUpdateTask: () {
                    _getCompletedTask();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getCompletedTask() async {
    _getCompletedTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.completedTask);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      completedTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Get completed task failed! Try again.');
      }
    }
    _getCompletedTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
