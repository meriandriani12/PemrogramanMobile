// feedback_list_page.dart
// Halaman Daftar Feedback - Halaman 3

import 'package:flutter/material.dart';
import 'model/feedback_item.dart';
import 'feedback_detail_page.dart';

class FeedbackListPage extends StatelessWidget {
  final List<FeedbackItem> feedbackList;

  const FeedbackListPage({super.key, required this.feedbackList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Feedback'), centerTitle: true),
      body: feedbackList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 100, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada feedback',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                final feedback = feedbackList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: feedback.getColor(),
                      radius: 28,
                      child: Text(
                        feedback.getIconEmoji(),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    title: Text(
                      feedback.namaMahasiswa,
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
                          feedback.fakultas,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: feedback.getColor().withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                feedback.jenisFeedback,
                                style: TextStyle(
                                  color: feedback.getColor(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              feedback.nilaiKepuasan.toInt().toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedbackDetailPage(
                            feedback: feedback,
                            feedbackIndex: index,
                          ),
                        ),
                      );

                      // Jika hasil adalah index yang dihapus, kembalikan ke HomePage
                      if (result != null && result is int) {
                        if (context.mounted) {
                          Navigator.pop(context, result);
                        }
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
