import 'package:flutter/material.dart';
import '../model/mahasiswa.dart';
import 'mahasiswa_detail.dart';

class MahasiswaItem extends StatelessWidget {
  final Mahasiswa? mahasiswa;

  const MahasiswaItem({Key? key, this.mahasiswa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(mahasiswa!.nama.toString()),
          subtitle: Text(mahasiswa!.nim.toString()),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MahasiswaDetail(mahasiswa: mahasiswa),
          ),
        );
      },
    );
  }
}
