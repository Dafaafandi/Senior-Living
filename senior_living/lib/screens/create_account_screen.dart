import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Pastikan path ini benar

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController(); // Username masih ada di UI, tapi API Laravel butuh 'name'
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isChecked = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  void _handleCreateAccount() async {
    if (_formKey.currentState!.validate()) {
      if (!_isChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anda harus menyetujui syarat dan kebijakan privasi.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // API Laravel mengharapkan 'name', bukan 'username'. Sesuaikan jika perlu.
      // Jika 'username' terpisah, tambahkan field tersebut di API dan model User Laravel.
      // Untuk saat ini, kita akan menggunakan _nameController untuk field 'name' di API.
      final result = await _apiService.register(
        name: _nameController.text, // Menggunakan _nameController untuk 'name'
        email: _emailController.text,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
         if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Akun berhasil dibuat!')),
          );
          // Jika registrasi berhasil dan API mengembalikan token (otomatis login)
          if (result.containsKey('user')) {
            final userData = result['user'] as Map<String, dynamic>;
            final userName = userData['name'] as String?;
            Navigator.pushNamedAndRemoveUntil(context, '/home_page', (route) => false,
              arguments: {
                'name': userName ?? 'Pengguna',
              }
            );
          } else {
            // Jika tidak otomatis login, arahkan ke halaman login atau sukses
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Gagal membuat akun.')),
          );
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _isLoading ? null : () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  "Buat Akun",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text("Nama Lengkap"),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Nama Lengkap Anda",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nama tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                const Text("Email"),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "example@gmail.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email tidak boleh kosong!";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Masukkan email yang valid!";
                    }
                    return null;
                  },
                ),
                // Username field (jika masih diperlukan di UI, tapi API Laravel butuh 'name')
                // Jika Anda ingin 'username' terpisah, pastikan backend mendukungnya.
                // Untuk saat ini, saya akan menyembunyikannya karena API Laravel menggunakan 'name'.
                // const SizedBox(height: 15),
                // const Text("Username"),
                // TextFormField(
                //   controller: _usernameController,
                //   decoration: InputDecoration(
                //     hintText: "Username Anda",
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Username tidak boleh kosong!";
                //     }
                //     return null;
                //   },
                // ),
                const SizedBox(height: 15),
                const Text("Buat Password"),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "minimal 8 karakter",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password tidak boleh kosong!";
                    }
                    if (value.length < 8) {
                      return "Password minimal 8 karakter!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                const Text("Konfirmasi Password"),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "ulangi password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Konfirmasi password tidak boleh kosong!";
                    }
                    if (value != _passwordController.text) {
                      return "Password tidak cocok!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text("Saya menerima syarat dan kebijakan privasi"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isLoading ? null : _handleCreateAccount,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Buat Akun",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sudah punya akun? ",
                      style: TextStyle(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: _isLoading ? null : () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}