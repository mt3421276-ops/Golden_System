import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_service.dart';
import 'player_data.dart';
import 'redemption_service.dart';
import 'user_storage.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  static const gold = Color(0xFFFFC83D);

  bool loading = true;
  bool isAdmin = false;
  bool isVerified = false;
  bool receivedWeekly = false;

  PlayerData? player;
  List<Map<String, dynamic>> redemptionHistory = [];
  List<String> missions = [];
  List<String> battleHistory = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    isAdmin = await AdminService.isAdmin();
    isVerified = await AdminService.isVerifiedAdmin();

    if (isAdmin) {
      receivedWeekly = await AdminService.ensureWeeklyBonus();
    }

    final data = await UserStorage.load();
    if (data != null) {
      player = PlayerData.fromMap(data);
    }

    redemptionHistory =
        await RedemptionService.getRedemptionHistory();

    final prefs = await SharedPreferences.getInstance();
    missions =
        prefs.getStringList('completed_missions') ?? <String>[];
    battleHistory =
        prefs.getStringList('battle_history') ?? <String>[];

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _showAdminCodeDialog() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        bool submitting = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> submit() async {
              if (submitting) return;

              setDialogState(() {
                submitting = true;
              });

              final result =
                  await AdminService.redeemAdminCode(
                controller.text,
              );

              if (!mounted) return;

              Navigator.pop(dialogContext);

              ScaffoldMessenger.of(this.context).showSnackBar(
                SnackBar(
                  content: Text(
                    result.message,
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor:
                      result.success
                          ? const Color(0xFF164D2A)
                          : const Color(0xFF5A1717),
                  behavior: SnackBarBehavior.floating,
                ),
              );

              if (result.success) {
                await _load();
              }
            }

            return AlertDialog(
              backgroundColor: const Color(0xFF121212),
              title: const Text(
                'تفعيل مسؤول Golden System',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: gold,
                  fontWeight: FontWeight.w900,
                ),
              ),
              content: TextField(
                controller: controller,
                maxLength: 12,
                textAlign: TextAlign.center,
                textCapitalization:
                    TextCapitalization.characters,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                decoration: const InputDecoration(
                  hintText: 'أدخل كود المسؤول',
                  hintStyle: TextStyle(color: Colors.white38),
                  counterText: '',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                ElevatedButton(
                  onPressed: submitting ? null : submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('تفعيل'),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF6F520D),
        ),
      ),
      child: child,
    );
  }

  Widget _row(
    String title,
    String value, {
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, color: gold, size: 24),
          if (icon != null) const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: gold),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            'إدارة Golden System',
            style: TextStyle(
              color: gold,
              fontWeight: FontWeight.w900,
            ),
          ),
          iconTheme: const IconThemeData(color: gold),
        ),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            if (!isAdmin) ...[
              _card(
                child: Column(
                  children: [
                    const Icon(
                      Icons.admin_panel_settings_rounded,
                      color: gold,
                      size: 60,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'صلاحيات المسؤول',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'أدخل أحد أكواد المسؤول التي حصلت عليها من إدارة Golden System.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showAdminCodeDialog,
                        icon: const Icon(Icons.verified_rounded),
                        label: const Text('إدخال كود المسؤول'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gold,
                          foregroundColor: Colors.black,
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              _card(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          color: gold,
                          size: 40,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'مسؤول موثّق',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (isVerified)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: gold,
                            size: 28,
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      receivedWeekly
                          ? 'تمت إضافة 500,000 Gold كمكافأة هذا الأسبوع.'
                          : 'المكافأة الأسبوعية: 500,000 Gold.',
                      style: TextStyle(
                        color: receivedWeekly
                            ? gold
                            : Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              _card(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'أرشيف اللاعب',
                      style: TextStyle(
                        color: gold,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _row(
                      'اسم اللاعب',
                      player?.playerName ?? 'غير متوفر',
                      icon: Icons.person_rounded,
                    ),
                    _row(
                      'معرف اللاعب',
                      player?.playerId ?? 'غير متوفر',
                      icon: Icons.badge_rounded,
                    ),
                    _row(
                      'الشخصية',
                      player?.characterName ?? 'غير متوفر',
                      icon: Icons.theater_comedy_rounded,
                    ),
                  ],
                ),
              ),

              _card(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.task_alt_rounded,
                          color: gold,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'المهام المنجزة',
                          style: TextStyle(
                            color: gold,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (missions.isEmpty)
                      const Text(
                        'لا توجد مهام مسجلة حاليًا.',
                        style: TextStyle(color: Colors.white38),
                      )
                    else
                      ...missions.map(
                        (mission) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.check_circle_rounded,
                            color: gold,
                          ),
                          title: Text(
                            mission,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              _card(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.history_rounded,
                          color: gold,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'سجل الأكواد والمكافآت',
                          style: TextStyle(
                            color: gold,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (redemptionHistory.isEmpty)
                      const Text(
                        'لا توجد عمليات استبدال.',
                        style: TextStyle(color: Colors.white38),
                      )
                    else
                      ...redemptionHistory.map(
                        (item) => _row(
                          item['code']?.toString() ?? '',
                          item['type'] == 'gold'
                              ? '${item['amount']} Gold'
                              : '${item['amount']} 💎',
                          icon: Icons.redeem_rounded,
                        ),
                      ),
                  ],
                ),
              ),

              _card(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.sports_esports_rounded,
                          color: gold,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'أرشيف النزالات',
                          style: TextStyle(
                            color: gold,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (battleHistory.isEmpty)
                      const Text(
                        'لا توجد نزالات مسجلة حاليًا.',
                        style: TextStyle(color: Colors.white38),
                      )
                    else
                      ...battleHistory.map(
                        (battle) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.history_rounded,
                            color: gold,
                          ),
                          title: Text(
                            battle,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
