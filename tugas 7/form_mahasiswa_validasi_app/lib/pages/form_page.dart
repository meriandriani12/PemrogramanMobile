import 'package:flutter/material.dart';
import '../models/mahasiswa.dart';
import 'result_page.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // Form Keys untuk setiap step
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  // Controllers
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final nomorHPController = TextEditingController();

  // State variables
  int _currentStep = 0;
  String? selectedJurusan;
  int semester = 1;
  bool persetujuan = false;

  // Hobi checkboxes
  Map<String, bool> hobi = {
    'Membaca': false,
    'Olahraga': false,
    'Musik': false,
    'Gaming': false,
    'Traveling': false,
  };

  // Daftar jurusan
  final List<String> jurusanList = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Elektro',
    'Teknik Mesin',
    'Manajemen',
    'Akuntansi',
  ];

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    nomorHPController.dispose();
    super.dispose();
  }

  // Validasi untuk step 1 (Data Pribadi)
  bool _validateStep1() {
    return _formKey1.currentState!.validate();
  }

  // Validasi untuk step 2 (Data Akademik)
  bool _validateStep2() {
    if (!_formKey2.currentState!.validate()) {
      return false;
    }

    if (selectedJurusan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih jurusan'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  // Validasi untuk step 3 (Preferensi)
  bool _validateStep3() {
    List<String> selectedHobi = hobi.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedHobi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu hobi'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (!persetujuan) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui syarat dan ketentuan'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  // Submit form
  void _submitForm() {
    if (_validateStep3()) {
      List<String> selectedHobi = hobi.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      Mahasiswa mahasiswa = Mahasiswa(
        nama: namaController.text,
        email: emailController.text,
        nomorHP: nomorHPController.text,
        jurusan: selectedJurusan!,
        semester: semester,
        hobi: selectedHobi,
        persetujuan: persetujuan,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(mahasiswa: mahasiswa),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            if (_validateStep1()) {
              setState(() => _currentStep++);
            }
          } else if (_currentStep == 1) {
            if (_validateStep2()) {
              setState(() => _currentStep++);
            }
          } else if (_currentStep == 2) {
            _submitForm();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        onStepTapped: (step) {
          setState(() => _currentStep = step);
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(_currentStep == 2 ? 'Submit' : 'Lanjut'),
                ),
                const SizedBox(width: 12),
                if (_currentStep > 0)
                  OutlinedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Kembali'),
                  ),
              ],
            ),
          );
        },
        steps: [
          // STEP 1: Data Pribadi
          Step(
            title: const Text('Data Pribadi'),
            subtitle: const Text('Isi data pribadi Anda'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: Form(
              key: _formKey1,
              child: Column(
                children: [
                  TextFormField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama wajib diisi';
                      }
                      if (value.length < 3) {
                        return 'Nama minimal 3 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nomorHPController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor HP',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Contoh: 08123456789',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor HP wajib diisi';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Nomor HP hanya boleh angka';
                      }
                      if (value.length < 10 || value.length > 13) {
                        return 'Nomor HP harus 10-13 digit';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),

          // STEP 2: Data Akademik
          Step(
            title: const Text('Data Akademik'),
            subtitle: const Text('Isi data akademik Anda'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: Form(
              key: _formKey2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jurusan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedJurusan,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                      hintText: 'Pilih Jurusan',
                    ),
                    items: jurusanList.map((String jurusan) {
                      return DropdownMenuItem<String>(
                        value: jurusan,
                        child: Text(jurusan),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedJurusan = value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jurusan wajib dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Semester',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: semester.toDouble(),
                          min: 1,
                          max: 14,
                          divisions: 13,
                          label: 'Semester $semester',
                          onChanged: (value) {
                            setState(() => semester = value.toInt());
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Semester $semester',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // STEP 3: Preferensi
          Step(
            title: const Text('Preferensi'),
            subtitle: const Text('Hobi dan persetujuan'),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            content: Form(
              key: _formKey3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hobi (Pilih minimal 1)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  ...hobi.keys.map((String key) {
                    return CheckboxListTile(
                      title: Text(key),
                      value: hobi[key],
                      onChanged: (bool? value) {
                        setState(() => hobi[key] = value ?? false);
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }).toList(),
                  const Divider(height: 32),
                  SwitchListTile(
                    title: const Text('Saya setuju dengan syarat & ketentuan'),
                    subtitle: const Text(
                      'Dengan ini saya menyatakan data yang diisi adalah benar',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: persetujuan,
                    onChanged: (bool value) {
                      setState(() => persetujuan = value);
                    },
                  ),
                  if (!persetujuan)
                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 8),
                      child: Text(
                        'Anda harus menyetujui syarat dan ketentuan',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
