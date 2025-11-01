// home_page.dart
// Halaman Beranda - Halaman 1

import 'package:flutter/material.dart';
import 'feedback_form_page.dart';
import 'feedback_list_page.dart';
import 'about_page.dart';
import 'model/feedback_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FeedbackItem> feedbackList = [];

  void _addFeedback(FeedbackItem feedback) {
    setState(() {
      feedbackList.add(feedback);
    });
  }

  void _deleteFeedback(int index) {
    setState(() {
      feedbackList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Flutter
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.flutter_dash,
                      size: 80,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Nama Aplikasi
                  Text(
                    'Flutter Campus Feedback',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Kuesioner Kepuasan Mahasiswa',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),

                  // Tombol Formulir Feedback
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedbackFormPage(),
                          ),
                        );
                        if (result != null && result is FeedbackItem) {
                          _addFeedback(result);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Feedback berhasil disimpan!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.edit_note),
                      label: const Text('Formulir Feedback Mahasiswa'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tombol Daftar Feedback
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: feedbackList.isEmpty
                          ? null
                          : () async {
                              final deletedIndex = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FeedbackListPage(
                                    feedbackList: feedbackList,
                                  ),
                                ),
                              );
                              if (deletedIndex != null && deletedIndex is int) {
                                _deleteFeedback(deletedIndex);
                              }
                            },
                      icon: const Icon(Icons.list_alt),
                      label: Text('Daftar Feedback (${feedbackList.length})'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tombol Profil Aplikasi
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Tentang Aplikasi'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Teks Motivasi
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.format_quote, color: Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'UNIVERSITAS ISLAM NEGERI SULTHAN THAHA SAIFUDDIN JAMBI',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Icon(Icons.format_quote, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
