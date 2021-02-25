import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../task.dart';
import 'package:intl/intl.dart';

class TaskDetails extends StatefulWidget {
  final Task task;
  final String appBarTitle;

  const TaskDetails(this.task, this.appBarTitle);

  @override
  _TaskDetailsState createState() =>
      _TaskDetailsState(this.task, this.appBarTitle);
}

class _TaskDetailsState extends State<TaskDetails> {
  Task task;
  String appBarTitle;
  DataBaseHelper helper = DataBaseHelper();

  _TaskDetailsState(this.task, this.appBarTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = task.title;
    descController.text = task.description;
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        backgroundColor: Colors.cyanAccent,
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: Colors.pink,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
                  child: TextField(
                    controller: titleController,
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      icon: Icon(Icons.title),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
                  child: TextField(
                    controller: descController,
                    onChanged: (value) {
                      updateDesc();
                    },
                    decoration: InputDecoration(
                      labelText: 'Description',
                      icon: Icon(Icons.details),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.green,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Save task',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 20.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.red,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Delete task',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              _delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateTitle() {
    task.title = titleController.text;
  }

  void updateDesc() {
    task.description = descController.text;
  }

  void _save() async {
    moveToLastScreen();
    task.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (task.id != null) {
      result = await helper.updateTask(task);
    } else {
      result = await helper.insertTask(task);
    }

    if (result != 0) {
      _showAlertDialog('status', 'Task added successfully');
    } else {
      _showAlertDialog('status', 'Problem in adding task');
    }
  }

  void _delete() async {
    moveToLastScreen();
    if (task.id == null) {
      _showAlertDialog('status', 'First add the task');
      return;
    }
    int result = await helper.deleteTask(task.id);
    if (result != 0) {
      _showAlertDialog('status', 'Task deleted successfully');
    } else {
      _showAlertDialog('status', 'Error');
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
