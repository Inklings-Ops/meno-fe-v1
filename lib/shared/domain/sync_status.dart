enum SyncStatus {
  synced('synced'),
  pending('pending'),
  conflict('conflict');

  const SyncStatus(this.value);

  static SyncStatus fromBool(bool syncPending) {
    return syncPending ? SyncStatus.pending : SyncStatus.synced;
  }

  final String value;
}

extension SyncStatusX on SyncStatus {
  bool get isSynced => this == SyncStatus.synced;

  bool get isPending => this == SyncStatus.pending;

  bool get isConflict => this == SyncStatus.conflict;
}
