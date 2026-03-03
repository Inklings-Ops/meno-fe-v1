enum NotificationType {
  userSubscribed('userSubscribed'),
  addedAsCoHost('addedAsCoHost'),
  liveBroadcastStarted('liveBroadcastStarted');

  const NotificationType(this.value);

  factory NotificationType.fromJson(dynamic value) {
    if (value is! String) throw const FormatException('Invalid type');
    return switch (value) {
      'userSubscribed' => userSubscribed,
      'addedAsCoHost' => addedAsCoHost,
      'liveBroadcastStarted' => liveBroadcastStarted,
      _ => throw const FormatException('Invalid value'),
    };
  }

  final String value;

  String toJson() => value;
}
