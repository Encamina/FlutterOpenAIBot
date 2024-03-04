import 'package:open_ai_bot/models/bot_user.dart';

class BotRequestMessage {
  final String locale;
  final String type;
  final String message;
  final BotUser user;

  BotRequestMessage({
    required this.locale,
    required this.type,
    required this.message,
    required this.user
  });

  factory BotRequestMessage.fromJson(Map<String, dynamic> json) {
    return BotRequestMessage(locale: json["locale"], type: json["type"], message: json["text"], user: BotUser.fromJson(json["from"]));
  }

  Map<String, dynamic> toJson() => {
    "locale" : locale,
    "type" : type,
    "text" : message,
    "from" : user.toJson()
  };
}