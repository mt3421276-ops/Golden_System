
import 'package:flutter/material.dart';
import 'social_storage.dart';
import 'battle_code_screen.dart';

class SocialScreen extends StatefulWidget {
  final String playerName;
  final String playerId;

  const SocialScreen({
    super.key,
    required this.playerName,
    required this.playerId,
  });

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
    with SingleTickerProviderStateMixin {
  static const gold = Color(0xFFFFC83D);

  late TabController _tabs;
  List<Map<String, dynamic>> _friends = [];
  List<Map<String, dynamic>> _requests = [];
  List<Map<String, dynamic>> _groups = [];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final friends = await SocialStorage.friends();
    final requests = await SocialStorage.requests();
    final groups = await SocialStorage.groups();
    if (!mounted) return;
    setState(() {
      _friends = friends;
      _requests = requests;
      _groups = groups;
    });
  }

  Future<void> _addFriend() async {
    final idController = TextEditingController();
    final nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF121212),
        title: const Text('إضافة صديق',
            textDirection: TextDirection.rtl,
            style: TextStyle(color: gold)),
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'معرف اللاعب',
                  labelStyle: TextStyle(color: Colors.white54),
                ),
              ),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'اسم اللاعب',
                  labelStyle: TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final id = idController.text.trim();
              if (id == widget.playerId) {
                _message('لا يمكنك إضافة نفسك.');
                return;
              }
              final ok = await SocialStorage.addFriendRequest(
                playerId: id,
                name: nameController.text,
              );
              if (mounted) Navigator.pop(context);
              _message(ok ? 'تم إنشاء طلب الصداقة.' : 'الطلب موجود بالفعل أو البيانات غير صحيحة.');
              await _load();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gold,
              foregroundColor: Colors.black,
            ),
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  Future<void> _createGroup() async {
    if (_friends.isEmpty) {
      _message('أضف أصدقاء أولًا لإنشاء غروب.');
      return;
    }

    final nameController = TextEditingController();
    final selected = <String>{};

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF121212),
          title: const Text('إنشاء غروب',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: gold)),
          content: SizedBox(
            width: double.maxFinite,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'اسم الغروب',
                      labelStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._friends.map((f) {
                    final id = f['id'].toString();
                    final checked = selected.contains(id);
                    return CheckboxListTile(
                      value: checked,
                      activeColor: gold,
                      title: Text(f['name']?.toString() ?? 'لاعب',
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(id,
                          style: const TextStyle(color: Colors.white38)),
                      onChanged: (v) => setDialogState(() {
                        if (v == true) {
                          selected.add(id);
                        } else {
                          selected.remove(id);
                        }
                      }),
                    );
                  }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: selected.isEmpty
                  ? null
                  : () async {
                      await SocialStorage.createGroup(
                        name: nameController.text,
                        memberIds: [widget.playerId, ...selected],
                      );
                      if (mounted) Navigator.pop(context);
                      await _load();
                      _message('تم إنشاء الغروب.');
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: Colors.black,
              ),
              child: const Text('إنشاء'),
            ),
          ],
        ),
      ),
    );
  }

  void _openChat(String id, String name, {bool group = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          chatId: id,
          title: name,
          senderName: widget.playerName,
          isGroup: group,
        ),
      ),
    );
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, textAlign: TextAlign.center,
            textDirection: TextDirection.rtl),
        backgroundColor: const Color(0xFF181818),
        behavior: SnackBarBehavior.floating,
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
          title: const Text('الأصدقاء والشات',
              style: TextStyle(color: gold, fontWeight: FontWeight.w900)),
          actions: [
            IconButton(
              tooltip: 'نزال بالكود',
              icon: const Icon(Icons.sports_mma_rounded, color: gold),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BattleCodeScreen(
                    playerName: widget.playerName,
                    playerId: widget.playerId,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: 'إضافة صديق',
              icon: const Icon(Icons.person_add_alt_1_rounded, color: gold),
              onPressed: _addFriend,
            ),
          ],
          bottom: TabBar(
            controller: _tabs,
            indicatorColor: gold,
            labelColor: gold,
            unselectedLabelColor: Colors.white54,
            tabs: const [
              Tab(text: 'الأصدقاء'),
              Tab(text: 'الطلبات'),
              Tab(text: 'الغروبات'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabs,
          children: [
            RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_friends.isEmpty)
                    _empty('لا توجد أصدقاء بعد', Icons.people_outline_rounded),
                  ..._friends.map((f) => _personTile(
                        id: f['id'].toString(),
                        name: f['name']?.toString() ?? 'لاعب',
                      )),
                ],
              ),
            ),
            RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_requests.isEmpty)
                    _empty('لا توجد طلبات صداقة', Icons.inbox_outlined),
                  ..._requests.map((r) => _requestTile(r)),
                ],
              ),
            ),
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _createGroup,
                    icon: const Icon(Icons.group_add_rounded),
                    label: const Text('إنشاء غروب جديد'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                if (_groups.isEmpty)
                  _empty('لم تنشئ أي غروب بعد', Icons.groups_outlined),
                ..._groups.map((g) => Card(
                      color: const Color(0xFF0D0D0D),
                      child: ListTile(
                        onTap: () => _openChat(
                          g['id'].toString(),
                          g['name']?.toString() ?? 'غروب',
                          group: true,
                        ),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF171717),
                          child: Icon(Icons.groups_rounded, color: gold),
                        ),
                        title: Text(g['name']?.toString() ?? 'غروب',
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(
                          '${(g['members'] as List?)?.length ?? 0} أعضاء',
                          style: const TextStyle(color: Colors.white38),
                        ),
                        trailing: const Icon(Icons.chevron_left_rounded,
                            color: Colors.white38),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _personTile({required String id, required String name}) {
    return Card(
      color: const Color(0xFF0D0D0D),
      child: ListTile(
        onTap: () => _openChat(id, name),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF171717),
          child: Icon(Icons.person_rounded, color: gold),
        ),
        title: Text(name,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(id, style: const TextStyle(color: Colors.white38)),
        trailing: const Icon(Icons.chat_bubble_outline_rounded,
            color: gold),
      ),
    );
  }

  Widget _requestTile(Map<String, dynamic> r) {
    return Card(
      color: const Color(0xFF0D0D0D),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF171717),
          child: Icon(Icons.person_add_rounded, color: gold),
        ),
        title: Text(r['name']?.toString() ?? 'لاعب',
            style: const TextStyle(color: Colors.white)),
        subtitle: Text(r['id'].toString(),
            style: const TextStyle(color: Colors.white38)),
        trailing: Wrap(
          children: [
            IconButton(
              tooltip: 'قبول',
              onPressed: () async {
                await SocialStorage.acceptRequest(r);
                await _load();
              },
              icon: const Icon(Icons.check_circle_rounded,
                  color: Colors.greenAccent),
            ),
            IconButton(
              tooltip: 'رفض',
              onPressed: () async {
                await SocialStorage.rejectRequest(r['id'].toString());
                await _load();
              },
              icon: const Icon(Icons.cancel_rounded, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: Column(
        children: [
          Icon(icon, color: Colors.white24, size: 60),
          const SizedBox(height: 12),
          Text(text,
              style: const TextStyle(color: Colors.white54, fontSize: 16)),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String title;
  final String senderName;
  final bool isGroup;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.title,
    required this.senderName,
    this.isGroup = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const gold = Color(0xFFFFC83D);
  final controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final data = await SocialStorage.chatMessages(widget.chatId);
    if (!mounted) return;
    setState(() => messages = data);
  }

  Future<void> _send() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    controller.clear();
    await SocialStorage.sendMessage(
      chatId: widget.chatId,
      senderName: widget.senderName,
      text: text,
      isGroup: widget.isGroup,
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(widget.title,
              style: const TextStyle(color: gold)),
        ),
        body: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? const Center(
                      child: Text('لا توجد رسائل بعد',
                          style: TextStyle(color: Colors.white38)))
                  : ListView.builder(
                      reverse: false,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (_, i) {
                        final m = messages[i];
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 320),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF151108),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF6F520D)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (widget.isGroup)
                                  Text(m['senderName']?.toString() ?? '',
                                      style: const TextStyle(
                                          color: gold, fontSize: 11)),
                                Text(m['text']?.toString() ?? '',
                                    style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        minLines: 1,
                        maxLines: 4,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالة...',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF0D0D0D),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _send,
                      style: IconButton.styleFrom(
                        backgroundColor: gold,
                        foregroundColor: Colors.black,
                      ),
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
