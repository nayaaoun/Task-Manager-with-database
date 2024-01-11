import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Task {
  final String name;

  Task(this.name);
}

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> todoTasks = [Task('Task 1'), Task('Task 2'), Task('Task 3')];
  List<Task> inProgressTasks = [];
  List<Task> doneTasks = [];
  TextEditingController _newTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjusted to space evenly
          children: [
            _buildColumn('To Do', todoTasks),
            _buildColumn('In Progress', inProgressTasks),
            _buildColumn('Done', doneTasks),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(String title, List<Task> tasks) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return _buildTaskTile(task, title);
                },
              ),
            ),
            SizedBox(height: 16),
            if (title == 'To Do')
              TextField(
                onSubmitted: (value) {
                  _addNewTask(value);
                },
                decoration: InputDecoration(
                  labelText: 'Add a new task',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _addNewTask(_newTaskController.text);
                    },
                  ),
                ),
                controller: _newTaskController,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskTile(Task task, String columnTitle) {
    return ListTile(
      title: Text(task.name),
      trailing: _buildPopupMenuButton(task, columnTitle),
    );
  }

  PopupMenuButton<String> _buildPopupMenuButton(Task task, String columnTitle) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        _onTaskMenuItemSelected(value, task, columnTitle);
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'In Progress',
          child: Text('Move to In Progress'),
        ),
        PopupMenuItem<String>(
          value: 'Done',
          child: Text('Move to Done'),
        ),
        PopupMenuItem<String>(
          value: 'Remove',
          child: Text('Remove Task'),
        ),
      ],
    );
  }

  void _onTaskMenuItemSelected(String menuItem, Task task, String columnTitle) {
    setState(() {
      if (menuItem == 'Remove') {
        _removeTask(task, columnTitle);
      } else {
        if (columnTitle == 'To Do') {
          todoTasks.remove(task);
          if (menuItem == 'In Progress') {
            inProgressTasks.add(task);
          } else if (menuItem == 'Done') {
            doneTasks.add(task);
          }
        } else if (columnTitle == 'In Progress') {
          inProgressTasks.remove(task);
          if (menuItem == 'To Do') {
            todoTasks.add(task);
          } else if (menuItem == 'Done') {
            doneTasks.add(task);
          }
        } else if (columnTitle == 'Done') {
          doneTasks.remove(task);
          if (menuItem == 'To Do') {
            todoTasks.add(task);
          } else if (menuItem == 'In Progress') {
            inProgressTasks.add(task);
          }
        }
      }
    });
  }

void _removeTask(Task task, String columnTitle) async {
  setState(() {
    if (columnTitle == 'To Do') {
      todoTasks.remove(task);
    } else if (columnTitle == 'In Progress') {
      inProgressTasks.remove(task);
    } else if (columnTitle == 'Done') {
      doneTasks.remove(task);
    }
  });

  var url = "http://localhost/localconnect/addTask.php";

  // Send a GET request to the PHP backend to remove the task from the database
  final response = await http.get(
    Uri.parse('$url?delete=${Uri.encodeQueryComponent(task.name)}'),
  );

  if (response.statusCode == 200) {
    print("Task removed successfully");
  } else {
    print("Failed to remove task. Error: ${response.reasonPhrase}");
  }
}

  void _addNewTask(String taskName) async {
  setState(() {
    todoTasks.add(Task(taskName));
    _newTaskController.clear();
  });
 var url ="http://localhost/localconnect/addTask.php";
  // Send the new task to the PHP backend
  final response = await http.get(
   Uri.parse('$url?name=${Uri.encodeQueryComponent(taskName)}'),
  );

  if (response.statusCode == 200) {
    print("Task added successfully");
  } else {
    print("Failed to add task. Error: ${response.reasonPhrase}");
  }
}
}

void main() {
  runApp(MaterialApp(
    home: TasksScreen(),
  ));
  
}

