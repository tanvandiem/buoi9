import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/add_task.dart';
import 'package:todo_app/edit_task.dart';
import 'package:todo_app/profile.dart';
import 'package:todo_app/task.dart';
import 'package:todo_app/task_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = Colors.black;

  final _tabs = [
    const Tab(text: 'Today'),
    const Tab(text: 'Upcoming'),
    const Tab(text: 'Finished'),
  ];

  late List<Task>? _tasks = [];
  late List<Task>? _todayTasks = [];
  late List<Task>? _finishedTasks = [];
  late List<Task>? _upcomingTasks = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _fetchTasksFromSharedPreferences();
  }

  void _handleTabSelection() {
    // Handle tab selection if needed
  }
  void saveTasksToSharedPreferences(List<Task> tasks) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('tasks', jsonEncode(tasks));
}


  void _fetchTasksFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _tasks = _getTasksFromJson(prefs.getString('tasks'));
      _todayTasks = _getTasksFromJson(prefs.getString('todayTasks'));
      _finishedTasks = _getTasksFromJson(prefs.getString('finishedTasks'));
      _upcomingTasks = _getTasksFromJson(prefs.getString('upcomingTasks'));
      _isLoading = false; // Data loaded
    });
  }

  List<Task> _getTasksFromJson(String? json) {
    if (json == null) {
      return [];
    }
    List<dynamic> tasksData = jsonDecode(json);
    return tasksData.map((e) => Task.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            "Task Manager",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: const [
            Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 41,
            ),
            SizedBox(
              width: 10,
            )
          ],
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Image.asset('assets/gr.png'),
            ),
          ),
        ),
        body: _isLoading
            ? _buildLoadingIndicator()
            : Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back!",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Here's Update Today",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TabBar(
                      controller: _tabController,
                      tabs: _tabs,
                      unselectedLabelColor: Colors.black,
                      labelColor: Colors.white,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        color: _selectedColor,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          TaskListScreen(_tasks!),
                          Container(),
                          Container(),
                          // TaskListScreen(_upcomingTasks!),
                          // TaskListScreen(_finishedTasks!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: FloatingActionButton.extended(
            heroTag: "bt1",
            // Trong HomePage
            onPressed: () async {
              // Hiển thị AddTaskScreen và nhận task từ nó
              Task? newTask = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen(_tasks!)),
              );

              // Kiểm tra nếu task không null và thêm task vào danh sách
              if (newTask != null) {
                setState(() {
                  _tasks?.add(newTask); 
                  saveTasksToSharedPreferences(newTask as List<Task>);// Thêm task vào danh sách tasks
                });
              }
            },

            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            icon: const Icon(
              Icons.add_box_rounded,
              size: 21,
            ),
            label: const Text(
              "Add Task",
              style: TextStyle(fontSize: 21),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
