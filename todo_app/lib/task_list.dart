import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/edit_task.dart';
import 'package:todo_app/task.dart'; // Import thư viện để định dạng ngày tháng

class TaskListScreen extends StatefulWidget {
  const TaskListScreen(List tasks, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = [];
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      List<dynamic> taskData = json.decode(tasksJson);
      List<Task> loadedTasks =
          taskData.map((data) => Task.fromJson(data)).toList();
      setState(() {
        _tasks = loadedTasks;
      });
    } else {
      setState(() {
        _tasks = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Container(
            padding: const EdgeInsets.fromLTRB(23, 18, 16, 0),
            height: 163,
            decoration: BoxDecoration(
              color: _tasks[index].color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 27,
                      width: 75,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: const Color(0xff13E2C1),
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Center(child: Text("School")),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 27,
                      width: 75,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: const Color(0xff13E2C1),
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Center(child: Text("Everyday")),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        // Navigate to EditTaskScreen and wait for result
                        final updatedTask = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTaskScreen(
                                task: _tasks[index],
                                onTaskUpdated: (updatedTask) {
                                  
                                  setState(() {
                                    
                                    _tasks[index] = updatedTask;
                                  });
                                }),
                          ),
                        );
                        if (updatedTask != null) {
                        }
                      },
                      child: Image.asset('assets/edit.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  _tasks[index].name ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined),
                    const SizedBox(width: 5),
                    Text(
                      DateFormat.yMd().format(_tasks[index].time!.toLocal()),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.av_timer_outlined),
                    const SizedBox(width: 5),
                    Text(
                      DateFormat.Hm().format(_tasks[index].time!.toLocal()),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
