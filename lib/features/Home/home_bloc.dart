import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';
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

  HomeBloc(this.botService, this.speechService) : super(HomeState.initial()) {
    on<WaitingForUserEvent>((event, emit) => waitingForUserToState(emit));
    on<StartRecordingEvent>((event, emit) => startRecordingToState(emit));
    on<StopRecordingEvent>((event, emit) => stopRecordingToState(emit));
    on<SpeakResponseFromBotEvent>((event, emit) => speakResponseFromBotToState(emit));

    initSTT();
    initTTS();
    initAudioPlayer();
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
    await speechService.init();
  }

  Future initAudioPlayer() async {
      var session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(avAudioSessionCategory: AVAudioSessionCategory.playAndRecord, avAudioSessionMode: AVAudioSessionMode.spokenAudio));
      await session.setActive(true);
      await FlutterPcmSound.setup(sampleRate: sampleRate, channelCount: 1);
      await FlutterPcmSound.setFeedThreshold(1);
  }

  Future startListening() async {
    recognizedText = "";
    stt.listen(onResult: resultListener, pauseFor: const Duration(seconds: 2) );
  }

  Future stopListening() async {
    stt.stop();
  }

  void statusListener(String status) async {
    if (status == "done" && recognizedText != "" && Platform.isAndroid) {
      processResponse();
    } else if (status == "done" && recognizedText == "") {
      add(WaitingForUserEvent());
    }
  }

  Future processResponse() async {
      BotResponseActivity result = await botService.sendMessage(recognizedText);
      recognizedText = "";
      add(StopRecordingEvent());
      if (result.activityId != "") {
        var responses = await botService.getResponses(result.activityId);
        if (responses.isNotEmpty) {
          for (var element in responses) {
            var responseFromSpeech = await speechService.textToSpeech(element.message);
            add(SpeakResponseFromBotEvent());
            await playAudioResponse(responseFromSpeech);
            add(WaitingForUserEvent());
          }
        }
      } else {
        add(WaitingForUserEvent());
      }
  }

  Future playAudioResponse(Uint8List responseFromSpeech) async {
    var audio = responseFromSpeech.buffer.asInt16List(0);
    await FlutterPcmSound.feed(PcmArrayInt16.fromList(audio));
    await FlutterPcmSound.play();
    var remainingFrames = await FlutterPcmSound.remainingFrames();
    while (remainingFrames > 0) {
      remainingFrames = await FlutterPcmSound.remainingFrames();
    }
    await FlutterPcmSound.stop();
    await FlutterPcmSound.clear();
  }

  void errorListener(SpeechRecognitionError error) {
  }

  void resultListener(SpeechRecognitionResult result) {
    if (result.recognizedWords != "") {
      recognizedText = " ${result.recognizedWords}";
      if (result.finalResult && Platform.isIOS) {
        processResponse();
      }
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