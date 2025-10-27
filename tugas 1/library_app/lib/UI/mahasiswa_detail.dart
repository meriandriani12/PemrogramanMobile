import 'package:flutter/material.dart';
import '../model/mahasiswa.dart';

class MahasiswaDetail extends StatefulWidget {
  final Mahasiswa? mahasiswa;

  const MahasiswaDetail({Key? key, this.mahasiswa}) : super(key: key);

  @override
  State<MahasiswaDetail> createState() => _MahasiswaDetailState();
}

class _MahasiswaDetailState extends State<MahasiswaDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mahasiswa")),
      body: Column(
        children: [
          Text("NIM : " + widget.mahasiswa!.nim.toString()),
          Text("Nama : ${widget.mahasiswa!.nama}"),
          Text("Alamat : ${widget.mahasiswa!.alamat}"),
          _tombolEditHapus(),
        ],
      ),
    );
  }

  Widget _tombolEditHapus() {
    return Row(
      // <-- Tambahkan return dan buka Row
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // 1. Tombol Ubah
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ), // Gunakan backgroundColor
          child: const Text("Ubah"),
        ),

        // 2. SizedBox untuk jarak
        const SizedBox(width: 10.0),

        // 3. Tombol Hapus
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ), // Gunakan backgroundColor
          child: const Text("Hapus"),
        ),
      ],
    ); // <-- Penutup Row dan return statement
  }
}
