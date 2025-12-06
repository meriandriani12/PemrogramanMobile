// File: lib/services/local_storage_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class LocalStorageService {
  static const String _notesKey = 'notes_list';
  static const String _darkModeKey = 'dark_mode';

  // Simpan daftar catatan
  static Future<void> saveNotes(List<Note> notes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = notes.map((note) => note.toMap()).toList();
      await prefs.setString(_notesKey, jsonEncode(notesJson));
    } catch (e) {
      print('Error saving notes: $e');
    }
  }

  // Load daftar catatan
  static Future<List<Note>> loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesString = prefs.getString(_notesKey);

      if (notesString == null || notesString.isEmpty) {
        return [];
      }

      final notesJson = jsonDecode(notesString) as List;
      return notesJson.map((json) {
        return Note.fromMap(json as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error loading notes: $e');
      return [];
    }
  }

  // Simpan preferensi dark mode
  static Future<void> saveDarkMode(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, isDark);
    } catch (e) {
      print('Error saving dark mode: $e');
    }
  }

  // Load preferensi dark mode
  static Future<bool> loadDarkMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_darkModeKey) ?? false;
    } catch (e) {
      print('Error loading dark mode: $e');
      return false;
    }
  }
}
