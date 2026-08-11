import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_language.dart';
import 'admin_service.dart';
import 'admin_screen.dart';
import 'redemption_screen.dart';

class SettingsScreen extends StatefulWidget {
  final AppLanguage currentLanguage;
  final Function(AppLanguage) onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = true;
  String _selectedTheme = 'ذهبي';
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadAdminStatus();
  }

  Future<void> _loadAdminStatus() async {
    final value = await AdminService.isAdmin();
    if (mounted) setState(() => _isAdmin = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'الإعدادات',
          style: TextStyle(
            color: Color(0xFFFFC83D),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFC83D)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSectionTitle('اللغة'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _buildCardDecoration(),
              child: Column(
                children: [
                  _buildLanguageOption('العربية', AppLanguage.arabic),
                  const Divider(color: Colors.grey),
                  _buildLanguageOption('English', AppLanguage.english),
                  const Divider(color: Colors.grey),
                  _buildLanguageOption('Français', AppLanguage.french),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            _buildSectionTitle('الإشعارات'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _buildCardDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.notifications,
                        color: Color(0xFFFFC83D),
                        size: 28,
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        'تفعيل الإشعارات',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _notifications,
                    onChanged: (value) {
                      setState(() {
                        _notifications = value;
                      });
                    },
                    activeColor: const Color(0xFFFFC83D),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            _buildSectionTitle('المظهر'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _buildCardDecoration(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.dark_mode,
                            color: Color(0xFFFFC83D),
                            size: 28,
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            'الوضع الليلي',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _darkMode,
                        onChanged: (value) {
                          setState(() {
                            _darkMode = value;
                          });
                        },
                        activeColor: const Color(0xFFFFC83D),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.palette,
                            color: Color(0xFFFFC83D),
                            size: 28,
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            'اللون الأساسي',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      DropdownButton<String>(
                        value: _selectedTheme,
                        dropdownColor: Colors.grey.shade900,
                        style: const TextStyle(color: Colors.white),
                        underline: Container(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTheme = value!;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'ذهبي',
                            child: Text('ذهبي'),
                          ),
                          DropdownMenuItem(
                            value: 'أزرق',
                            child: Text('أزرق'),
                          ),
                          DropdownMenuItem(
                            value: 'أخضر',
                            child: Text('أخضر'),
                          ),
                          DropdownMenuItem(
                            value: 'أحمر',
                            child: Text('أحمر'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            _buildSectionTitle('المكافآت والإدارة'),
            _buildActionCard(
              icon: Icons.card_giftcard_rounded,
              title: 'استبدال كود',
              subtitle: 'استبدل أكواد Gold والجواهر',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RedemptionScreen()),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildActionCard(
              icon: Icons.admin_panel_settings_rounded,
              title: 'إدارة Golden System',
              subtitle: _isAdmin ? 'صلاحيات المسؤول مفعلة' : 'إدخال كود المسؤول',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminScreen()),
                );
              },
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('معلومات التطبيق'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _buildCardDecoration(),
              child: Column(
                children: [
                  _buildInfoRow('الإصدار', '5.0.0'),
                  const Divider(color: Colors.grey),
                  _buildInfoRow('المطور', 'Golden Team'),
                  const Divider(color: Colors.grey),
                  _buildInfoRow('الحالة', 'مستقر'),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showDeleteDialog(context);
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
                  'حذف جميع البيانات',
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
    );
  }


  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: _buildCardDecoration(),
        child: Row(
          children: [
            const SizedBox(width: 4),
            Icon(icon, color: const Color(0xFFFFC83D), size: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_left_rounded, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFFFFC83D).withOpacity(0.3),
        width: 1,
      ),
    );
  }

  Widget _buildLanguageOption(String label, AppLanguage lang) {
    final isSelected = widget.currentLanguage == lang;
    return GestureDetector(
      onTap: () {
        widget.onLanguageChanged(lang);
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFFFC83D) : Colors.white,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFFFC83D),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'حذف جميع البيانات',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في حذف جميع البيانات؟ هذا الإجراء لا يمكن التراجع عنه.',
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
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف جميع البيانات بنجاح'),
                  backgroundColor: Colors.red,
                ),
              );
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text(
              'حذف',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}