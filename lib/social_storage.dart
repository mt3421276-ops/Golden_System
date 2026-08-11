
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SocialStorage {
  static const _friendsKey = 'gs_friends';
  static const _requestsKey = 'gs_friend_requests';
  static const _chatsKey = 'gs_chats';
  static const _groupsKey = 'gs_groups';

  static Future<List<Map<String, dynamic>>> _list(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<void> _saveList(
      String key, List<Map<String, dynamic>> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(value));
  }

  static Future<List<Map<String, dynamic>>> friends() =>
      _list(_friendsKey);

  static Future<List<Map<String, dynamic>>> requests() =>
      _list(_requestsKey);

  static Future<List<Map<String, dynamic>>> groups() =>
      _list(_groupsKey);

  static Future<List<Map<String, dynamic>>> chatMessages(
      String chatId) async {
    final all = await _list(_chatsKey);
    return all.where((m) => m['chatId'] == chatId).toList()
      ..sort((a, b) => (a['time'] ?? 0).compareTo(b['time'] ?? 0));
  }

  static Future<bool> addFriendRequest({
    required String playerId,
    required String name,
  }) async {
    final friends = await SocialStorage.friends();
    final requests = await SocialStorage.requests();
    if (playerId.trim().isEmpty) return false;
    if (friends.any((f) => f['id'] == playerId)) return false;
    if (requests.any((r) => r['id'] == playerId)) return false;

    requests.add({
      'id': playerId.trim(),
      'name': name.trim().isEmpty ? 'لاعب' : name.trim(),
      'time': DateTime.now().millisecondsSinceEpoch,
    });
    await _saveList(_requestsKey, requests);
    return true;
  }

  static Future<void> acceptRequest(
      Map<String, dynamic> request) async {
    final requests = await SocialStorage.requests();
    final friends = await SocialStorage.friends();
    final id = request['id'].toString();
    requests.removeWhere((r) => r['id'].toString() == id);
    if (!friends.any((f) => f['id'].toString() == id)) {
      friends.add({
        'id': id,
        'name': request['name'] ?? 'لاعب',
        'time': DateTime.now().millisecondsSinceEpoch,
      });
    }
    await _saveList(_requestsKey, requests);
    await _saveList(_friendsKey, friends);
  }

  static Future<void> rejectRequest(String id) async {
    final requests = await SocialStorage.requests();
    requests.removeWhere((r) => r['id'].toString() == id);
    await _saveList(_requestsKey, requests);
  }

  static Future<void> createGroup({
    required String name,
    required List<String> memberIds,
  }) async {
    final groups = await SocialStorage.groups();
    groups.add({
      'id': 'g_${DateTime.now().microsecondsSinceEpoch}',
      'name': name.trim().isEmpty ? 'غروب جديد' : name.trim(),
      'members': memberIds,
      'time': DateTime.now().millisecondsSinceEpoch,
    });
    await _saveList(_groupsKey, groups);
  }

  static Future<void> sendMessage({
    required String chatId,
    required String senderName,
    required String text,
    bool isGroup = false,
  }) async {
    final messages = await _list(_chatsKey);
    messages.add({
      'chatId': chatId,
      'senderName': senderName,
      'text': text,
      'isGroup': isGroup,
      'time': DateTime.now().millisecondsSinceEpoch,
    });
    await _saveList(_chatsKey, messages);
  }
}
