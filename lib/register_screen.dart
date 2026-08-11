import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'player_data.dart';
import 'user_storage.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onRegistered;
  const RegisterScreen({super.key, this.onRegistered});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _playerNameController = TextEditingController();
  final TextEditingController _characterNameController = TextEditingController();
  final TextEditingController _playerIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  File? _profileImage;
  File? _licenseImage;

  @override
  void dispose() {
    _playerNameController.dispose();
    _characterNameController.dispose();
    _playerIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image == null || !mounted) return;

      setState(() {
        if (type == 'profile') {
          _profileImage = File(image.path);
        } else {
          _licenseImage = File(image.path);
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر اختيار الصورة: $e')),
      );
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _isLoading = true);

    try {
      final player = PlayerData(
        playerName: _playerNameController.text.trim(),
        characterName: _characterNameController.text.trim(),
        playerId: _playerIdController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        registered: true,
        profileImagePath: _profileImage?.path,
        licenseImagePath: _licenseImage?.path,
      );

      await UserStorage.save(player);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم التسجيل بنجاح!'),
          backgroundColor: Color(0xFFFFC83D),
        ),
      );

      // The original code used pushReplacementNamed('/') although no '/'
      // route was declared. Returning to the app root by rebuilding it avoids
      // the unknown-route error.
      widget.onRegistered?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء التسجيل: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(icon, color: const Color(0xFFFFC83D)),
      filled: true,
      fillColor: const Color(0xFF0B0B0B),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade800),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFC83D)),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  String? _required(String? value, String name) {
    if (value == null || value.trim().isEmpty) return 'يرجى إدخال $name';
    return null;
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 54,
                        backgroundColor: const Color(0xFFFFC83D),
                        backgroundImage:
                            _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? const Icon(Icons.person, size: 54, color: Colors.black)
                            : null,
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Material(
                          color: const Color(0xFFFFC83D),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => _pickImage('profile'),
                            child: const Padding(
                              padding: EdgeInsets.all(9),
                              child: Icon(Icons.camera_alt, size: 20, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'صورة الملف الشخصي اختيارية',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                const SizedBox(height: 25),

                TextFormField(
                  controller: _playerNameController,
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.next,
                  validator: (v) => _required(v, 'اسم اللاعب'),
                  decoration: _decoration('اسم اللاعب', Icons.person),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _characterNameController,
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.next,
                  validator: (v) => _required(v, 'اسم الشخصية'),
                  decoration: _decoration('اسم الشخصية', Icons.auto_awesome),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _playerIdController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (v) => _required(v, 'رقم اللاعب'),
                  decoration: _decoration('رقم اللاعب', Icons.numbers),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    final error = _required(v, 'البريد الإلكتروني');
                    if (error != null) return error;
                    if (!v!.contains('@')) return 'البريد الإلكتروني غير صحيح';
                    return null;
                  },
                  decoration: _decoration('البريد الإلكتروني', Icons.email),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    final error = _required(v, 'كلمة المرور');
                    if (error != null) return error;
                    if (v!.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    if (!_isLoading) _register();
                  },
                  decoration: _decoration('كلمة المرور', Icons.lock).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC83D),
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey.shade800,
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
      ),
    );
  }
}

