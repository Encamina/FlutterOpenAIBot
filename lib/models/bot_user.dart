class BotUser {
  final String id;

  BotUser({
    required this.id
  });

  factory BotUser.fromJson(Map<String, dynamic> json) {
    return BotUser(id: json['id']);
  }

  Map<String, dynamic> toJson() => {
    "id" : id
  };
}