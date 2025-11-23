class Mahasiswa {
  final String nama;
  final String email;
  final String nomorHP;
  final String jurusan;
  final int semester;
  final List<String> hobi;
  final bool persetujuan;

  Mahasiswa({
    required this.nama,
    required this.email,
    required this.nomorHP,
    required this.jurusan,
    required this.semester,
    required this.hobi,
    required this.persetujuan,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'email': email,
      'nomorHP': nomorHP,
      'jurusan': jurusan,
      'semester': semester,
      'hobi': hobi,
      'persetujuan': persetujuan,
    };
  }
}
