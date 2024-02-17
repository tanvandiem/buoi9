import 'package:todo_app/add_task.dart';
import 'package:todo_app/task.dart';

class TaskManager {
  static final TaskManager _instance = TaskManager._internal();
  factory TaskManager() => _instance;

  TaskManager._internal();

  List<Task> tasks = [];

  void addTask(Task task) {
    tasks.add(task);
  }

  void updateTask(Task oldTask, Task newTask) {
    int index = tasks.indexWhere((element) => element.id == oldTask.id);
    if (index != -1) {
      tasks[index] = newTask;
    }
  }

  void deleteTask(Task task) {
    tasks.removeWhere((element) => element.id == task.id);
  }
}
