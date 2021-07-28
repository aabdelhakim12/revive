import 'package:flutter/material.dart';
import 'package:revive/screens/PreReqCourses/chooseNew.dart';
import 'package:revive/screens/PreReqCourses/choose.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardScreen extends StatefulWidget {
  static const routeName = '/sbj';
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  bool isdark;
  bool sysnew;

  getPref() async {
    if (isdark == null) isdark = false;
    if (sysnew == null) sysnew = false;
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
    super.initState();
  }

  swapSys(bool a) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setBool('sysnew', a);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
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
              'assets/images/prereq.png',
              height: 25,
              fit: BoxFit.contain,
            ),
            Text('  Pre-requistites Courses'),
          ],
        ),
      ),
      body: SingleChildScrollView(
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
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8, right: 8, left: 8),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                ),
                sysnew ? ChooseNew() : Choose(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
