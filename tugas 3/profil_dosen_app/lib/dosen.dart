// dosen.dart

class Dosen {
  final String nidn;
  final String nama;
  final String bidangKeahlian;
  final String email;
  final String imageUrl; // URL atau path aset gambar

  Dosen({
    required this.nidn,
    required this.nama,
    required this.bidangKeahlian,
    required this.email,
    required this.imageUrl,
  });
}

// Data dummy untuk ditampilkan
List<Dosen> daftarDosen = [
  Dosen(
    nidn: '0012098001',
    nama: 'Dr. Ahmad Fauzi, M.Kom.',
    bidangKeahlian: 'Jaringan Komputer & Keamanan Siber',
    email: 'ahmad.fauzi@kampus.ac.id',
    imageUrl: 'https://i.pravatar.cc/150?img=6', // Contoh placeholder image
  ),
  Dosen(
    nidn: '0005047802',
    nama: 'Prof. Dr. Siti Aminah, S.T., M.T.',
    bidangKeahlian: 'Kecerdasan Buatan & Machine Learning',
    email: 'siti.aminah@kampus.ac.id',
    imageUrl: 'https://i.pravatar.cc/150?img=35',
  ),
  Dosen(
    nidn: '0021028503',
    nama: 'Budi Santoso, S.Kom., M.Sc.',
    bidangKeahlian: 'Pengembangan Aplikasi Mobile (Flutter)',
    email: 'budi.santoso@kampus.ac.id',
    imageUrl: 'https://i.pravatar.cc/150?img=1',
  ),
];
