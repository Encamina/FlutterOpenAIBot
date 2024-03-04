import 'bot_user.dart';

class BotResponseActivityMessage {
  final String activityId;
  final String conversationId;
  final String replyToActivityId;
  final String type;
  final String locale;
  final BotUser user;
  final String message;

  BotResponseActivityMessage({
    required this.activityId,
    required this.conversationId,
    required this.replyToActivityId,
    required this.type,
    required this.locale,
    required this.user,
    required this.message
  });

  factory BotResponseActivityMessage.fromJson(Map<String, dynamic> json) {
    return BotResponseActivityMessage(activityId: json["id"], conversationId: json["conversation"]["id"], replyToActivityId: json.containsKey("replyToId") ? json["replyToId"] : "", type: json["type"], locale: json["locale"], user: BotUser.fromJson(json["from"]), message: json["text"]);
  }
}