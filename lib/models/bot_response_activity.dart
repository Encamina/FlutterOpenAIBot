class BotResponseActivity {
  final String activityId;


  BotResponseActivity({
    required this.activityId
  });

  factory BotResponseActivity.fromJson(Map<String, dynamic> json) {
    return BotResponseActivity(activityId: json["id"]);
  }
}