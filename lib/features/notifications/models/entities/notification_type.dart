enum NotificationType {
  userSubscribed('userSubscribed'),
  addedAsCoHost('addedAsCoHost'),
  liveBroadcastStarted('liveBroadcastStarted');

  const NotificationType(this.value);

  factory NotificationType.fromJson(String json) {
    return switch (json) {
      'userSubscribed' => .userSubscribed,
      'addedAsCoHost' => .addedAsCoHost,
      'liveBroadcastStarted' => .liveBroadcastStarted,
      _ => throw Exception('Unknown value'),
    };
  }

  final String value;
}
