import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'services/local_storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    final isDark = await LocalStorageService.loadDarkMode();
    if (mounted) {
      setState(() {
        _isDarkMode = isDark;
      });
    }
  }

  void _toggleDarkMode() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await LocalStorageService.saveDarkMode(_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Tugas Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        body: const HomePage(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: FloatingActionButton.small(
            onPressed: _toggleDarkMode,
            heroTag: 'darkModeToggle',
            tooltip: _isDarkMode ? 'Light Mode' : 'Dark Mode',
            child: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ),
      ),
    );
  }
}
