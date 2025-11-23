import 'package:flutter/material.dart';
import '../models/mahasiswa.dart';

class ResultPage extends StatelessWidget {
  final Mahasiswa mahasiswa;

  const ResultPage({super.key, required this.mahasiswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Registrasi'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Icon
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Success Message
            const Center(
              child: Text(
                'Registrasi Berhasil!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Data Anda telah berhasil disimpan',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),

            // Data Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan Data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 24),

                    // Data Pribadi Section
                    _buildSectionTitle('Data Pribadi'),
                    _buildDataRow(Icons.person, 'Nama', mahasiswa.nama),
                    _buildDataRow(Icons.email, 'Email', mahasiswa.email),
                    _buildDataRow(Icons.phone, 'Nomor HP', mahasiswa.nomorHP),
                    const SizedBox(height: 16),

                    // Data Akademik Section
                    _buildSectionTitle('Data Akademik'),
                    _buildDataRow(Icons.school, 'Jurusan', mahasiswa.jurusan),
                    _buildDataRow(
                      Icons.calendar_today,
                      'Semester',
                      'Semester ${mahasiswa.semester}',
                    ),
                    const SizedBox(height: 16),

                    // Hobi Section
                    _buildSectionTitle('Hobi'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: mahasiswa.hobi.map((hobi) {
                        return Chip(
                          label: Text(hobi),
                          backgroundColor: Colors.blue.shade50,
                          avatar: const Icon(Icons.favorite, size: 16),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Status
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Menyetujui syarat dan ketentuan',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali ke Form'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Fungsi untuk mengirim data atau navigasi ke home
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data berhasil dikirim!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.send),
                label: const Text('Kirim Data'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildDataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
