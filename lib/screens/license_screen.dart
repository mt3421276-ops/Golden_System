import 'package:flutter/material.dart';

class LicenseScreen extends StatefulWidget {
  /// المستويات التي اشتراها اللاعب بالفعل.
  /// مثال: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  final List<int> ownedLevels;

  /// المستوى النشط حاليًا.
  final int activeLevel;

  /// يتم استدعاؤه عندما يختار اللاعب رخصة جديدة.
  final ValueChanged<int>? onLevelChanged;

  const LicenseScreen({
    super.key,
    required this.ownedLevels,
    this.activeLevel = 1,
    this.onLevelChanged,
  });

  @override
  State<LicenseScreen> createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  static const Color gold = Color(0xFFFFC83D);

  late int selectedLevel;

  @override
  void initState() {
    super.initState();

    // لا نسمح باختيار مستوى غير مملوك.
    selectedLevel = widget.ownedLevels.contains(widget.activeLevel)
        ? widget.activeLevel
        : (widget.ownedLevels.isNotEmpty
            ? widget.ownedLevels.reduce((a, b) => a > b ? a : b)
            : 1);
  }

  void selectLicense(int level) {
    if (!widget.ownedLevels.contains(level)) {
      _showMessage('هذه الرخصة غير مملوكة بعد');
      return;
    }

    setState(() {
      selectedLevel = level;
    });

    widget.onLevelChanged?.call(level);

    _showMessage('تم تفعيل رخصة LVL $level');
  }

  void _showMessage(String message) {
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

  Widget licenseCard(int level) {
    final bool owned = widget.ownedLevels.contains(level);
    final bool active = selectedLevel == level;

    return GestureDetector(
      onTap: owned ? () => selectLicense(level) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF151108)
              : const Color(0xFF0B0B0B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? gold
                : owned
                    ? const Color(0xFF6F520D)
                    : const Color(0xFF292929),
            width: active ? 2 : 1,
          ),
          boxShadow: active
              ? const [
                  BoxShadow(
                    color: Color(0x44FFC83D),
                    blurRadius: 15,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: owned
                    ? const Color(0xFF18140A)
                    : const Color(0xFF111111),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: owned
                      ? const Color(0xFF8A650F)
                      : const Color(0xFF303030),
                ),
              ),
              child: Center(
                child: Text(
                  '$level',
                  style: TextStyle(
                    color: owned ? gold : Colors.white24,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'رخصة LVL $level',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: owned ? Colors.white : Colors.white30,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    active
                        ? 'الرخصة النشطة حاليًا'
                        : owned
                            ? 'اضغط لتفعيل هذه الرخصة'
                            : 'غير مملوكة',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: active
                          ? gold
                          : owned
                              ? Colors.white54
                              : Colors.white24,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Icon(
              active
                  ? Icons.check_circle_rounded
                  : owned
                      ? Icons.radio_button_unchecked_rounded
                      : Icons.lock_rounded,
              color: active
                  ? gold
                  : owned
                      ? Colors.white38
                      : Colors.white24,
              size: 27,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedLevels = [...widget.ownedLevels]..sort();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'الرخص',
            style: TextStyle(
              color: gold,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D0D),
                borderRadius: BorderRadius.circular(21),
                border: Border.all(
                  color: gold,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.badge_rounded,
                    color: gold,
                    size: 48,
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'الرخصة النشطة',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'LVL $selectedLevel',
                    style: const TextStyle(
                      color: gold,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'يمكنك التبديل بين جميع الرخص التي تملكها',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'رخصك المملوكة',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: gold,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 13),

            if (sortedLevels.isEmpty)
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B0B0B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF292929),
                  ),
                ),
                child: const Text(
                  'لا توجد لديك رخص مملوكة بعد.\nاذهب إلى المتجر لشراء مستوى جديد.',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 15,
                  ),
                ),
              )
            else
              ...sortedLevels.map(licenseCard),
          ],
        ),
      ),
    );
  }
}
