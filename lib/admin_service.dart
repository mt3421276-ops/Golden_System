import 'package:shared_preferences/shared_preferences.dart';

class AdminCodeResult {
  final bool success;
  final String message;

  const AdminCodeResult({
    required this.success,
    required this.message,
  });
}

class AdminService {
  static const String _adminKey = 'is_golden_admin';
  static const String _verifiedKey = 'is_verified_admin';
  static const String _usedAdminCodesKey = 'used_admin_codes';
  static const String _lastWeeklyKey = 'admin_last_weekly_bonus';

  // هذه الأكواد الخمسة مخصصة لمسؤولي Golden System.
  static const Map<String, bool> adminCodes = {
    'O96HLP0S7O6C': true,
    '6W4NZN31REXO': true,
    'XF7NWOHUIX99': true,
    'LSUUC6O1OZ3D': true,
    'RUXZU6KMRGPS': true,
  };

  static Future<AdminCodeResult> redeemAdminCode(String rawCode) async {
    final code = rawCode.trim().toUpperCase();

    if (code.length != 12 ||
        !RegExp(r'^[A-Z0-9]{12}$').hasMatch(code)) {
      return const AdminCodeResult(
        success: false,
        message: 'كود المسؤول غير صحيح.',
      );
    }

    if (!adminCodes.containsKey(code)) {
      return const AdminCodeResult(
        success: false,
        message: 'كود المسؤول غير موجود.',
      );
    }

    final prefs = await SharedPreferences.getInstance();
    final used =
        prefs.getStringList(_usedAdminCodesKey) ?? <String>[];

    if (used.contains(code)) {
      return const AdminCodeResult(
        success: false,
        message: 'تم استخدام كود المسؤول هذا من قبل على هذا الجهاز.',
      );
    }

    used.add(code);
    await prefs.setStringList(_usedAdminCodesKey, used);
    await prefs.setBool(_adminKey, true);
    await prefs.setBool(_verifiedKey, true);

    // يمنح أول مكافأة أسبوعية عند تفعيل الحساب الإداري.
    await _grantWeeklyBonusIfNeeded(prefs);

    return const AdminCodeResult(
      success: true,
      message:
          'تم تفعيل صلاحيات مسؤول Golden System وإضافة شارة التوثيق.',
    );
  }

  static Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_adminKey) ?? false;
  }

  static Future<bool> isVerifiedAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_verifiedKey) ?? false;
  }

  static Future<bool> ensureWeeklyBonus() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_adminKey) ?? false)) return false;
    return _grantWeeklyBonusIfNeeded(prefs);
  }

  static String _weekKey(DateTime date) {
    final utc = DateTime(date.year, date.month, date.day);
    final mondayOffset = utc.weekday - DateTime.monday;
    final monday =
        utc.subtract(Duration(days: mondayOffset));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  static Future<bool> _grantWeeklyBonusIfNeeded(
      SharedPreferences prefs) async {
    final currentWeek = _weekKey(DateTime.now());
    final lastWeek = prefs.getString(_lastWeeklyKey);

    if (lastWeek == currentWeek) return false;

    final currentGold = prefs.getInt('gold_balance') ?? 0;
    await prefs.setInt('gold_balance', currentGold + 500000);
    await prefs.setString(_lastWeeklyKey, currentWeek);

    return true;
  }

  static Future<String?> lastWeeklyBonusWeek() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastWeeklyKey);
  }
}
