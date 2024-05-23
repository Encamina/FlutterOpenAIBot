import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:open_ai_bot/constants/constants.dart';

class SpeechService {
  late final String token;

  SpeechService();

  Future<bool> init() async {
    var response = await http.post(Uri.https(authHost, authPath), headers: generateAuthHeaders(), body: "");
    if (response.statusCode == 200) {
      token = response.body;
      return true;
    }
    return false;
  }

  Future<Uint8List> textToSpeech(String textToRead) async {
    var response = await http.post(Uri.https(voiceHost, voicePath), headers: generateVoiceHeaders(), body: formatTextToRead(textToRead));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    return Uint8List(0);
  }


  String formatTextToRead(String textToRead) {
    return "<speak version='1.0' xml:lang='es-ES'><voice xml:lang='es-Es' xml:gender='Female' name='es-ES-ElviraNeural'><prosody rate='1.1'>$textToRead</prosody></voice></speak>";
  }

  Map<String, String> generateAuthHeaders() {
    return {HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded", 
            HttpHeaders.contentLengthHeader : "0",
            "Ocp-Apim-Subscription-Key": speechApiKey,
            "Host": authHost};
  }

  Map<String, String> generateVoiceHeaders() {
    return {HttpHeaders.contentTypeHeader: "application/ssml+xml", 
            HttpHeaders.authorizationHeader: "Bearer $token",
            HttpHeaders.userAgentHeader: "PropulsionBotDemoFlutter",
            "X-Microsoft-OutputFormat" : "riff-44100hz-16bit-mono-pcm",
            "Host": voiceHost};
  }
}