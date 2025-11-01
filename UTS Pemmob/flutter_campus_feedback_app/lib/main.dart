// main.dart
// Aplikasi Flutter Campus Feedback
// Mata Kuliah: Pemrograman Perangkat Bergerak
// Dosen: Ahmad Nasukha, S.Hum., M.S.I
// Program Studi Sistem Informasi – UIN Sulthan Thaha Saifuddin Jambi

import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Campus Feedback',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
