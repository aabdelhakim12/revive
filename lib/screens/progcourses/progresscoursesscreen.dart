import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:revive/Models/courseModel.dart';
import 'package:revive/helpers/database_helperCourse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addCourseScreen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/hiscr';
  final int cred;

  const MainScreen({Key key, this.cred}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

Future<List<Course>> _courseList;

class _MainScreenState extends State<MainScreen> {
  int cred;
  bool isdark;
  bool sysnew;
  double gpaa;

  getPref() async {
    if (sysnew == null) sysnew = false;
    if (isdark == null) isdark = false;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      sysnew = preferences.getBool('sysnew');
      if (sysnew == null) sysnew = false;
      isdark = preferences.getBool('isDark');
      if (preferences.getBool('isDark') == null) isdark = false;
    });
  }

  @override
  void initState() {
    getPref();
    _updateCourseList();
    super.initState();
  }

  _updateCourseList() {
    setState(() {
      _courseList = DatabaseHelper.instance.getCourseList();
    });
  }

  swapSys(bool a) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setBool('sysnew', a);
    });
  }

  Widget _buildCourse(Course course) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(children: [
        ListTile(
          title: Text(
            course.title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).dividerColor),
          ),
          subtitle: Text(course.status == 1
              ? 'Credit hours:${course.credit} • GPA: ${course.gpa}'
              : 'Credit hours:${course.credit} • GPA: PC'),
          trailing: IconButton(
            icon: Icon(
              Icons.edit,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddCourseScreen(
                  course: course,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddCourseScreen(),
            )),
        child: Icon(
          Icons.add,
          color: Colors.white,
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
        title: Row(children: [
          Image.asset(
            'assets/images/his.png',
            height: 30,
          ),
          Text(
            ' Courses Progress',
            style: TextStyle(color: Colors.white),
          ),
        ]),
      ),
      body: Container(
        child: Stack(children: [
          Container(
            height: size.height,
            width: double.infinity,
            child: Image.asset(
              isdark ? 'assets/images/BackB.jpg' : 'assets/images/BackWh.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 70),
            child: FutureBuilder(
                future: _courseList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  int sum = 0;
                  double gpasum = 0;
                  int creprog = 0;
                  int covidSum = 0;
                  bool error = false;

                  for (int i = 0; i < snapshot.data.length; i++) {
                    cred = snapshot.data[i].credit;
                    sum = sum + cred;
                    creprog = sum;
                    if (!sysnew) {
                      if (sum > 180) {
                        creprog = 180;
                        error = true;
                      }
                    } else {
                      if (sum > 160) {
                        creprog = 160;
                        error = true;
                      }
                    }
                    if (snapshot.data[i].status == 0) {
                      covidSum = covidSum + cred;
                    }
                    gpasum = gpasum +
                        (snapshot.data[i].credit *
                            snapshot.data[i].gpa *
                            snapshot.data[i].status);
                  }

                  return ListView.builder(
                    itemCount: 2 + snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Container(
                          margin: EdgeInsets.only(top: 8, right: 8, left: 8),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Switch to new system',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Switch(
                                activeColor: Colors.lightBlue[100],
                                value: sysnew,
                                onChanged: (value) {
                                  setState(() {
                                    sysnew = value;
                                    swapSys(value);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }
                      if (index == 1) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft),
                          ),
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              error
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        sysnew
                                            ? ' Error..you shouldn\'t exceed 160 hours '
                                            : ' Error..you shouldn\'t exceed 180 hours ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.redAccent[700],
                                            backgroundColor: Colors.white,
                                            decoration:
                                                TextDecoration.underline),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : SizedBox(
                                      height: 10,
                                    ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                          ' GPA ',
                                          style: TextStyle(
                                              color: Color(0xff2d377a),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        snapshot.data.length == 0 ||
                                                sum - covidSum == 0
                                            ? '0.000'
                                            : '${(gpasum / (sum - covidSum)).toStringAsFixed(3)}',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      )
                                    ],
                                  ),
                                  Container(
                                    width: 2,
                                    height: 90,
                                    color: Colors.white70,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                          ' Level ',
                                          style: TextStyle(
                                              color: Color(0xff2d377a),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      sysnew
                                          ? Text(
                                              creprog < 32
                                                  ? '000'
                                                  : creprog >= 32 &&
                                                          creprog < 64
                                                      ? '100'
                                                      : creprog >= 64 &&
                                                              creprog < 96
                                                          ? '200'
                                                          : creprog >= 96 &&
                                                                  creprog < 128
                                                              ? '300'
                                                              : '400',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white))
                                          : Text(
                                              creprog < 36
                                                  ? '000'
                                                  : creprog >= 36 &&
                                                          creprog < 72
                                                      ? '100'
                                                      : creprog >= 72 &&
                                                              creprog < 108
                                                          ? '200'
                                                          : creprog >= 108 &&
                                                                  creprog < 144
                                                              ? '300'
                                                              : '400',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white))
                                    ],
                                  ),
                                  CircularPercentIndicator(
                                    footer: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        'Total passed hours',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    radius: 135.0,
                                    lineWidth: 4.0,
                                    percent:
                                        sysnew ? creprog / 160 : creprog / 180,
                                    center: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '$creprog',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            sysnew ? ' / 160' : ' / 180',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white54),
                                          ),
                                        ]),
                                    backgroundColor: Colors.white70,
                                    progressColor: Color(0xff1eb980),
                                  )
                                ],
                              ),
                              // SizedBox(
                              //   height: 12,
                              // ),
                            ],
                          ),
                        );
                      }
                      return _buildCourse(snapshot.data[index - 2]);
                    },
                  );
                }),
          ),
        ]),
      ),
    );
  }
}
