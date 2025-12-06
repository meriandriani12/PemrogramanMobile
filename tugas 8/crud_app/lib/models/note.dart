// File: lib/models/note.dart

class Note {
  String title;
  String content;
  DateTime createdAt;
  String category; // 'Kuliah', 'Organisasi', 'Pribadi', 'Lain-lain'

  Note({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.category,
  });

  // Convert Note to Map untuk disimpan
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
    };
  }

  // Convert Map ke Note saat load data
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      category: map['category'] ?? 'Lain-lain',
    );
  }
}

// List kategori yang tersedia
class NoteCategory {
  static const String kuliah = 'Kuliah';
  static const String organisasi = 'Organisasi';
  static const String pribadi = 'Pribadi';
  static const String lainLain = 'Lain-lain';

  static List<String> getAll() {
    return [kuliah, organisasi, pribadi, lainLain];
  }
}
