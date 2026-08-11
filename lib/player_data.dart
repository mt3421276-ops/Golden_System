class PlayerData {
  final String playerName;
  final String characterName;
  final String playerId;
  final String email;
  final String password;
  final bool registered;
  final String? profileImagePath;
  final String? licenseImagePath;

  PlayerData({
    required this.playerName,
    required this.characterName,
    required this.playerId,
    required this.email,
    required this.password,
    this.registered = false,
    this.profileImagePath,
    this.licenseImagePath,
  });

  // تحويل من Map إلى كائن
  factory PlayerData.fromMap(Map<String, dynamic> map) {
    return PlayerData(
      playerName: map['playerName'] ?? '',
      characterName: map['characterName'] ?? '',
      playerId: map['playerId'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      registered: map['registered'] ?? false,
      profileImagePath: map['profileImagePath'],
      licenseImagePath: map['licenseImagePath'],
    );
  }

  // تحويل من كائن إلى Map
  Map<String, dynamic> toMap() {
    return {
      'playerName': playerName,
      'characterName': characterName,
      'playerId': playerId,
      'email': email,
      'password': password,
      'registered': registered,
      'profileImagePath': profileImagePath,
      'licenseImagePath': licenseImagePath,
    };
  }

  // نسخة معدلة من الكائن
  PlayerData copyWith({
    String? playerName,
    String? characterName,
    String? playerId,
    String? email,
    String? password,
    bool? registered,
    String? profileImagePath,
    String? licenseImagePath,
  }) {
    return PlayerData(
      playerName: playerName ?? this.playerName,
      characterName: characterName ?? this.characterName,
      playerId: playerId ?? this.playerId,
      email: email ?? this.email,
      password: password ?? this.password,
      registered: registered ?? this.registered,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      licenseImagePath: licenseImagePath ?? this.licenseImagePath,
    );
  }
}