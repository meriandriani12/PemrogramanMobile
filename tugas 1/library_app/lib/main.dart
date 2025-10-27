import 'package:flutter/material.dart';
import 'package:library_app/UI/mahasiswa_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Library', home: MahasiswaPage());
  }
}
