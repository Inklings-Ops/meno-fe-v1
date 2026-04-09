enum NotificationType {
  userSubscribed('userSubscribed'),
  addedAsCoHost('addedAsCoHost'),
  liveBroadcastStarted('liveBroadcastStarted');

  const NotificationType(this.value);

  factory NotificationType.fromJson(String? json) {
    return switch (json) {
      'userSubscribed' => .userSubscribed,
      'addedAsCoHost' => .addedAsCoHost,
      'liveBroadcastStarted' => .liveBroadcastStarted,
      _ => throw Exception('Unknown value'),
    };
  }

  static NotificationType? fromString(String? value) => switch (value) {
    'user_subscribed' => userSubscribed,
    'added_as_co_host' => addedAsCoHost,
    'live_broadcast_started' => liveBroadcastStarted,
    _ => null,
  };

  final String value;
}
