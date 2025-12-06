// File: lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../services/local_storage_service.dart';
import '../widgets/category_icon.dart';
import 'note_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _allNotes = [];
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Load catatan dari SharedPreferences
  Future<void> _loadNotes() async {
    final notes = await LocalStorageService.loadNotes();
    setState(() {
      _allNotes = notes;
    });
  }

  // Simpan catatan ke SharedPreferences
  Future<void> _saveNotes() async {
    await LocalStorageService.saveNotes(_allNotes);
  }

  // Filter catatan berdasarkan kategori
  List<Note> get _filteredNotes {
    if (_selectedCategory == 'Semua') {
      return _allNotes;
    }
    return _allNotes
        .where((note) => note.category == _selectedCategory)
        .toList();
  }

  // Tambah catatan baru
  Future<void> _addNote() async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (context) => const NoteFormPage(),
      ),
    );

    if (result != null) {
      setState(() {
        _allNotes.add(result);
      });
      await _saveNotes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan berhasil ditambahkan')),
        );
      }
    }
  }

  // Edit catatan
  Future<void> _editNote(int index) async {
    final currentIndex = _allNotes.indexOf(_filteredNotes[index]);
    final current = _allNotes[currentIndex];

    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (context) => NoteFormPage(
          existingNote: current,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _allNotes[currentIndex] = result;
      });
      await _saveNotes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan berhasil diperbarui')),
        );
      }
    }
  }

  // Hapus catatan
  void _deleteNote(int index) {
    final currentIndex = _allNotes.indexOf(_filteredNotes[index]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _allNotes.removeAt(currentIndex);
              });
              await _saveNotes();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Catatan dihapus')),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = _filteredNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Tugas Mahasiswa'),
        actions: [
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: DropdownButton<String>(
              value: _selectedCategory,
              icon: const Icon(Icons.filter_list),
              underline: const SizedBox(),
              items: ['Semua', ...NoteCategory.getAll()]
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            if (category != 'Semua')
                              CategoryIcon(category: category, size: 20),
                            if (category != 'Semua') const SizedBox(width: 8),
                            Text(category),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_add_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedCategory == 'Semua'
                        ? 'Belum ada catatan.\nTekan tombol + untuk menambah.'
                        : 'Tidak ada catatan untuk kategori $_selectedCategory',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CategoryIcon(
                      category: note.category,
                      size: 32,
                    ),
                    title: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dateFormat.format(note.createdAt),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                note.category,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () => _editNote(index),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteNote(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNote,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
