import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme;
  bool isDark;
  bool sysnew;

  ThemeData darkTheme = ThemeData(
    dividerColor: Colors.grey,
    primaryColor: Color(0xff2a61a8),
    scaffoldBackgroundColor: Color(0xff111111),
    colorScheme: ColorScheme.dark(
      background: Color(0xff101010),
      surface: Color(0xff202020),
      primary: Color(0xff2a61a8),
      secondary: Color(0xff2a61a8),
      onBackground: Colors.grey,
      onSurface: Colors.grey[400],
      onPrimary: Color(0xffc2c2c2),
      onSecondary: Colors.white,
    ),
  );
  ThemeData lightTheme = ThemeData(
    dividerColor: Color(0xff2a61a8),
    primaryColor: Color(0xff2a61a8),
    scaffoldBackgroundColor: Colors.grey[200],
    colorScheme: ColorScheme.light(
      background: Colors.grey[200],
      surface: Colors.grey[400],
      primary: Color(0xff2a61a8),
      secondary: Color(0xff2a61a8),
      onBackground: Color(0xff2a61a8),
      onSurface: Color(0xff101010),
      onPrimary: Color(0xffc2c2c2),
      onSecondary: Colors.white,
    ),
  );
  ThemeProvider({bool isDarkMode}) {
    _selectedTheme = isDarkMode ? darkTheme : lightTheme;
  }

  Future<void> swapTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (_selectedTheme == darkTheme) {
      _selectedTheme = lightTheme;
      preferences.setBool('isDark', false);

      isDark = preferences.getBool('isDark');
    } else {
      _selectedTheme = darkTheme;
      preferences.setBool('isDark', true);
      isDark = preferences.getBool('isDark');
    }
    notifyListeners();
  }

  ThemeData get getTheme => _selectedTheme;
}
