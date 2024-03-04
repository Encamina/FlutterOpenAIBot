import 'dart:convert';
import 'dart:io';
import 'package:open_ai_bot/constants/constants.dart';
import 'package:open_ai_bot/models/bot_request_init.dart';
import 'package:open_ai_bot/models/bot_request_message.dart';
import 'package:open_ai_bot/models/bot_response_activity.dart';
import 'package:open_ai_bot/models/bot_response_activity_messages.dart';
import 'package:open_ai_bot/models/bot_user.dart';
import 'package:http/http.dart' as http;
import 'package:open_ai_bot/models/bot_response_token.dart';

class BotService {
  BotResponseToken? botToken;

  BotService();

  Future<bool> initConversation() async {
    var response = await http.post(Uri.https(botUri, initConversationPath), 
                                   headers: generateHeaders(), 
                                   body: jsonEncode(const BotRequestInit(mainKey: "").toJson()));
    if (response.statusCode == 200) {
      botToken = BotResponseToken.fromJson(jsonDecode(response.body));
      return true;
    }

    return false;
  }

  Future<BotResponseActivity> sendMessage(String message) async {
    var response = await http.post(Uri.https(botUri, "$senMessageFirstPath/${botToken?.conversationId}/$senMessageSecondPath"), 
                                   headers: generateHeaders(), 
                                   body: jsonEncode(BotRequestMessage(locale: "es-ES", type: "message", message: message, user: BotUser(id: "appuser"))));
    if (response.statusCode == 200) {
      return BotResponseActivity.fromJson(jsonDecode(response.body));
    }
    return BotResponseActivity(activityId: "");
  }

  Future<List<BotResponseActivityMessage>> getBotMessages() async {
    var response = await http.get(Uri.https(botUri, "$senMessageFirstPath/${botToken?.conversationId}/$senMessageSecondPath"), 
                                   headers: generateHeaders());

    if (response.statusCode == 200) {
      var listOfResponses = List<BotResponseActivityMessage>.from(jsonDecode(response.body)["activities"].map((data) => BotResponseActivityMessage.fromJson(data)));

      return listOfResponses.where((element) => element.replyToActivityId == "").toList(growable: false);
    }
    return List<BotResponseActivityMessage>.empty();
  }

  Future<List<BotResponseActivityMessage>> getResponses(String activity) async {
    var response = await http.get(Uri.https(botUri, "$senMessageFirstPath/${botToken?.conversationId}/$senMessageSecondPath"), 
                                   headers: generateHeaders());

    if (response.statusCode == 200) {
      var listOfResponses = List<BotResponseActivityMessage>.from(jsonDecode(response.body)["activities"].map((data) => BotResponseActivityMessage.fromJson(data)));

      return listOfResponses.where((element) => element.replyToActivityId == activity).toList(growable: false);
    }
    return List<BotResponseActivityMessage>.empty();
  }

  Map<String, String> generateHeaders() {
    return {HttpHeaders.contentTypeHeader: contentType, 
            HttpHeaders.authorizationHeader: "Bearer ${getToken()}"};
  }

  String? getToken() {
    if (botToken == null) {
      return botApiKey;
    } else {
      return botToken?.conversationToken;
    }
  }
}
