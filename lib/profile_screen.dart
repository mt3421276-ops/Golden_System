import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_storage.dart';
import 'app_language.dart';
import 'admin_service.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String playerName;
  final String characterName;
  final String playerId;
  final File? profileImage;
  final File? licenseImage;
  final AppLanguage currentLanguage;
  final Function(AppLanguage) onLanguageChanged;

  const ProfileScreen({
    super.key,
    required this.playerName,
    required this.characterName,
    required this.playerId,
    this.profileImage,
    this.licenseImage,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  File? _licenseImage;
  bool _isEditing = false;
  bool _isVerifiedAdmin = false;

  @override
  void initState() {
    super.initState();
    _profileImage = widget.profileImage;
    _licenseImage = widget.licenseImage;
    _loadAdminBadge();
  }

  Future<void> _loadAdminBadge() async {
    final value = await AdminService.isVerifiedAdmin();
    if (mounted) {
      setState(() {
        _isVerifiedAdmin = value;
      });
    }
  }

  Future<void> _pickImage(String type) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final File file = File(image.path);
        setState(() {
          if (type == 'profile') {
            _profileImage = file;
          } else {
            _licenseImage = file;
          }
        });

        final prefs = await SharedPreferences.getInstance();
        if (type == 'profile') {
          await prefs.setString('profileImagePath', image.path);
        } else {
          await prefs.setString('licenseImagePath', image.path);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث الصورة بنجاح'),
            backgroundColor: Color(0xFFFFC83D),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getLanguageText(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.arabic:
        return 'العربية';
      case AppLanguage.french:
        return 'Français';
      case AppLanguage.english:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الملف الشخصي',
                style: TextStyle(
                  color: Color(0xFFFFC83D),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 20),
              
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color(0xFFFFC83D),
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.black,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _pickImage('profile'),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFC83D),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              
              Center(
                child: Text(
                  'اضغط على الكاميرا لتغيير الصورة',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      'اسم اللاعب',
                      widget.playerName,
                    ),
                  ),
                  if (_isVerifiedAdmin)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.verified_rounded,
                        color: Color(0xFFFFC83D),
                        size: 25,
                      ),
                    ),
                ],
              ),
              _buildInfoItem('اسم الشخصية', widget.characterName),
              _buildInfoItem('رقم اللاعب', widget.playerId),
              
              const SizedBox(height: 20),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFFC83D).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'رخصة اللاعب',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: _licenseImage != null
                          ? Image.file(
                              _licenseImage!,
                              height: 150,
                              fit: BoxFit.contain,
                            )
                          : Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'لا توجد رخصة',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage('license'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC83D),
                          foregroundColor: Colors.black,
                        ),
                        icon: const Icon(Icons.upload_file),
                        label: const Text('تحميل الرخصة'),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFFC83D).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'اللغة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLanguageButton(AppLanguage.arabic, 'عربي'),
                        _buildLanguageButton(AppLanguage.english, 'EN'),
                        _buildLanguageButton(AppLanguage.french, 'FR'),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingsScreen(
                          currentLanguage: widget.currentLanguage,
                          onLanguageChanged: widget.onLanguageChanged,
                        ),
                      ),
                    );
                    await _loadAdminBadge();
                    if (mounted) setState(() {});
                  },
                  icon: const Icon(Icons.settings_rounded),
                  label: const Text('الإعدادات'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFFC83D),
                    side: const BorderSide(color: Color(0xFFFFC83D)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF1A1A1A),
                        title: const Text(
                          'تسجيل الخروج',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                          style: TextStyle(color: Colors.grey),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'إلغاء',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await UserStorage.clear();
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            child: const Text(
                              'تسجيل الخروج',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFC83D).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(AppLanguage lang, String label) {
    final isSelected = widget.currentLanguage == lang;
    return GestureDetector(
      onTap: () {
        widget.onLanguageChanged(lang);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFC83D) : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}