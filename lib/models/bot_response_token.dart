class BotResponseToken {
  final String conversationId;
  final String conversationToken;
  final int expirationDate;

  const BotResponseToken({
    required this.conversationId,
    required this.conversationToken,
    required this.expirationDate
  });

  factory BotResponseToken.fromJson(Map<String, dynamic> json) {
    return BotResponseToken(conversationId: json['conversationId'], conversationToken: json['token'], expirationDate: json['expires_in']);
  }
}