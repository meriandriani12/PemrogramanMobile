// model/feedback_item.dart
// Model untuk menyimpan data feedback mahasiswa

import 'package:flutter/material.dart';

class FeedbackItem {
  final String namaMahasiswa;
  final String nim;
  final String fakultas;
  final List<String> fasilitasDinilai;
  final double nilaiKepuasan;
  final String jenisFeedback;
  final bool setujuSyarat;
  final String? pesanTambahan;

  FeedbackItem({
    required this.namaMahasiswa,
    required this.nim,
    required this.fakultas,
    required this.fasilitasDinilai,
    required this.nilaiKepuasan,
    required this.jenisFeedback,
    required this.setujuSyarat,
    this.pesanTambahan,
  });

  // Method untuk mendapatkan ikon sesuai jenis feedback
  String getIconEmoji() {
    switch (jenisFeedback) {
      case 'Apresiasi':
        return '\u{1F44D}'; // 👍
      case 'Saran':
        return '\u{1F4A1}'; // 💡
      case 'Keluhan':
        return '\u{26A0}\u{FE0F}'; // ⚠️
      default:
        return '\u{1F4DD}'; // 📝
    }
  }

  // Method untuk mendapatkan warna sesuai jenis feedback
  Color getColor() {
    switch (jenisFeedback) {
      case 'Apresiasi':
        return Colors.green;
      case 'Saran':
        return Colors.blue;
      case 'Keluhan':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
