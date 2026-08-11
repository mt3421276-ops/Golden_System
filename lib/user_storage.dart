import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'player_data.dart';

class UserStorage {
  static const String _key = 'user_data';

  // حفظ بيانات المستخدم
  static Future<void> save(PlayerData player) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(player.toMap());
    await prefs.setString(_key, jsonString);
  }

  // حفظ بيانات المستخدم كـ Map
  static Future<void> saveMap(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(data);
    await prefs.setString(_key, jsonString);
  }

  // تحميل بيانات المستخدم
  static Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);
    
    if (jsonString == null) return null;
    
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return data;
    } catch (e) {
      return null;
    }
  }

  // تحميل البيانات كـ PlayerData
  static Future<PlayerData?> loadPlayer() async {
    final data = await load();
    if (data == null) return null;
    return PlayerData.fromMap(data);
  }

  // حذف جميع البيانات
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  // التحقق من وجود حساب
  static Future<bool> hasAccount() async {
    final data = await load();
    return data != null && data['registered'] == true;
  }

  // تحديث بيانات معينة
  static Future<void> updateField(String key, dynamic value) async {
    final data = await load();
    if (data != null) {
      data[key] = value;
      await saveMap(data);
    }
  }

  // الحصول على قيمة حقل معين
  static Future<dynamic> getField(String key) async {
    final data = await load();
    return data != null ? data[key] : null;
  }
}