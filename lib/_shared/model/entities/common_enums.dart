enum OrderBy {
  asc('ASC'),
  desc('DESC');

  const OrderBy(this.value);

  final String value;

  static OrderBy? fromString(String? value) {
    if (value == null) return null;
    try {
      return OrderBy.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum SyncStatus {
  synced('synced'),
  pending('pending'),
  conflict('conflict');

  const SyncStatus(this.value);

  final String value;

  static SyncStatus fromBool(bool syncPending) =>
      syncPending ? SyncStatus.pending : SyncStatus.synced;
}

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
