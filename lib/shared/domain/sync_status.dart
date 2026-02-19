enum SyncStatus { synced, pending, conflict }

extension SyncStatusX on SyncStatus {
  bool get isSynced => this == SyncStatus.synced;

  bool get isPending => this == SyncStatus.pending;

  bool get isConflict => this == SyncStatus.conflict;
}
