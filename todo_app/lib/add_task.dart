import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/task.dart';

class AddTaskScreen extends StatefulWidget {
  late final List<dynamic> tasks;

  AddTaskScreen(this.tasks);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  DateTime? _selectedDateTime;
  Color? _selectedColor;
  int _selectedLevelIndex = 0;
  List<bool> _isSelected = [true, false, false];

 Future<void> _saveTask() async {
  if (_nameController.text.isEmpty || _selectedDateTime == null) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Please enter task name and select due time.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, widget.tasks); // Đóng dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  } else {
    Level selectedLevel;
    switch (_selectedLevelIndex) {
      case 0:
        selectedLevel = Level.urgent;
        break;
      case 1:
        selectedLevel = Level.basic;
        break;
      case 2:
        selectedLevel = Level.important;
        break;
      default:
        selectedLevel = Level.basic;
    }

    Task newTask = Task(
      name: _nameController.text,
      place: _placeController.text,
      time: _selectedDateTime,
      le: selectedLevel,
      color: _selectedColor,
    );

    // Lấy danh sách tasks từ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksJson = prefs.getString('tasks');
    List<Task> tasks = tasksJson != null ? jsonDecode(tasksJson).map<Task>((taskJson) => Task.fromJson(taskJson)).toList() : [];

    // Thêm task mới vào danh sách tasks
    tasks.add(newTask);

    // Lưu danh sách tasks mới vào SharedPreferences
    await prefs.setString('tasks', jsonEncode(tasks));

    // Trả về task mới đã thêm để hiển thị trên trang chính
  Navigator.pop(context, widget.tasks); 
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        forceMaterialTransparency: true,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Add Task",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                cursorColor: Color(0xffB6B6B6),
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Task Name'),
              ),
              SizedBox(height: 16),
              Text('Select Color: '),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _selectedColor,
                    radius: 16,
                  ),
                  IconButton(
                    icon: Icon(Icons.color_lens),
                    onPressed: () async {
                      Color? pickedColor = await showDialog<Color>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Pick a color'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: Colors.blue,
                              onColorChanged: (Color color) {
                                setState(() {
                                  _selectedColor = color;
                                });
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(_selectedColor);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                      if (pickedColor != null) {
                        setState(() {
                          _selectedColor = pickedColor;
                        });
                      }
                    },
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 2, color: Color(0xffEAEAEA)),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Time ',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        _selectedDateTime == null
                            ? 'No Date and Time Selected'
                            : '${DateFormat('MM/dd/yyyy HH:mm').format(_selectedDateTime!)}',
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.calendar_month_outlined),
                    onPressed: () async {
                      DateTime? pickedDateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDateTime != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _selectedDateTime = DateTime(
                              pickedDateTime.year,
                              pickedDateTime.month,
                              pickedDateTime.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
              const Divider(height: 40, thickness: 2, color: Color(0xffEAEAEA)),
              TextField(
                cursorColor: Color(0xffB6B6B6),
                controller: _placeController,
                decoration: InputDecoration(labelText: 'Task Place'),
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' Level ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildToggleButton('Urgent', 0),
                      _buildToggleButton('Basic', 1),
                      _buildToggleButton('Important', 2),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  const Divider(
                      height: 40, thickness: 2, color: Color(0xffEAEAEA)),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29),
            ),
            minimumSize: Size(346, 49),
          ),
          onPressed: _saveTask,
          child: Text('Add Task'),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, int index) {
    bool isSelected = _isSelected[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          for (int buttonIndex = 0;
              buttonIndex < _isSelected.length;
              buttonIndex++) {
            _isSelected[buttonIndex] = buttonIndex == index;
          }
          _selectedLevelIndex = index;
        });
      },
      child: Center(
        child: Container(
          height: 38,
          width: 105,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
