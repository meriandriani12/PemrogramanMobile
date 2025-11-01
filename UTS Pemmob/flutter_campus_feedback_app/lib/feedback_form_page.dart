// feedback_form_page.dart
// Halaman Form Feedback - Halaman 2

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'model/feedback_item.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({Key? key}) : super(key: key);

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _pesanController = TextEditingController();

  String? _fakultasSelected;
  final List<String> _fakultasList = [
    'Fakultas Syariah',
    'Fakultas Tarbiyah dan Keguruan',
    'Fakultas Ushuluddin dan Studi Agama',
    'Fakultas Adab dan Humaniora',
    'Fakultas Ekonomi dan Bisnis Islam',
    'Fakultas Dakwah',
    'Fakultas Sains dan Teknologi',
  ];

  final Map<String, bool> _fasilitas = {
    'Perpustakaan': false,
    'Laboratorium': false,
    'Masjid': false,
    'Kantin': false,
    'Wifi': false,
    'Ruang Kelas': false,
  };

  double _nilaiKepuasan = 3.0;

  String _jenisFeedback = 'Saran';

  bool _setujuSyarat = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Cek apakah switch sudah diaktifkan
      if (!_setujuSyarat) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Perhatian'),
            content: const Text(
              'Anda harus menyetujui syarat dan ketentuan sebelum menyimpan feedback.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // Cek apakah ada fasilitas yang dipilih
      final fasilitasDipilih = _fasilitas.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

      if (fasilitasDipilih.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih minimal satu fasilitas yang dinilai'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Buat objek FeedbackItem
      final feedbackItem = FeedbackItem(
        namaMahasiswa: _namaController.text,
        nim: _nimController.text,
        fakultas: _fakultasSelected!,
        fasilitasDinilai: fasilitasDipilih,
        nilaiKepuasan: _nilaiKepuasan,
        jenisFeedback: _jenisFeedback,
        setujuSyarat: _setujuSyarat,
        pesanTambahan: _pesanController.text.isEmpty
            ? null
            : _pesanController.text,
      );

      // Kembali ke halaman sebelumnya dengan membawa data
      Navigator.pop(context, feedbackItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulir Feedback'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Header
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Formulir Feedback Mahasiswa',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Silakan isi formulir di bawah ini',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Nama Mahasiswa
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Mahasiswa',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama mahasiswa wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // NIM
            TextFormField(
              controller: _nimController,
              decoration: const InputDecoration(
                labelText: 'NIM',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
                helperText: 'Masukkan NIM dengan angka',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIM wajib diisi';
                }
                if (value.length < 6) {
                  return 'NIM minimal 6 digit';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Fakultas Dropdown
            DropdownButtonFormField<String>(
              value: _fakultasSelected,
              decoration: const InputDecoration(
                labelText: 'Fakultas',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
              items: _fakultasList.map((String fakultas) {
                return DropdownMenuItem<String>(
                  value: fakultas,
                  child: Text(fakultas),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _fakultasSelected = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Pilih fakultas Anda';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Fasilitas yang Dinilai
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Fasilitas yang Dinilai',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ..._fasilitas.keys.map((String key) {
                      return CheckboxListTile(
                        title: Text(key),
                        value: _fasilitas[key],
                        onChanged: (bool? value) {
                          setState(() {
                            _fasilitas[key] = value ?? false;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Nilai Kepuasan Slider
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nilai Kepuasan: ${_nilaiKepuasan.toInt()}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _nilaiKepuasan,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _nilaiKepuasan.toInt().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _nilaiKepuasan = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '1 - Sangat Tidak Puas',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '5 - Sangat Puas',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Jenis Feedback Radio
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Jenis Feedback',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    RadioListTile<String>(
                      title: const Text('Saran'),
                      value: 'Saran',
                      groupValue: _jenisFeedback,
                      onChanged: (String? value) {
                        setState(() {
                          _jenisFeedback = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Keluhan'),
                      value: 'Keluhan',
                      groupValue: _jenisFeedback,
                      onChanged: (String? value) {
                        setState(() {
                          _jenisFeedback = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Apresiasi'),
                      value: 'Apresiasi',
                      groupValue: _jenisFeedback,
                      onChanged: (String? value) {
                        setState(() {
                          _jenisFeedback = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Pesan Tambahan (Optional)
            TextFormField(
              controller: _pesanController,
              decoration: const InputDecoration(
                labelText: 'Pesan Tambahan (Opsional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.message),
                helperText: 'Tambahkan komentar atau saran detail',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Switch Setuju Syarat & Ketentuan
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: SwitchListTile(
                title: const Text('Setuju dengan Syarat & Ketentuan'),
                subtitle: const Text('Harus diaktifkan sebelum menyimpan'),
                value: _setujuSyarat,
                onChanged: (bool value) {
                  setState(() {
                    _setujuSyarat = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Simpan
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Simpan Feedback',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
