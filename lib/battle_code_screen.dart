
import 'dart:math';
import 'package:flutter/material.dart';
import 'battle_screen.dart';

class BattleCodeScreen extends StatefulWidget {
  final String playerName;
  final String playerId;

  const BattleCodeScreen({
    super.key,
    required this.playerName,
    required this.playerId,
  });

  @override
  State<BattleCodeScreen> createState() => _BattleCodeScreenState();
}

class _BattleCodeScreenState extends State<BattleCodeScreen> {
  static const gold = Color(0xFFFFC83D);
  final joinController = TextEditingController();
  String? generatedCode;

  @override
  void dispose() {
    joinController.dispose();
    super.dispose();
  }

  String _makeCode() {
    final n = Random().nextInt(900000) + 100000;
    return n.toString();
  }

  void _create() {
    setState(() => generatedCode = _makeCode());
  }

  void _join() {
    final code = joinController.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل كود نزال من 6 أرقام')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BattleScreen(
          battleCode: code,
          playerName: widget.playerName,
          opponentName: 'الخصم',
        ),
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
          title: const Text('⚔️ النزال بالكود',
              style: TextStyle(color: gold)),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _card(
              title: 'إنشاء نزال',
              icon: Icons.add_circle_outline_rounded,
              child: Column(
                children: [
                  const Text(
                    'أنشئ كودًا وأرسله لصديقك.',
                    style: TextStyle(color: Colors.white54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  if (generatedCode != null)
                    SelectableText(
                      generatedCode!,
                      style: const TextStyle(
                        color: gold,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                      ),
                    ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _create,
                    icon: const Icon(Icons.flash_on_rounded),
                    label: Text(generatedCode == null
                        ? 'إنشاء الكود'
                        : 'إنشاء كود جديد'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  if (generatedCode != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'الكود لا يربط جهازين بالإنترنت وحده؛ الربط الشبكي يحتاج خادمًا.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.orange.shade200, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _card(
              title: 'دخول إلى نزال',
              icon: Icons.login_rounded,
              child: Column(
                children: [
                  TextField(
                    controller: joinController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: const TextStyle(
                        color: Colors.white, letterSpacing: 5),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: '000000',
                      hintStyle: TextStyle(color: Colors.white24),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _join,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF171717),
                        foregroundColor: gold,
                        side: const BorderSide(color: gold),
                      ),
                      child: const Text('دخول إلى النزال'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6F520D)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: gold),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}
