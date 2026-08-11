import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'player_data.dart';
import 'user_storage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _playerNameController = TextEditingController();
  final TextEditingController _characterNameController = TextEditingController();
  final TextEditingController _playerIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  File? _profileImage;
  File? _licenseImage;

  Future<void> _pickImage(String type) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          if (type == 'profile') {
            _profileImage = File(image.path);
          } else {
            _licenseImage = File(image.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _register() async {
    if (_playerNameController.text.isEmpty ||
        _characterNameController.text.isEmpty ||
        _playerIdController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى ملء جميع الحقول'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final player = PlayerData(
        playerName: _playerNameController.text.trim(),
        characterName: _characterNameController.text.trim(),
        playerId: _playerIdController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        registered: true,
        profileImagePath: _profileImage?.path,
        licenseImagePath: _licenseImage?.path,
      );

      await UserStorage.save(player);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم التسجيل بنجاح!'),
          backgroundColor: Color(0xFFFFC83D),
        ),
      );

      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'تسجيل جديد',
          style: TextStyle(color: Color(0xFFFFC83D)),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // صورة الملف الشخصي
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFFFFC83D),
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(Icons.person, size: 50, color: Colors.black)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _pickImage('profile'),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFC83D),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  'صورة الملف الشخصي',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),

              // اسم اللاعب
              TextField(
                controller: _playerNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'اسم اللاعب',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.person, color: Color(0xFFFFC83D)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFC83D)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // اسم الشخصية
              TextField(
                controller: _characterNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'اسم الشخصية',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.auto_awesome, color: Color(0xFFFFC83D)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFC83D)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // رقم اللاعب
              TextField(
                controller: _playerIdController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'رقم اللاعب',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.numbers, color: Color(0xFFFFC83D)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFC83D)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // البريد الإلكتروني
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.email, color: Color(0xFFFFC83D)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFC83D)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // كلمة المرور
              TextField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFFFFC83D)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFC83D)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // زر تسجيل
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC83D),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          'تسجيل',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}