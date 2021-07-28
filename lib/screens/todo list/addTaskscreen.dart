import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revive/Models/taskModel.dart';
import 'package:revive/helpers/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'todolist.dart';

class AddTaskScreen extends StatefulWidget {
  final Task task;

  AddTaskScreen({this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title;
  String _priority;
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  bool isdark;
  final DateFormat _dateFormater = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ['low', 'medium', 'high'];

  @override
  void initState() {
    super.initState();
    getPref();
    if (widget.task != null) {
      _title = widget.task.title;
      _date = widget.task.date;
      _priority = widget.task.priority;
    }

    _dateController.text = _dateFormater.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormater.format(date);
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteTask(widget.task.id);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(ToDoList.routeName);
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_date, $_title, $_priority');
      // insert task to our database
      Task task = Task(title: _title, date: _date, priority: _priority);
      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateTask(task);
      }
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(ToDoList.routeName);
    }
  }

  getPref() async {
    if (isdark == null) isdark = false;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      isdark = preferences.getBool('isDark');
      if (preferences.getBool('isDark') == null) isdark = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
        title: Text(
          widget.task == null ? 'Add Task' : 'Update Task',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Stack(children: [
        Container(
          height: size.height,
          width: double.infinity,
          child: Image.asset(
            isdark ? 'assets/images/BackB.jpg' : 'assets/images/BackWh.jpg',
            fit: BoxFit.cover,
          ),
        ),
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (input) => input.trim().isEmpty
                                ? 'please enter a task title'
                                : null,
                            onSaved: (input) => _title = input,
                            initialValue: _title,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: _dateController,
                            style: TextStyle(fontSize: 18),
                            onTap: _handleDatePicker,
                            decoration: InputDecoration(
                              labelText: 'Date',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: DropdownButtonFormField(
                            onTap: () =>
                                FocusManager.instance.primaryFocus.unfocus(),
                            isDense: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconEnabledColor: Theme.of(context).primaryColor,
                            items: _priorities.map((String priority) {
                              return DropdownMenuItem(
                                onTap: () {
                                  FocusManager.instance.primaryFocus.unfocus();
                                },
                                value: priority,
                                child: Text(priority),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Priority',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (input) => _priority == null
                                ? 'please select a priority level'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                _priority = value;
                              });
                              value = _priority;
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 50),
                          height: 60,
                          width: 120,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          child: TextButton(
                            child: Text(
                              widget.task == null ? 'Add' : 'Update',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 25,
                              ),
                            ),
                            onPressed: () => _submit(),
                          ),
                        ),
                        widget.task != null
                            ? Container(
                                margin: EdgeInsets.only(top: 20),
                                height: 60,
                                width: 120,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).errorColor,
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.circular(30)),
                                child: TextButton(
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 25,
                                    ),
                                  ),
                                  onPressed: () => _delete(),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
