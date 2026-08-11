import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CodeReward {
  final String type; // gold or diamonds
  final int amount;

  const CodeReward({required this.type, required this.amount});
}

class RedeemResult {
  final bool success;
  final String message;
  final CodeReward? reward;
  final bool alreadyUsed;

  const RedeemResult({
    required this.success,
    required this.message,
    this.reward,
    this.alreadyUsed = false,
  });
}

class RedemptionService {
  static const String _usedCodesKey = 'redeemed_codes';
  static const String _goldKey = 'gold_balance';
  static const String _diamondsKey = 'diamonds_balance';

  static const Map<String, CodeReward> codes = {
  'CHVKTRF2WHUQ': const CodeReward(type: 'gold', amount: 100000),
  'DNG1UH19RBD2': const CodeReward(type: 'gold', amount: 150000),
  '0RCQ1WSUFZK5': const CodeReward(type: 'gold', amount: 250000),
  'B338QTFNDXPE': const CodeReward(type: 'gold', amount: 300000),
  'HA8DE85L1LII': const CodeReward(type: 'gold', amount: 500000),
  'REL2SEDLFN6V': const CodeReward(type: 'gold', amount: 750000),
  'CWPVPSM6EHK1': const CodeReward(type: 'gold', amount: 1000000),
  'DWRSEYRTZ979': const CodeReward(type: 'gold', amount: 1500000),
  'WASFWGJRVOFK': const CodeReward(type: 'gold', amount: 2000000),
  '4Z4XWO8IXHNK': const CodeReward(type: 'gold', amount: 2500000),
  'RZ0N2CV65NZO': const CodeReward(type: 'gold', amount: 3000000),
  'FP31RS6X8YIG': const CodeReward(type: 'gold', amount: 4000000),
  'VAD91RWGGRX0': const CodeReward(type: 'gold', amount: 5000000),
  'H6TVZ4O7N7EN': const CodeReward(type: 'gold', amount: 100000),
  'BQLEHHMZTCQV': const CodeReward(type: 'gold', amount: 150000),
  '11ASGC7KAP6W': const CodeReward(type: 'gold', amount: 250000),
  'CZ3ODA58EL5T': const CodeReward(type: 'gold', amount: 300000),
  'LN6WPH2JO2LJ': const CodeReward(type: 'gold', amount: 500000),
  'Z1ZGDV4JJOXU': const CodeReward(type: 'gold', amount: 750000),
  'KL7POIII3V5V': const CodeReward(type: 'gold', amount: 1000000),
  '4U3VY0MGFC16': const CodeReward(type: 'gold', amount: 1500000),
  'RP5W3U1JB08N': const CodeReward(type: 'gold', amount: 2000000),
  'AEHFYTKXXVV4': const CodeReward(type: 'gold', amount: 2500000),
  'DF61GPS2W8HE': const CodeReward(type: 'gold', amount: 3000000),
  '5H89F9CQEXW5': const CodeReward(type: 'gold', amount: 4000000),
  '3H41DRRY4M9X': const CodeReward(type: 'gold', amount: 5000000),
  '8DSVPVBW273X': const CodeReward(type: 'gold', amount: 100000),
  'J249J6IWTNEM': const CodeReward(type: 'gold', amount: 150000),
  'U1TCORLTPCSW': const CodeReward(type: 'gold', amount: 250000),
  'FTJB9DNA0D57': const CodeReward(type: 'gold', amount: 300000),
  '9ZTJOY2QUZF4': const CodeReward(type: 'gold', amount: 500000),
  'CWIELHG6VSJI': const CodeReward(type: 'gold', amount: 750000),
  '76SBVU6Z05PQ': const CodeReward(type: 'gold', amount: 1000000),
  'U5QVABE0RKU8': const CodeReward(type: 'gold', amount: 1500000),
  'UJA7Q6ECPHH5': const CodeReward(type: 'gold', amount: 2000000),
  'QGAH4B90ZQWE': const CodeReward(type: 'gold', amount: 2500000),
  '49C51C9BKV3E': const CodeReward(type: 'gold', amount: 3000000),
  'SSWIUNK18GTS': const CodeReward(type: 'gold', amount: 4000000),
  'NJ4Q1041MF0W': const CodeReward(type: 'gold', amount: 5000000),
  'L26NTQWH72SE': const CodeReward(type: 'gold', amount: 100000),
  'OOGPQ0YZSIIQ': const CodeReward(type: 'gold', amount: 150000),
  'MUVLHK74E0TN': const CodeReward(type: 'gold', amount: 250000),
  'MHZ8APS22NR6': const CodeReward(type: 'gold', amount: 300000),
  '0IGZMNNEH1OD': const CodeReward(type: 'gold', amount: 500000),
  'O7AHYUOO7FI0': const CodeReward(type: 'gold', amount: 750000),
  'EV7YSBMXQRD9': const CodeReward(type: 'gold', amount: 1000000),
  '2W9Q8O6MH17X': const CodeReward(type: 'gold', amount: 1500000),
  'XAZ8NCMAA57O': const CodeReward(type: 'gold', amount: 2000000),
  'T8RQ067KJVMF': const CodeReward(type: 'gold', amount: 2500000),
  'QKRQ8L0U5SII': const CodeReward(type: 'gold', amount: 3000000),
  'R015K7TGMJ3N': const CodeReward(type: 'gold', amount: 4000000),
  'WZVEWB0RBDUB': const CodeReward(type: 'gold', amount: 5000000),
  'CH2F51JV2NA9': const CodeReward(type: 'gold', amount: 100000),
  'SIXAUN52L882': const CodeReward(type: 'gold', amount: 150000),
  '8BHAHPKBN76N': const CodeReward(type: 'gold', amount: 250000),
  '2QTMU0C4FKP6': const CodeReward(type: 'gold', amount: 300000),
  'VQBBL0IR008X': const CodeReward(type: 'gold', amount: 500000),
  'CNAQOCRHVXNG': const CodeReward(type: 'gold', amount: 750000),
  '435B193RZ4AR': const CodeReward(type: 'gold', amount: 1000000),
  'YXTY138HOBFL': const CodeReward(type: 'gold', amount: 1500000),
  'X4RP0V73HDDL': const CodeReward(type: 'diamonds', amount: 25),
  'XU2AKRIYI3VA': const CodeReward(type: 'diamonds', amount: 30),
  '779K3LOAR8RR': const CodeReward(type: 'diamonds', amount: 40),
  '6D0QFKZSJBQP': const CodeReward(type: 'diamonds', amount: 50),
  'GH012UOF1350': const CodeReward(type: 'diamonds', amount: 60),
  '0FOKGLNGNRT6': const CodeReward(type: 'diamonds', amount: 75),
  'B36H3ENMC4XC': const CodeReward(type: 'diamonds', amount: 80),
  'AS77U4GLS6JN': const CodeReward(type: 'diamonds', amount: 90),
  '72TFF20OWQB9': const CodeReward(type: 'diamonds', amount: 100),
  '1K6XY5Y7FIH8': const CodeReward(type: 'diamonds', amount: 25),
  'TSRSPQVYSID9': const CodeReward(type: 'diamonds', amount: 30),
  'HO9NNQJWB5NH': const CodeReward(type: 'diamonds', amount: 40),
  'FS25FMI1CNR5': const CodeReward(type: 'diamonds', amount: 50),
  'GX1ZN0OAGCWL': const CodeReward(type: 'diamonds', amount: 60),
  'LLXUJHGUMGEB': const CodeReward(type: 'diamonds', amount: 75),
  '07NT7Z1MTE16': const CodeReward(type: 'diamonds', amount: 80),
  'KOT0BES2RY0W': const CodeReward(type: 'diamonds', amount: 90),
  'RPGFHZAZ7PYJ': const CodeReward(type: 'diamonds', amount: 100),
  'K44V05C1MX8V': const CodeReward(type: 'diamonds', amount: 25),
  'IY302Z8LIVLP': const CodeReward(type: 'diamonds', amount: 30),
  'VY3R9QLLCM2I': const CodeReward(type: 'diamonds', amount: 40),
  'C2G13FHOFD5M': const CodeReward(type: 'diamonds', amount: 50),
  'OFUBUIFXEVH9': const CodeReward(type: 'diamonds', amount: 60),
  'PJ8ZIU24BAO7': const CodeReward(type: 'diamonds', amount: 75),
  'PP6X3G96OXJO': const CodeReward(type: 'diamonds', amount: 80),
  'IPDLVPO6RHWG': const CodeReward(type: 'diamonds', amount: 90),
  'BGWNMZIKM1PF': const CodeReward(type: 'diamonds', amount: 100),
  'SOO4W85FC6C2': const CodeReward(type: 'diamonds', amount: 25),
  'V006TVLSDHBF': const CodeReward(type: 'diamonds', amount: 30),
  '5YLZ46CO3U1E': const CodeReward(type: 'diamonds', amount: 40),
  '5TIJQVW6TK8N': const CodeReward(type: 'diamonds', amount: 50),
  '924XFYHT9PIL': const CodeReward(type: 'diamonds', amount: 60),
  'PIUDUVN0HTUI': const CodeReward(type: 'diamonds', amount: 75),
  'GAGBFOU88IIG': const CodeReward(type: 'diamonds', amount: 80),
  'BMAQY6QOTEMM': const CodeReward(type: 'diamonds', amount: 90),
  '7PVOTJ1G5UQW': const CodeReward(type: 'diamonds', amount: 100),
  'VZUCPLLNN4JF': const CodeReward(type: 'diamonds', amount: 25),
  'K9NJQDCWM77Y': const CodeReward(type: 'diamonds', amount: 30),
  'L92PXOM2ZUI8': const CodeReward(type: 'diamonds', amount: 40),
  'EME5VCOKMGTW': const CodeReward(type: 'diamonds', amount: 50),
  };

