import 'package:flutter/material.dart';
import 'mahasiswa_form.dart';
import 'mahasiswa_item.dart';
import '../model/mahasiswa.dart';

class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({Key? key}) : super(key: key);

  @override
  State<MahasiswaPage> createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Mahasiswa"),
        actions: [
          GestureDetector(
            // menampilkan icon +
            child: const Icon(Icons.add),
            // pada saat icon + di tap
            onTap: () async {
              // berpindah ke halaman MahasiswaForm
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MahasiswaForm()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          MahasiswaItem(
            mahasiswa: Mahasiswa(
              nim: "12200655",
              nama: "Ade Rahul",
              alamat: "Jln Perdamaian No 13, Pontianak",
            ),
          ),
          MahasiswaItem(
            mahasiswa: Mahasiswa(
              nim: "12200910",
              nama: "Mimi Mariani",
              alamat: "Jln Adisucipto Komp Teluk Mulus Blok A1, Pontianak",
            ),
          ),
          MahasiswaItem(
            mahasiswa: Mahasiswa(
              nim: "12200682",
              nama: "Refaldo ismail",
              alamat: "Jln Sungai Raya Dalam Komp Batara Blok A10, Pontianak",
            ),
          ),
          MahasiswaItem(
            mahasiswa: Mahasiswa(
              nim: "12200651",
              nama: "Fitri Indriyani",
              alamat: "Jln Pangeran Nata Kusuma No 126, Pontianak",
            ),
          ),
        ],
      ),
    );
  }
}
