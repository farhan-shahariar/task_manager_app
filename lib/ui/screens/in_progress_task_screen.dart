import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/widgets/centered_progress-indicator.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_item.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  List<TaskModel> inProgressTaskList = [];
  bool _getInProgressTaskInProgress = false;
  @override
  void initState() {
    super.initState();
    _getInProgressTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            _getInProgressTask();
          },
          child: Visibility(
            visible: _getInProgressTaskInProgress == false,
            replacement: const CenteredProgressIndicator(),
            child: ListView.builder(
              itemCount: inProgressTaskList.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  taskModel: inProgressTaskList[index],
                  onUpdateTask: () {
                    _getInProgressTask();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getInProgressTask() async {
    _getInProgressTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.inProgressTask);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      inProgressTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Get in progress task failed! Try again.');
      }
    }
    _getInProgressTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
