// main.dart

import 'package:flutter/material.dart';
import 'dosen.dart'; // Import model Dosen

void main() {
  runApp(const ProfilDosenApp());
}

class ProfilDosenApp extends StatelessWidget {
  const ProfilDosenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Dosen App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const DaftarDosenPage(), // Halaman 1
    );
  }
}

// ====================================================================
// HALAMAN 1: DAFTAR DOSEN (ListView + Card)
// ====================================================================

class DaftarDosenPage extends StatelessWidget {
  const DaftarDosenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Dosen 🧑‍🏫'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: daftarDosen.length,
        itemBuilder: (context, index) {
          final dosen = daftarDosen[index];
          return DosenCard(dosen: dosen);
        },
      ),
    );
  }
}

class DosenCard extends StatelessWidget {
  final Dosen dosen;
  const DosenCard({required this.dosen, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          // Menggunakan Navigator untuk pindah ke Halaman 2
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailDosenPage(dosen: dosen),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              // Avatar Dosen
              CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(dosen.imageUrl),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 15),
              // Informasi Singkat
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      dosen.nama,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dosen.bidangKeahlian,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// HALAMAN 2: DETAIL DOSEN
// ====================================================================

class DetailDosenPage extends StatelessWidget {
  final Dosen dosen;
  const DetailDosenPage({required this.dosen, super.key});

  @override
  Widget build(BuildContext context) {
    // Media Query untuk responsif
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(dosen.nama),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Bagian Header/Gambar
            Container(
              height: 250, // Ukuran responsif
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Center(
                child: Hero(
                  tag:
                      'dosen-avatar-${dosen.nidn}', // Tag unik untuk animasi Hero
                  child: CircleAvatar(
                    radius: screenWidth * 0.25, // Radius responsif
                    backgroundImage: NetworkImage(dosen.imageUrl),
                    backgroundColor: Colors.indigo,
                  ),
                ),
              ),
            ),

            // Bagian Detail Informasi
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    dosen.nama,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 8),

                  DetailItem(
                    icon: Icons.badge,
                    title: 'NIDN',
                    subtitle: dosen.nidn,
                  ),
                  const Divider(),

                  DetailItem(
                    icon: Icons.lightbulb_outline,
                    title: 'Bidang Keahlian',
                    subtitle: dosen.bidangKeahlian,
                  ),
                  const Divider(),

                  DetailItem(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: dosen.email,
                  ),
                  const Divider(),

                  const SizedBox(height: 20),
                  const Text(
                    'Riwayat Singkat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 8),
                  Text(
                    // Panggil fungsi untuk mendapatkan bio yang sesuai
                    getRiwayatSingkat(dosen),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget bantu untuk Detail Informasi
class DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const DetailItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 24, color: Colors.indigo[400]),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
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

// main.dart (di luar class)

String getRiwayatSingkat(Dosen dosen) {
  switch (dosen.nidn) {
    case '0012098001':
      return 'Dr. Ahmad Fauzi adalah pakar di bidang Jaringan Komputer dan Keamanan Siber dengan pengalaman lebih dari 15 tahun di dunia akademis. Beliau memperoleh gelar Doktor dari Universitas Gadjah Mada (UGM). Fokus penelitiannya mencakup Intrusion Detection Systems (IDS) dan optimasi jaringan nirkabel. Beliau aktif dalam berbagai proyek konsultasi keamanan siber.';
    case '0005047802':
      return 'Prof. Dr. Siti Aminah merupakan salah satu profesor terkemuka di Indonesia dalam bidang Kecerdasan Buatan (AI) dan Machine Learning. Beliau memimpin berbagai hibah penelitian dan telah mempublikasikan lebih dari 50 jurnal internasional, dengan fokus utama pada pemrosesan bahasa alami (NLP) dan visi komputer.';
    case '0021028503':
      return 'Budi Santoso, M.Sc. adalah dosen muda yang bersemangat dalam dunia pengembangan aplikasi modern, khususnya pada platform mobile menggunakan Flutter. Beliau mendapatkan gelar Master dari University of Manchester, Inggris. Fokus pengajarannya adalah memastikan mahasiswa memiliki keterampilan praktis yang siap kerja.';
    default:
      return 'Riwayat singkat dosen ini belum tersedia.';
  }
}
