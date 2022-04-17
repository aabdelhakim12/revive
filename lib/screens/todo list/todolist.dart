import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:revive/Models/taskModel.dart';
import 'package:revive/helpers/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addTaskscreen.dart';

class ToDoList extends StatefulWidget {
  static const routeName = '/todolist';

  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  bool isdark;
  Future<List<Task>> _taskList;
  final DateFormat _dateFormater = DateFormat('MMM dd, yyyy, HH:mm');
  @override
  void initState() {
    super.initState();
    getPref();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  getPref() async {
    if (isdark == null) isdark = false;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      isdark = preferences.getBool('isDark');
      if (preferences.getBool('isDark') == null) isdark = false;
    });
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(children: [
        ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 18,
              decoration: task.status == 0
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
            ),
          ),
          subtitle: Text(
            '${_dateFormater.format(task.date)} • ${task.priority}',
            style: TextStyle(
              fontSize: 15,
              decoration: task.status == 0
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
            ),
          ),
          leading: Checkbox(
            value: task.status == 1 ? true : false,
            onChanged: (value) {
              task.status = value ? 1 : 0;
              DatabaseHelper.instance.updateTask(task);
              _updateTaskList();
            },
            activeColor: Colors.indigo[800],
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddTaskScreen(
                  task: task,
                ),
              ),
            ),
          ),
        ),
        Divider(),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddTaskScreen(),
          ),
        ),
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.grid_view),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
        title: Row(
          children: [
            Image.asset(
              'assets/images/todo.png',
              height: 30,
              fit: BoxFit.contain,
            ),
            Text(
              '  To Do List',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
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
        Container(
          child: FutureBuilder(
              future: _taskList,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final int comletedTaskCount = snapshot.data
                    .where((Task task) => task.status == 1)
                    .toList()
                    .length;
                double progress = comletedTaskCount / snapshot.data.length;
                return ListView.builder(
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  itemCount: 1 + snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xff2a61a8),
                                      Color(0xff2d377a)
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft),
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'My tasks',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    CircularPercentIndicator(
                                      radius: 130.0,
                                      lineWidth: 4.0,
                                      percent: 1.0 *
                                          comletedTaskCount /
                                          snapshot.data.length,
                                      center: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data.length == 0
                                                  ? '00.00'
                                                  : '${(progress * 100).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              ' %',
                                              style: TextStyle(
                                                  color: Colors.white60,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                            )
                                          ]),
                                      backgroundColor: progress == 0
                                          ? Color(0xffF44336)
                                          : Colors.white70,
                                      progressColor: progress > 0.8
                                          ? Color(0xff2E7D32)
                                          : progress < 0.8 && progress > 0.6
                                              ? Color(0xff66BB6A)
                                              : progress < 0.6 && progress > 0.4
                                                  ? Color(0xffFBC02D)
                                                  : progress < 0.4 &&
                                                          progress > 0.2
                                                      ? Color(0xffFF5722)
                                                      : Color(0xffF44336),
                                    )
                                  ]),
                            ),
                            Divider(thickness: 2),
                          ],
                        ),
                      );
                    }
                    return _buildTask(snapshot.data[index - 1]);
                  },
                );
              }),
        ),
      ]),
    );
  }
}
