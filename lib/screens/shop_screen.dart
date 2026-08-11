import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  final int goldBalance;
  final int diamonds;
  final int currentLevel;

  const ShopScreen({
    super.key,
    required this.goldBalance,
    required this.diamonds,
    this.currentLevel = 1,
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  static const Color gold = Color(0xFFFFC83D);

  late int goldBalance;
  late int diamonds;
  late int currentLevel;

  final List<Map<String, dynamic>> levels = [
    {'level': 2, 'price': 100000},
    {'level': 3, 'price': 250000},
    {'level': 4, 'price': 500000},
    {'level': 5, 'price': 750000},
    {'level': 6, 'price': 1200000},
    {'level': 7, 'price': 1800000},
    {'level': 8, 'price': 2500000},
    {'level': 9, 'price': 3500000},
    {'level': 10, 'price': 5000000},
  ];

  @override
  void initState() {
    super.initState();
    goldBalance = widget.goldBalance;
    diamonds = widget.diamonds;
    currentLevel = widget.currentLevel;
  }

  String formatGold(int value) {
    if (value >= 1000000) {
      final double millions = value / 1000000;
      return '${millions.toStringAsFixed(millions == millions.roundToDouble() ? 0 : 1)}M';
    }
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => ',',
    );
  }

  void buyLevel(int level, int price) {
    if (level <= currentLevel) {
      showMessage('هذا المستوى مفتوح بالفعل');
      return;
    }
    if (level != currentLevel + 1) {
      showMessage('يجب شراء المستويات بالترتيب');
      return;
    }
    if (goldBalance < price) {
      showMessage('رصيد Gold غير كافٍ');
      return;
    }

    setState(() {
      goldBalance -= price;
      currentLevel = level;
    });
    showMessage('تم شراء LVL $level بنجاح');
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: const Color(0xFF171717),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget currency({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: color.withAlpha(130)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(title, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(value, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget levelCard(int level, int price) {
    final owned = level <= currentLevel;
    final next = level == currentLevel + 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: owned ? const Color(0xFF4D3C10) : next ? gold : const Color(0xFF292929),
          width: next ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Column(
              children: [
                Text('LVL', style: TextStyle(color: owned ? gold : Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                Text('$level', style: TextStyle(color: owned ? gold : Colors.white, fontSize: 29, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  owned ? 'تم فتح المستوى' : next ? 'المستوى التالي' : 'مستوى مقفل',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: owned ? Colors.greenAccent : next ? gold : Colors.white54,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '🪙 ${formatGold(price)} Gold',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: owned ? null : () => buyLevel(level, price),
            style: ElevatedButton.styleFrom(
              backgroundColor: next ? gold : const Color(0xFF222222),
              foregroundColor: next ? Colors.black : Colors.white54,
              disabledBackgroundColor: const Color(0xFF1A1A1A),
              disabledForegroundColor: Colors.greenAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            ),
            child: Text(owned ? 'مفتوح' : 'شراء', style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: const Text('المتجر', style: TextStyle(color: gold, fontWeight: FontWeight.w900, fontSize: 24)),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          children: [
            Row(
              children: [
                currency(
                  icon: Icons.monetization_on_rounded,
                  title: 'GOLD',
                  value: formatGold(goldBalance),
                  color: gold,
                ),
                const SizedBox(width: 12),
                currency(
                  icon: Icons.diamond_rounded,
                  title: 'DIAMONDS',
                  value: diamonds.toString(),
                  color: const Color(0xFF39BFFF),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Text(
              'رفع المستوى',
              textAlign: TextAlign.center,
              style: TextStyle(color: gold, fontSize: 27, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 7),
            const Text(
              'أسعار المستويات الرسمية',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ...levels.map((item) => levelCard(item['level'] as int, item['price'] as int)),
            const SizedBox(height: 12),
            const Text(
              'القدرات ستكون متوفرة في تحديث قادم.',
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(color: Colors.white54, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
