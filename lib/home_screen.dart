import 'dart:io';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String playerName;
  final String characterName;
  final File? profileImage;

  const HomeScreen({
    super.key,
    required this.playerName,
    required this.characterName,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الترحيب
              const Text(
                'الرئيسية',
                style: TextStyle(
                  color: Color(0xFFFFC83D),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 10),
              
              Text(
                'مرحباً، $playerName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              
              const SizedBox(height: 5),
              
              Text(
                'شخصيتك: $characterName',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 16,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // صورة الملف الشخصي
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFFFFC83D),
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : null,
                  child: profileImage == null
                      ? const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.black,
                        )
                      : null,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // بطاقات معلومات
              _buildInfoCard(
                'اسم اللاعب',
                playerName,
                Icons.person,
              ),
              
              const SizedBox(height: 15),
              
              _buildInfoCard(
                'اسم الشخصية',
                characterName,
                Icons.auto_awesome,
              ),
              
              const SizedBox(height: 30),
              
              // زر للذهاب للملف الشخصي
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // التبديل إلى تبويب الملف الشخصي
                    // سيتم التعامل معه في main.dart
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC83D),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'انتقل إلى الملف الشخصي',
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

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
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
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFFC83D),
            size: 28,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}