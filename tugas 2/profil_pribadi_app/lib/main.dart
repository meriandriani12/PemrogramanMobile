import 'package:flutter/material.dart';

// Fungsi utama yang menjalankan aplikasi
void main() {
  runApp(const ProfilPribadiApp());
}

// StatelessWidget utama untuk aplikasi
class ProfilPribadiApp extends StatelessWidget {
  const ProfilPribadiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Pribadi',
      theme: ThemeData(
        // Menggunakan skema warna yang menarik
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProfileScreen(),
    );
  }
}

// Widget utama yang menampilkan profil
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Data Profil
  final String namaLengkap = "Meri Andriani";
  final String deskripsiDiri =
      "Seorang pengembang aplikasi mobile yang bersemangat, berfokus pada pengembangan solusi yang efisien dan elegan menggunakan Flutter. Berpengalaman dalam UI/UX dan integrasi REST API.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pribadi App'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.indigo[50], // Latar belakang yang lembut
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // 1. Foto Profil (CircleAvatar)
            const CircleAvatar(
              radius: 70,
              backgroundColor: Colors.indigo,
              // Menggunakan ikon sebagai placeholder, ganti dengan Image.network atau Image.asset
              child: Icon(Icons.account_circle, size: 120, color: Colors.white),
            ),

            const SizedBox(height: 25),

            // Garis pembatas visual
            const Divider(color: Colors.indigo, thickness: 1.5),

            const SizedBox(height: 25),

            // 2. Nama Lengkap (Text)
            Text(
              namaLengkap,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
                fontFamily: 'Roboto',
              ),
            ),

            const SizedBox(height: 15),

            // 3. Deskripsi Singkat Diri (Text)
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  deskripsiDiri,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 4. Tombol dengan Aksi (ElevatedButton)
            ElevatedButton.icon(
              onPressed: () {
                // Aksi: Menampilkan SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Aksi telah dijalankan! Profil tersimpan.'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
                // Aksi Tambahan: Menampilkan pesan di konsol
                print('Tombol "Lihat Aksi" telah ditekan oleh $namaLengkap');
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Lihat Aksi', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Warna tombol yang berbeda
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
