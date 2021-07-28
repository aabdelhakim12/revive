import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:revive/screens/progcourses/progresscoursesscreen.dart';
import 'package:revive/screens/aboutUs/aboutUsScreen.dart';
import 'package:revive/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Providers/themeprovider.dart';
import 'screens/GPA/gpa_calc.dart';
import 'screens/News/news_screen.dart';
import 'screens/PreReqCourses/CoursesScreen.dart';
import 'screens/start_screen.dart';
import 'screens/todo list/todolist.dart';
import 'screens/addNews/addnewsScreen.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SharedPreferences preferences = await SharedPreferences.getInstance();
  return runApp(ChangeNotifierProvider(
    child: MyApp(),
    create: (BuildContext ctx) => ThemeProvider(
        isDarkMode: preferences.getBool('isDark') == null
            ? false
            : preferences.getBool('isDark')),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Revive',
      theme: themeProvider.getTheme,
      home: StartScreen(),
      initialRoute: '/',
      routes: {
        MainScreen.routeName: (ctx) => MainScreen(),
        GPACalc.routeName: (ctx) => GPACalc(),
        ToDoList.routeName: (ctx) => ToDoList(),
        NewsScreen.routeName: (ctx) => NewsScreen(),
        BoardScreen.routeName: (ctx) => BoardScreen(),
        AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
        AddNews.routeName: (ctx) => AddNews(),
        DrawerS.routeName: (ctx) => DrawerS(),
      },
    );
  }
}
