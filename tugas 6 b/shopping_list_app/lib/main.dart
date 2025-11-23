import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list_app/splash_screen.dart';

final themeNotifier = ValueNotifier<ThemeData>(
  ThemeData(
    primarySwatch: Colors.deepPurple,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  ),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final int? colorValue = prefs.getInt('theme_color');
    if (colorValue != null) {
      themeNotifier.value = ThemeData(
        primarySwatch: MaterialColor(colorValue, const <int, Color>{
          50: Color(0xFFE8EAF6),
          100: Color(0xFFC5CAE9),
          200: Color(0xFF9FA8DA),
          300: Color(0xFF7986CB),
          400: Color(0xFF5C6BC0),
          500: Color(0xFF5C6BC0),
          600: Color(0xFF3949AB),
          700: Color(0xFF303F9F),
          800: Color(0xFF283593),
          900: Color(0xFF1A237E),
        }),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(colorValue)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) {
        return MaterialApp(
          title: 'Shopping List',
          theme: theme,
          home: SplashScreen(),
        );
      },
    );
  }
}
