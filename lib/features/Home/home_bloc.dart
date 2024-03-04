import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:open_ai_bot/Services/speech_service.dart';
import 'package:open_ai_bot/constants/constants.dart';
import 'package:open_ai_bot/models/bot_response_activity.dart';
import 'package:open_ai_bot/Services/bot_service.dart';
import 'package:open_ai_bot/features/Home/home_events.dart';
import 'package:open_ai_bot/features/Home/home_state.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  late final BotService botService;
  late final SpeechService speechService;
  late final SpeechToText stt;
  late final String token;
  String recognizedText = "";
  final FlutterSoundPlayer mPlayer = FlutterSoundPlayer();
  StreamSubscription? mPlayerSubscription;

  HomeBloc(this.botService, this.speechService) : super(HomeState.initial()) {
    on<WaitingForUserEvent>((event, emit) => waitingForUserToState(emit));
    on<StartRecordingEvent>((event, emit) => startRecordingToState(emit));
    on<StopRecordingEvent>((event, emit) => stopRecordingToState(emit));
    on<SpeakResponseFromBotEvent>((event, emit) => speakResponseFromBotToState(emit));

    initSTT();
    initTTS();
    botService.initConversation();
  }

  Future waitingForUserToState(emit) async {
    emit(state.copyWith(waiting: true, recording: false, thinking: false, speaking: false));
  }

  Future startRecordingToState(emit) async {
    emit(state.copyWith(waiting: false, recording: true, thinking: false, speaking: false));
    await startListening();
  }

  Future stopRecordingToState(emit) async {
    emit(state.copyWith(waiting: false, recording: false, thinking: true, speaking: false));
    await stopListening();
  }

  Future speakResponseFromBotToState(emit) async {
    emit(state.copyWith(waiting: false, recording: false, thinking: false, speaking: true));
  }

  Future initSTT() async {
    stt = SpeechToText();
    await stt.initialize(onError: errorListener, onStatus: statusListener);
  }

  Future initTTS() async {
    var initSuccess = await speechService.init();
    if (initSuccess) {
      await mPlayer.openPlayer();
      await mPlayer.startPlayerFromStream(codec: Codec.pcm16, numChannels: 1, sampleRate: sampleRate);
    }
  }

  Future startListening() async {
    recognizedText = "";
    stt.listen(onResult: resultListener );
  }

  Future stopListening() async {
    stt.stop();
  }

  void statusListener(String status) async {
    if (status == "done") {
      BotResponseActivity result = await botService.sendMessage(recognizedText);
      add(StopRecordingEvent());
      if (result.activityId != "") {
        var responses = await botService.getResponses(result.activityId);
        if (responses.isNotEmpty) {
          for (var element in responses) {
            var responseFromSpeech = await speechService.textToSpeech(element.message);
            add(SpeakResponseFromBotEvent());
            feedAudioToPlayer(responseFromSpeech);
            mPlayer.foodSink!.add(FoodEvent(() async {
              add(WaitingForUserEvent());
            }));
          }
        }
      } else {
        add(WaitingForUserEvent());
      }
    }
  }

  void errorListener(SpeechRecognitionError error) {
  }

  void resultListener(SpeechRecognitionResult result) {
    if (result.recognizedWords != "") {
      recognizedText = " ${result.recognizedWords}";
    }
  }

  void feedAudioToPlayer(Uint8List data) {
    var start = 0;
    var totalLength = data.length;
    while (totalLength > 0 && !mPlayer.isStopped) {
      var ln = totalLength > blockSize ? blockSize : totalLength;
      mPlayer.foodSink!.add(FoodData(data.sublist(start, start + ln)));
      totalLength -= ln;
      start += ln;
    }
  }
}

extension CopyWith on HomeState {
  HomeState copyWith({
    bool? waiting,
    bool? recording,
    bool? thinking,
    bool? speaking,
  }) {
    return HomeState(
      waiting: waiting ?? this.waiting,
      recording: recording ?? this.recording,
      thinking: thinking ?? this.thinking,
      speaking: speaking ?? this.speaking,
    );
  }
}