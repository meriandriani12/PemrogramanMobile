import 'package:flutter/material.dart';

// PASTIKAN NAMA KELAS INI SAMA PERSIS (HelloWorld)
class HelloWorld extends StatelessWidget {
  const HelloWorld({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Ini adalah Halaman Hello World!')),
    );
  }
}
