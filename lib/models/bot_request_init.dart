class BotRequestInit {
  final String mainKey;

  const BotRequestInit({
    required this.mainKey
  });

  factory BotRequestInit.fromJson(Map<String, dynamic> json) {
    return BotRequestInit(mainKey: json['MainKey']);
  }

  Map<String, dynamic> toJson() => {
    "MainKey" : mainKey
  };
}