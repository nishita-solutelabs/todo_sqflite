import 'package:flutter/material.dart';
import 'dart:async';
import '../database_helper.dart';
import '../task.dart';
import 'task_details.dart';
import 'package:sqflite/sqflite.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<Task> taskList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (taskList == null) {
      taskList = List<Task>();
      updateListview();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('All ToDo\'s'),
        backgroundColor: Colors.deepPurple,
      ),
      body: getTaskListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
        onPressed: () {
          navigateToDetailPage(Task('', ''), 'add Task');
        },
      ),
    );
  }

  Padding getTaskListView() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.deepPurple,
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://cdn.searchenginejournal.com/wp-content/uploads/2019/08/c573bf41-6a7c-4927-845c-4ca0260aad6b-760x400.jpeg'),
                ),
                title: Text(
                  this.taskList[index].title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  this.taskList[index].date,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: GestureDetector(
                    child: Icon(Icons.edit, color: Colors.white),
                    onTap: () {
                      navigateToDetailPage(this.taskList[index], 'Edit Todo');
                    }),
              ),
            ),
          );
        },
      ),
    );
  }

  void navigateToDetailPage(Task task, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TaskDetails(task, title);
    }));
    if (result == true) {
      updateListview();
    }
  }

  void updateListview() {
    final Future<Database> dbFuture = dataBaseHelper.initalizeDatabase();
    dbFuture.then((database) {
      Future<List<Task>> taskListFuture = dataBaseHelper.getTaskList();

      taskListFuture.then((taskList) {
        setState(() {
          this.taskList = taskList;
          this.count = taskList.length;
        });
      });
    });
  }
}
