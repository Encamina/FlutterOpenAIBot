# open_ai_bot

A Flutter application to showcase how to interact with Azure DirectLine bot API and Azure Cognitive Services Speech Service API.

## Acknowledgements
In this project we use several packages from [pub.dev](https://pub.dev)

- [Bloc state management plugin](https://pub.dev/packages/bloc)
- [Lottie animation plugin purely written in Dart](https://pub.dev/packages/lottie)
- [Http plugin, future enabled](https://pub.dev/packages/http)
- [Get_it service locator plugin inspired in Splat](https://pub.dev/packages/get_it)
- [Speech_to_text plugin to access native capabilities](https://pub.dev/packages/speech_to_text)
- [Flutter_sound plugin to play streaming audio](https://pub.dev/packages/flutter_sound)

Lottie animations are free animations downloaded from [LottieFiles](https://lottiefiles.com/)

Thanks for all contributors to those amazin plugins for the work done.

## Support
This demo project is mainly **tested in Android**, but it will run **easily on iOS and Web** with little changes due to native speech to text changes. Other systems like **desktop would need extra** work as Flutter_sound plugin only supports mobile and web.

## Configuration
To test the project, you need to edit constants.dart and replace the dummy values with your own azure keys and URLs:

    //BOT CONSTANTS
    const String botApiKey = "[PUT HERE YOUR DIRECTLINE API KEY]";  

    //SPEECH SERVICE CONSTANTS
    const String authHost = "[PUT HERE YOUR SPEECH REGION].api.cognitive.microsoft.com";
    const String voiceHost = "[PUT HERE YOUR SPEECH REGION].tts.speech.microsoft.com";
    const String speechApiKey = "[PUT HERE YOUR SPEECH SERVICE API KEY]";

