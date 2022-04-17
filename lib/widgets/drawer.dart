import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revive/Providers/themeprovider.dart';
import 'package:revive/screens/PreReqCourses/CoursesScreen.dart';
import 'package:revive/screens/aboutUs/aboutUsScreen.dart';
import 'package:revive/screens/addNews/addnewsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/GPA/gpa_calc.dart';
import '../screens/progcourses/progresscoursesscreen.dart';
import '../screens/News/news_screen.dart';
import '../screens/todo list/todolist.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DrawerS extends StatefulWidget {
  static const routeName = '/drw';

  @override
  _DrawerSState createState() => _DrawerSState();
}

class _DrawerSState extends State<DrawerS> {
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
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    var main = MainAxisAlignment.spaceEvenly;
    var mainc = MainAxisAlignment.spaceAround;

    var decoration = BoxDecoration(
      gradient: LinearGradient(
          colors: [Color(0xff2a61a8), Color(0xff2d377a)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft),
      borderRadius: BorderRadius.circular(15),
    );
    var style = TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'No',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child:
                        Text('Yes, exit', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });

        return value == true;
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
          ),
          title: Row(children: [
            Container(
                child: Image.asset(
              'assets/images/revive11.png',
              color: Colors.white,
              height: 40,
            )),
          ]),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  provider.swapTheme();
                  isdark = !isdark;
                });
              },
              child: Icon(
                isdark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                color: Colors.white,
              ),
            )
          ],
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
            Positioned(
              child: Container(
                height: size.height - 130,
                padding: EdgeInsets.only(top: 15),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Container(
                      width: double.infinity,
                      height: size.height * 0.3,
                      child: Row(mainAxisAlignment: main, children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(MainScreen.routeName);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: decoration,
                            width: size.width * 0.4,
                            child: Column(mainAxisAlignment: mainc, children: [
                              Image.asset(
                                'assets/images/his.png',
                                height: size.height * 0.18,
                                fit: BoxFit.contain,
                              ),
                              AutoSizeText(
                                'Courses Progress',
                                style: style,
                                maxLines: 2,
                              )
                            ]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(GPACalc.routeName);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: decoration,
                            width: size.width * 0.4,
                            child: Column(mainAxisAlignment: mainc, children: [
                              Image.asset(
                                'assets/images/calc.png',
                                height: size.height * 0.15,
                              ),
                              AutoSizeText(
                                'GPA Calculator',
                                textAlign: TextAlign.center,
                                style: style,
                                maxLines: 2,
                              )
                            ]),
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      width: double.infinity,
                      height: size.height * 0.3,
                      child: Row(mainAxisAlignment: main, children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(BoardScreen.routeName);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: decoration,
                            width: size.width * 0.4,
                            child: Column(mainAxisAlignment: main, children: [
                              Image.asset(
                                'assets/images/prereq.png',
                                height: size.height * 0.2,
                                fit: BoxFit.contain,
                              ),
                              AutoSizeText(
                                'Pre-requistites Courses',
                                textAlign: TextAlign.center,
                                style: style,
                                maxLines: 2,
                              )
                            ]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(ToDoList.routeName);
                          },
                          child: Container(
                            width: size.width * 0.4,
                            decoration: decoration,
                            child: Column(mainAxisAlignment: main, children: [
                              Image.asset(
                                'assets/images/todo.png',
                                height: size.height * 0.2,
                              ),
                              AutoSizeText('To Do List',
                                  style: style, maxLines: 2)
                            ]),
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      width: double.infinity,
                      height: size.height * 0.3,
                      child: Row(mainAxisAlignment: main, children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(NewsScreen.routeName);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: decoration,
                            width: size.width * 0.4,
                            child: Column(mainAxisAlignment: main, children: [
                              Image.asset(
                                'assets/images/news.png',
                                height: size.height * 0.18,
                              ),
                              AutoSizeText('BME News',
                                  style: style, maxLines: 2)
                            ]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AboutUsScreen.routeName);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: decoration,
                            width: size.width * 0.4,
                            child: Column(mainAxisAlignment: main, children: [
                              Image.asset(
                                'assets/images/about.png',
                                height: size.height * 0.18,
                              ),
                              AutoSizeText('About Us',
                                  style: style, maxLines: 2)
                            ]),
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      width: double.infinity,
                      height: size.height * 0.3,
                      child: Row(
                        mainAxisAlignment: main,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AddNews.routeName);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: decoration,
                              width: size.width * 0.4,
                              child: Column(mainAxisAlignment: main, children: [
                                Image.asset(
                                  'assets/images/news.png',
                                  height: size.height * 0.18,
                                ),
                                AutoSizeText('Add BME News',
                                    style: style, maxLines: 2)
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 60),
                  ]),
                ),
              ),
            ),
            Positioned(
                height: 50,
                width: size.width,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                )),
            Positioned(
                right: (size.width - 100) / 2,
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      revive();
                    });
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    color: Color.fromRGBO(255, 255, 255, 0),
                    elevation: 20,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: isdark
                                  ? [Color(0xff2a61a8), Color(0xff2d377a)]
                                  : [Colors.white, Colors.white],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: isdark
                                ? Colors.white70
                                : Theme.of(context).primaryColor,
                            width: 4,
                          )),
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                        child: Image.asset(
                          'assets/images/revivelogo.png',
                          color: isdark ? Colors.white : Colors.blue[900],
                        ),
                      ),
                    ),
                  ),
                )),
          ]),
        ),
      ),
    );
  }

  revive() {
    var style = TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);

    return AwesomeDialog(
        context: context,
        isDense: true,
        btnOkColor: Colors.green,
        btnOk: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.green,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton(
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                })),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  margin: EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Text('What is Revive!',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900]),
                      textAlign: TextAlign.center)),
              Text(
                'Scientific Biomedical non profit team, supervised by BME department at Mansoura University and run by a group of talented students.',
                style: style,
                textAlign: TextAlign.justify,
              ),
              Divider(color: Colors.white),
              headlines(context, 'Vision:'),
              Text(
                  'To develop the necessary professional skills for a biomedical engineering student.',
                  textAlign: TextAlign.justify,
                  style: style),
              Divider(color: Colors.white),
              headlines(context, 'Mission:'),
              Text(
                  'Applying the acquired knowledge in innovative practical applications that help in raising the efficiency of the graduate of the program by organizing training courses and application projects, providing practical training with leading companies in the field of medical equipment, and participating in local and international competitions to achieve the goal of the program in preparing a graduate who is able to design, install, develop and maintain Integrated engineering systems used in biomedical and biological applications.',
                  textAlign: TextAlign.justify,
                  style: style),
              Divider(color: Colors.white),
              headlines(context, 'Goals:'),
              Text(
                  '• Achieving the mutual benefit of all participants in the healthcare process.',
                  textAlign: TextAlign.justify,
                  style: style),
              Text(
                  '• Keeping pace with healthcare developments in the world in general and Egypt in particular.',
                  textAlign: TextAlign.justify,
                  style: style),
              Text('• Linking theoretical studies with practical applications.',
                  textAlign: TextAlign.justify, style: style),
              Text('• Contribute to raising the efficiency of health care.',
                  textAlign: TextAlign.justify, style: style),
              Text(
                  '• Encouraging students to self-learn as one of the best learning methods.',
                  textAlign: TextAlign.justify,
                  style: style),
              Text(
                  '• Bringing students closer to the labor market since the beginning of their academic life.',
                  textAlign: TextAlign.justify,
                  style: style),
              Text(
                  '• Helping in preparing a strong graduate who is able to compete locally and regionally.',
                  textAlign: TextAlign.justify,
                  style: style),
              Text(
                  '• Clarify the different fields of work and specializations in the field of biomedical engineering.',
                  textAlign: TextAlign.justify,
                  style: style),
              Text('• Achieving symbiosis among students.',
                  textAlign: TextAlign.start, style: style),
              Text(
                  '• Establishing an organized environment that has the climate of cooperation with effective competition.',
                  textAlign: TextAlign.justify,
                  style: style),
            ],
          ),
        ),
        customHeader: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isdark
                    ? [Color(0xff2a61a8), Color(0xff2d377a)]
                    : [Colors.white, Colors.white],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft),
            borderRadius: BorderRadius.circular(54),
            border: Border.all(
              color: isdark ? Colors.white70 : Theme.of(context).primaryColor,
              width: 4,
            ),
          ),
          padding: EdgeInsets.all(3),
          child: Image.asset(
            'assets/images/revivelogo.png',
            height: 100,
            color: isdark ? Colors.white : null,
          ),
        ),
        dialogType: DialogType.NO_HEADER)
      ..show();
  }

  Widget headlines(BuildContext context, head) {
    var styleheader = TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900]);
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        head,
        style: styleheader,
      ),
    );
  }
}
