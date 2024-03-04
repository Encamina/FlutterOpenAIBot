class HomeState {
  final bool waiting;
  final bool recording;
  final bool thinking;
  final bool speaking;

  HomeState({
    required this.waiting,
    required this.recording,
    required this.thinking,
    required this.speaking});

  factory HomeState.initial() {
    return HomeState(waiting: true, recording: false, thinking: false, speaking: false);
  }
}