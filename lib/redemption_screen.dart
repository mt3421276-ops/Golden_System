import 'package:flutter/material.dart';
import 'redemption_service.dart';

class RedemptionScreen extends StatefulWidget {
  const RedemptionScreen({super.key});

  @override
  State<RedemptionScreen> createState() => _RedemptionScreenState();
}

class _RedemptionScreenState extends State<RedemptionScreen> {
  static const gold = Color(0xFFFFC83D);
  final _controller = TextEditingController();
  int _gold = 0;
  int _diamonds = 0;
  List<Map<String, dynamic>> _history = [];
  bool _loading = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final balances = {
      'gold': await RedemptionService.getGold(),
      'diamonds': await RedemptionService.getDiamonds(),
    };
    final history = await RedemptionService.getRedemptionHistory();
    if (!mounted) return;
    setState(() {
      _gold = balances['gold'] ?? 0;
      _diamonds = balances['diamonds'] ?? 0;
      _history = history;
      _loading = false;
    });
  }

  Future<void> _redeem() async {
    if (_submitting) return;
    final code = _controller.text.trim();
    if (code.isEmpty) {
      _message('أدخل كود الاستبدال أولًا.');
      return;
    }
    setState(() => _submitting = true);
    final result = await RedemptionService.redeem(code);
    if (!mounted) return;
    setState(() => _submitting = false);
    _controller.clear();
    _message(result.message, success: result.success);
    await _load();
  }

  void _message(String text, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, textAlign: TextAlign.center),
        backgroundColor: success ? const Color(0xFF164D2A) : const Color(0xFF5A1717),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _reward(Map<String, dynamic> item) {
    final type = item['type']?.toString();
    final amount = item['amount'] ?? 0;
    return type == 'diamonds' ? '$amount 💎' : '$amount Gold';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('استبدال كود', style: TextStyle(color: gold, fontWeight: FontWeight.w900)),
        iconTheme: const IconThemeData(color: gold),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: gold))
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Row(
                  children: [
                    Expanded(child: _balanceCard('Gold', _gold.toString(), Icons.monetization_on_rounded)),
                    const SizedBox(width: 12),
                    Expanded(child: _balanceCard('Diamonds', _diamonds.toString(), Icons.diamond_rounded)),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101010),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF6F520D)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.card_giftcard_rounded, color: gold, size: 50),
                      const SizedBox(height: 10),
                      const Text('أدخل كود المكافأة', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _controller,
                        maxLength: 12,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.characters,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
                        decoration: InputDecoration(
                          hintText: 'XXXXXXXXXXXX',
                          hintStyle: const TextStyle(color: Colors.white24),
                          counterText: '',
                          filled: true,
                          fillColor: const Color(0xFF080808),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: gold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submitting ? null : _redeem,
                          icon: const Icon(Icons.redeem_rounded),
                          label: Text(_submitting ? 'جارٍ التحقق...' : 'استبدال الكود'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gold,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Text('سجل الأكواد المستخدمة', textAlign: TextAlign.right,
                    style: TextStyle(color: gold, fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                if (_history.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('لا توجد أكواد مستخدمة بعد.', textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white38)),
                  ),
                ..._history.map((item) => Card(
                  color: const Color(0xFF101010),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle_rounded, color: gold),
                    title: Text(item['code']?.toString() ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    subtitle: Text(_reward(item), style: const TextStyle(color: Colors.white54)),
                  ),
                )),
              ],
            ),
    );
  }

  Widget _balanceCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6F520D)),
      ),
      child: Column(
        children: [
          Icon(icon, color: gold, size: 28),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
