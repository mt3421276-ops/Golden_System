
import 'dart:math';
import 'package:flutter/material.dart';

class BattleScreen extends StatefulWidget {
  final String battleCode;
  final String playerName;
  final String opponentName;

  const BattleScreen({
    super.key,
    required this.battleCode,
    required this.playerName,
    this.opponentName = 'الخصم',
  });

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  static const gold = Color(0xFFFFC83D);
  final Random random = Random();

  int playerHp = 200;
  int opponentHp = 200;
  bool playerTurn = true;
  bool defending = false;
  bool over = false;
  String result = '⚔️ دورك! اختر حركتك.';

  void attack(int bonus) {
    if (over || !playerTurn) return;

    var damage = 10 + random.nextInt(20) + bonus;
    opponentHp = max(0, opponentHp - damage);

    if (opponentHp == 0) {
      setState(() {
        over = true;
        result = '🎉 فزت بالنزال!';
      });
      return;
    }

    setState(() {
      result = '⚔️ سببت $damage ضررًا.';
      playerTurn = false;
    });

    Future.delayed(const Duration(milliseconds: 850), opponentAttack);
  }

  void opponentAttack() {
    if (!mounted || over) return;

    var damage = 7 + random.nextInt(16);
    if (defending) {
      damage ~/= 2;
    }

    playerHp = max(0, playerHp - damage);

    if (playerHp == 0) {
      setState(() {
        over = true;
        result = '💥 خسرت النزال. حاول مرة أخرى!';
      });
      return;
    }

    setState(() {
      result = '💢 الخصم سبب $damage ضررًا.';
      playerTurn = true;
      defending = false;
    });
  }

  void toggleDefense() {
    if (over || !playerTurn) return;
    setState(() {
      defending = !defending;
      result = defending ? '🛡️ الدفاع مفعل.' : '🛡️ الدفاع متوقف.';
    });
  }

  void reset() {
    setState(() {
      playerHp = 200;
      opponentHp = 200;
      playerTurn = true;
      defending = false;
      over = false;
      result = '⚔️ دورك! اختر حركتك.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text('⚔️ النزال',
              style: TextStyle(color: gold, fontWeight: FontWeight.bold)),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  '#${widget.battleCode}',
                  style: const TextStyle(color: Colors.white38),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _healthCard(widget.playerName, playerHp, 200, Icons.person_rounded),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text('⚡ VS ⚡',
                    style: TextStyle(
                        color: gold,
                        fontSize: 24,
                        fontWeight: FontWeight.w900)),
              ),
            ),
            _healthCard(widget.opponentName, opponentHp, 200, Icons.smart_toy_rounded),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D0D),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF6F520D)),
              ),
              child: Text(result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            if (!over)
              Row(
                children: [
                  Expanded(
                    child: _button('⚔️', 'هجوم', () => attack(0)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _button('💥', 'قوي', () => attack(15)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _button(
                      '🛡️',
                      'دفاع',
                      toggleDefense,
                      active: defending,
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: reset,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('نزال جديد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            const SizedBox(height: 18),
            const Text(
              'ملاحظة: هذا هو محرك النزال المحلي الحالي. الكود يحدد غرفة النزال، لكن اللعب بين هاتفين يحتاج خادمًا أو اتصالًا مباشرًا يتم ربطه لاحقًا.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white30, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _healthCard(
      String name, int hp, int maxHp, IconData icon) {
    final ratio = hp / maxHp;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF6F520D)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: gold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              Text('$hp / $maxHp',
                  style: const TextStyle(color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 13,
              backgroundColor: const Color(0xFF252525),
              valueColor: AlwaysStoppedAnimation<Color>(
                ratio > .5 ? gold : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String icon, String text, VoidCallback onTap,
      {bool active = false}) {
    return ElevatedButton(
      onPressed: playerTurn ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? Colors.green : const Color(0xFF171717),
        foregroundColor: active ? Colors.white : gold,
        padding: const EdgeInsets.symmetric(vertical: 13),
        side: const BorderSide(color: Color(0xFF6F520D)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 21)),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
