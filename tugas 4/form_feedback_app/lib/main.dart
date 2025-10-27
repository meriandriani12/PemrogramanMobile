import 'package:flutter/material.dart';

// Model untuk menyimpan data feedback
class FeedbackData {
  String name;
  String comment;
  int rating;

  FeedbackData({
    required this.name,
    required this.comment,
    required this.rating,
  });
}

void main() {
  runApp(const FeedbackApp());
}

// =========================================================================
// FeedbackApp - Mendefinisikan rute dan tema
// =========================================================================

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback App',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Kita tetap menggunakan Halaman 1 sebagai initialRoute.
      // Kita akan membuat Halaman 3 (AllFeedbackScreen)
      initialRoute: '/',
      routes: {
        '/': (context) => const FeedbackFormScreen(),
        '/result': (context) => const FeedbackResultScreen(),
        '/all_feedback': (context) => const AllFeedbackScreen(), // Rute baru
      },
    );
  }
}

// =========================================================================
// Halaman 1: Formulir Feedback (StatefulWidget)
// =========================================================================

class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  // **STATE BARU** - Daftar untuk menyimpan semua feedback yang telah disubmit
  static List<FeedbackData> allFeedbackList = [];

  // Controller untuk menangkap input dari TextField
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  // Variabel state untuk rating
  int _currentRating = 3;

  // Fungsi yang dipanggil saat tombol submit ditekan
  void _submitFeedback() {
    final feedback = FeedbackData(
      name: _nameController.text.isEmpty ? 'Anonim' : _nameController.text,
      comment: _commentController.text,
      rating: _currentRating,
    );

    // **MODIFIKASI PENTING:** Tambahkan feedback ke list statis
    setState(() {
      allFeedbackList.add(feedback);
      // Bersihkan input setelah submit
      _nameController.clear();
      _commentController.clear();
      _currentRating = 3;
    });

    // Pindah ke Halaman 2 (Hasil Feedback)
    Navigator.pushNamed(context, '/result', arguments: feedback);
  }

  // Widget untuk menampilkan bintang rating
  Widget _buildRatingBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final ratingValue = index + 1;
        return IconButton(
          icon: Icon(
            ratingValue <= _currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32,
          ),
          onPressed: () {
            setState(() {
              _currentRating = ratingValue;
            });
          },
        );
      }),
    );
  }

  // Fungsi untuk berpindah ke halaman daftar semua feedback
  void _goToAllFeedback() {
    Navigator.pushNamed(context, '/all_feedback');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Feedback'),
        backgroundColor: Colors.blueAccent,
        // **ACTION BARU** - Tombol untuk melihat semua feedback
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt, color: Colors.white),
            onPressed: _goToAllFeedback,
            tooltip: 'Lihat Semua Feedback',
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // ... (Kode input TextField dan Rating Bar sama seperti sebelumnya) ...
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama (Opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Komentar Anda',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Rating Anda (1-5):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            _buildRatingBar(),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Kirim Feedback',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// Halaman 2: Hasil Feedback (Tidak ada perubahan signifikan)
// =========================================================================

class FeedbackResultScreen extends StatelessWidget {
  const FeedbackResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final feedback = ModalRoute.of(context)!.settings.arguments as FeedbackData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Feedback'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Terima Kasih atas Feedback Anda!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const Divider(height: 30),

            _buildResultRow('Nama:', feedback.name),
            const SizedBox(height: 15),

            _buildResultRating(feedback.rating),
            const SizedBox(height: 25),

            const Text(
              'Komentar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade50,
              ),
              child: Text(
                feedback.comment,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
              ),
              child: const Text('Kembali ke Formulir'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 18))),
      ],
    );
  }

  Widget _buildResultRating(int rating) {
    return Row(
      children: [
        const Text(
          'Rating:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        ...List.generate(5, (index) {
          return Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 24,
          );
        }),
      ],
    );
  }
}

// =========================================================================
// Halaman 3: Menampilkan Semua Feedback
// =========================================================================

class AllFeedbackScreen extends StatelessWidget {
  const AllFeedbackScreen({super.key});

  // Helper untuk menampilkan rating bintang
  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        );
      }),
    );
  }

  // Helper untuk membuat card feedback
  Widget _buildFeedbackCard(FeedbackData feedback) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  feedback.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildRatingStars(feedback.rating),
              ],
            ),
            const Divider(),
            Text(feedback.comment, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data dari list statis yang ada di state Halaman 1
    final feedbackList = _FeedbackFormScreenState.allFeedbackList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Semua Feedback'),
        backgroundColor: Colors.indigo,
      ),
      body: feedbackList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada feedback yang disubmit.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              // Menampilkan item feedback dari yang terbaru (index terakhir)
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                // Ambil feedback dari index terakhir (yang terbaru)
                final feedback = feedbackList[feedbackList.length - 1 - index];
                return _buildFeedbackCard(feedback);
              },
            ),
    );
  }
}
