import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/task.dart';
import 'package:todo_app/task_list.dart'; // Thêm import task_list.dart

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onTaskUpdated;

  EditTaskScreen({required this.task, required this.onTaskUpdated});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _nameController;
  late TextEditingController _placeController;
  late DateTime? _selectedDateTime;
  late Color? _selectedColor;
  int _selectedLevelIndex = 0;
  List<bool> _isSelected = [true, false, false];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
    _placeController = TextEditingController(text: widget.task.place);
    _selectedDateTime = widget.task.time;
    _selectedColor = widget.task.color;
    _selectedLevelIndex = widget.task.le!.index;
    for (int i = 0; i < _isSelected.length; i++) {
      _isSelected[i] = i == _selectedLevelIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        forceMaterialTransparency: true,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Edit Task",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                cursorColor: Color(0xffB6B6B6),
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Task Name'),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Select Color: '),
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
                              pickerColor: _selectedColor ?? Colors.blue,
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
                        initialDate: _selectedDateTime ?? DateTime.now(),
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
              const Divider(height: 20, thickness: 2, color: Color(0xffEAEAEA)),
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
                  SizedBox(height: 5),
                ],
              ),
              const Divider(height: 20, thickness: 2, color: Color(0xffEAEAEA)),
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
          onPressed: _onSaveTask,
          child: Text('Update Task'),
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
            borderRadius: BorderRadius.circular(20),
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

  void _onSaveTask() {
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

    Task updatedTask = Task(
      name: _nameController.text,
      place: _placeController.text,
      time: _selectedDateTime,
      le: selectedLevel,
      color: _selectedColor,
    );
    saveTaskToSharedPreferences(updatedTask);
    widget.onTaskUpdated(updatedTask);
    Navigator.pop(context); // Quay lại màn hình trước đó (TaskListScreen)
  }

  void saveTaskToSharedPreferences(Task task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('tasks', jsonEncode(task));
  }
}
