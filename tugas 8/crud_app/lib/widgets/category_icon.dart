// File: lib/widgets/category_icon.dart

import 'package:flutter/material.dart';
import '../models/note.dart';

class CategoryIcon extends StatelessWidget {
  final String category;
  final double size;

  const CategoryIcon({super.key, required this.category, this.size = 24});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (category) {
      case NoteCategory.kuliah:
        icon = Icons.school;
        color = Colors.blue;
        break;
      case NoteCategory.organisasi:
        icon = Icons.groups;
        color = Colors.green;
        break;
      case NoteCategory.pribadi:
        icon = Icons.person;
        color = Colors.purple;
        break;
      case NoteCategory.lainLain:
      default:
        icon = Icons.note;
        color = Colors.orange;
        break;
    }

    return Icon(icon, size: size, color: color);
  }
}
