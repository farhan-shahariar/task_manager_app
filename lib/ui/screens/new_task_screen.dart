import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/models/task_count_by_status_wrapper_model.dart';
import 'package:task_manager_app/data/models/task_list_wrapper_model.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/data/network_caller/network_caller.dart';
import 'package:task_manager_app/data/utilities/urls.dart';
import 'package:task_manager_app/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_app/ui/utility/app_colors.dart';
import 'package:task_manager_app/ui/widgets/centered_progress-indicator.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';
import '../../data/models/task_count_by_status_model.dart';
import '../widgets/task_item.dart';
import '../widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTasksInProgress = false;
  List<TaskModel> newTaskList = [];
  bool _getTaskCountByStatusInProgress = false;
  List<TaskCountByStatusModel> taskCountByStatusList = [];
  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus();
    _getNewTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
        child: Column(
          children: [
            _buildSummarySection(),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _getTaskCountByStatus();
                  _getNewTask();
                },
                child: Visibility(
                  visible: _getNewTasksInProgress == false,
                  replacement: const CenteredProgressIndicator(),
                  child: ListView.builder(
                    itemCount: newTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        taskModel: newTaskList[index],
                        onUpdateTask: () {
                          _getTaskCountByStatus();
                          _getNewTask();
                        },
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        onPressed: _onTapAddButton,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Visibility(
      visible: _getTaskCountByStatusInProgress == false,
      replacement: const SizedBox(
        height: 100,
        child: CenteredProgressIndicator(),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: taskCountByStatusList.map((e) {
          return TaskSummaryCard(
            count: e.sum.toString(),
            title: (e.sId ?? 'Unknown').toUpperCase(),
          );
        }).toList()),
      ),
    );
  }

  void _onTapAddButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
  }

  Future<void> _getNewTask() async {
    _getNewTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.newTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      newTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Get new task failed! Try again.');
      }
    }
    _getNewTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getTaskCountByStatus() async {
    _getTaskCountByStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
          TaskCountByStatusWrapperModel.fromJson(response.responseData);
      taskCountByStatusList =
          taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
            context,
            response.errorMessage ??
                'Get task count by status failed! Try again.');
      }
    }
    _getTaskCountByStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
