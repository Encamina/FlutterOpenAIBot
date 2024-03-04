import 'package:get_it/get_it.dart';
import 'package:open_ai_bot/Services/bot_service.dart';
import 'package:open_ai_bot/Services/speech_service.dart';
import 'package:open_ai_bot/features/Home/home_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  serviceLocator.registerLazySingleton(
    () => BotService(),
  );
  serviceLocator.registerLazySingleton(
    () => SpeechService(),
  );

  serviceLocator.registerFactory(
    () => HomeBloc(
      serviceLocator(),
      serviceLocator(),
    ),
  );
}