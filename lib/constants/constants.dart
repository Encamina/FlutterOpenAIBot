//BOT CONSTANTS
const String contentType = "application/json";
const String botUri = "directline.botframework.com";
const String initConversationPath = "api/conversations";
const String senMessageFirstPath = "v3/directline/conversations";
const String senMessageSecondPath = "activities";
const String botApiKey = "[PUT HERE YOUR DIRECTLINE API KEY]";  

//SPEECH SERVICE CONSTANTS
const String authHost = "[PUT HERE YOUR SPEECH REGION].api.cognitive.microsoft.com";
const String authPath = "sts/v1.0/issueToken";
const String voiceHost = "[PUT HERE YOUR SPEECH REGION].tts.speech.microsoft.com";
const String voicePath = "cognitiveservices/v1";
const String speechApiKey = "[PUT HERE YOUR SPEECH SERVICE API KEY]";

//PLAYER VALUES
const int sampleRate = 44100;
const int blockSize = 32768;
