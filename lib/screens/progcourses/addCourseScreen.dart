import 'package:flutter/material.dart';
import 'package:revive/Models/courseModel.dart';
import 'package:revive/helpers/database_helperCourse.dart';
import 'package:revive/screens/progcourses/progresscoursesscreen.dart';
import 'package:revive/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCourseScreen extends StatefulWidget {
  final Course course;

  AddCourseScreen({this.course});

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title;
  int _credit;
  double _gpa;

  final List<int> _credits = [2, 3, 4, 6];

  @override
  void initState() {
    super.initState();
    getPref();

    if (widget.course != null) {
      _title = widget.course.title;
      _gpa = widget.course.gpa;
      _credit = widget.course.credit;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _delete() {
    DatabaseHelper.instance.deleteCourse(widget.course.id);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(DrawerS.routeName, (route) => false);
    Navigator.of(context).pushNamed(MainScreen.routeName);
  }

  _submit() {
    setState(() {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        // insert course to our database
        Course course = Course(title: _title, credit: _credit, gpa: _gpa);
        if (widget.course == null) {
          DatabaseHelper.instance.insertCourse(course);
        } else {
          course.id = widget.course.id;
          course.status = widget.course.status;
          DatabaseHelper.instance.updateCourse(course);
        }
        Navigator.of(context)
            .pushNamedAndRemoveUntil(DrawerS.routeName, (route) => false);
        Navigator.of(context).pushNamed(MainScreen.routeName);
      }
    });
  }

  bool isdark;

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
          widget.course == null ? 'Add Course' : 'Update Course',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
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
        GestureDetector(
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
                            onTap: () => FocusScope.of(context).unfocus(),
                            validator: (input) => input.trim().isEmpty
                                ? 'Please enter a course title'
                                : null,
                            onSaved: (input) => _title = input,
                            initialValue: _title,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: DropdownButtonFormField(
                            isDense: true,
                            icon: Icon(Icons.arrow_drop_down),
                            items: _credits.map((int credit) {
                              return DropdownMenuItem(
                                value: credit,
                                child: Text(
                                  credit.toString(),
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Credit hours',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onTap: () {
                              FocusManager.instance.primaryFocus.unfocus();
                            },
                            validator: (input) => _credit == null
                                ? 'Please select credit hours'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                _credit = value;
                              });
                              value = _credit;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              labelText: 'GPA',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (input) => input.trim().isEmpty
                                ? 'please enter a course GPA'
                                : double.parse(input) > 4
                                    ? 'there is no GPA more than 4'
                                    : null,
                            onSaved: (input) {
                              _gpa = double.parse(input);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                              widget.course == null ? 'Add' : 'Update',
                              style: TextStyle(
                                fontSize: 25,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: () => _submit(),
                          ),
                        ),
                        widget.course != null
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