  static Future<RedeemResult> redeem(String rawCode) async {
    final code = rawCode.trim().toUpperCase();

    if (code.length != 12 ||
        !RegExp(r'^[A-Z0-9]{12}$').hasMatch(code)) {
      return const RedeemResult(
        success: false,
        message: 'الكود غير صحيح.',
      );
    }

    final reward = codes[code];

    if (reward == null) {
      return const RedeemResult(
        success: false,
        message: 'الكود غير صحيح أو غير موجود.',
      );
    }

    final prefs = await SharedPreferences.getInstance();
    final used = prefs.getStringList(_usedCodesKey) ?? <String>[];

    if (used.contains(code)) {
      return const RedeemResult(
        success: false,
        message: 'تم استخدام هذا الكود من قبل.',
        alreadyUsed: true,
      );
    }

    if (reward.type == 'gold') {
      final current = prefs.getInt(_goldKey) ?? 0;
      await prefs.setInt(_goldKey, current + reward.amount);
    } else {
      final current = prefs.getInt(_diamondsKey) ?? 0;
      await prefs.setInt(_diamondsKey, current + reward.amount);
    }

    used.add(code);
    await prefs.setStringList(_usedCodesKey, used);

    return RedeemResult(
      success: true,
      message: reward.type == 'gold'
          ? 'تم استبدال الكود وحصلت على ${reward.amount} Gold.'
          : 'تم استبدال الكود وحصلت على ${reward.amount} جوهرة.',
      reward: reward,
    );
  }

  static Future<int> getGold() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_goldKey) ?? 1500;
  }

  static Future<int> getDiamonds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_diamondsKey) ?? 250;
  }

  static Future<List<String>> getUsedCodes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_usedCodesKey) ?? <String>[];
  }

  static Future<List<Map<String, dynamic>>> getRedemptionHistory() async {
    final used = await getUsedCodes();
    return used.map((code) {
      final reward = codes[code];
      return {
        'code': code,
        'type': reward?.type ?? '',
        'amount': reward?.amount ?? 0,
      };
    }).toList();
  }
}
