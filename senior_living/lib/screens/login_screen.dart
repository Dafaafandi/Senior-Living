import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/home_page.dart';
import '../models/user_model.dart'; // Add User model import

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final result = await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        if (result != null && result['success'] == true) {
          final user = User.fromJson(result['user'] as Map<String, dynamic>);
          final userAge = user.age;
          print("DEBUG: Parsed User Age in LoginScreen: $userAge");
          print("DEBUG: Full User Data: ${user.toJson()}");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Login berhasil!')),
          );

          Navigator.pushReplacementNamed(
            context,
            '/home',
            arguments: {
              'name': user.name,
              'age': userAge,
              'birth_date': user.birthDate,
              'patient_id': user.patientId,
              'status': 'Normal',
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result?['message'] ?? 'Login gagal.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Log in",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "example@gmail.com",
                      border: OutlineInputBorder(),
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
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "minimal 8 karakter",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong!";
                      }
                      if (value.length < 8) {
                        // Sesuaikan dengan backend (min:8)
                        return "Password minimal 8 karakter!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Warna tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/create-account');
                      },
                      child: const Text("Belum punya akun? Buat Akun"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
