/// Represents broadcast status
enum BroadcastStatus {
  active('active'),
  inactive('inactive');

  const BroadcastStatus(this.value);

  final String value;

  static BroadcastStatus fromJson(String value) => switch (value) {
    'active' => BroadcastStatus.active,
    'inactive' => BroadcastStatus.inactive,
    _ => throw Exception('Invalid broadcast status: $value'),
  };

  static String toJson(BroadcastStatus status) => status.value;
}
