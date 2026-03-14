import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/notes/model/_model.dart';
import 'package:meno/objectbox.g.dart';

class NotesLocalService with MLogger {
  const NotesLocalService(this._db);

  final Database _db;

  // Convenience getters — boxes are cheap accessors on the store.
  Box<NoteDto> get _notes => _db.noteBox;

  Box<NoteFolderDto> get _folders => _db.noteFolderBox;

  Box<NoteCreatorDto> get _creators => _db.noteCreatorBox;

  // ========================================================================
  // NOTES — STREAMS
  // ========================================================================
  /// Live stream of notes, rebuilt whenever any [NoteDto] changes.
  Stream<List<NoteDto>> watchNotes({
    required String ownerId,
    String? keywords,
    bool? pinned,
  }) {
    return _buildNoteQuery(
      ownerId: ownerId,
      keywords: keywords,
      pinned: pinned,
    ).watch(triggerImmediately: true).map((query) => query.find());
  }

  /// Live stream of all notes that belong to a specific folder.
  Stream<List<NoteDto>> watchNotesInFolder({
    required String folderId,
    required String ownerId,
    String? keywords,
  }) {
    final result = _buildNoteQuery(ownerId: ownerId, keywords: keywords);
    result.link(NoteDto_.folder, NoteFolderDto_.id.equals(folderId));

    return result
        .order(NoteDto_.updatedAt, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  // ========================================================================
  // NOTES — READS
  // ========================================================================
  NoteDto? findNoteByRemoteId(String remoteId) =>
      _notes.query(NoteDto_.id.equals(remoteId)).build().findFirst();

  List<NoteDto> getPendingNotes(String ownerId) => _notes
      .query(
        NoteDto_.ownerId.equals(ownerId) & NoteDto_.syncPending.equals(true),
      )
      .build()
      .find();

  // ========================================================================
  // NOTES — WRITES
  // ========================================================================
  /// Upserts a single note inside a write transaction.
  int upsertNote(NoteDto dto) {
    return _db.runWriteTx(() {
      _prepareNote(dto);
      return _notes.put(dto);
    });
  }

  /// Bulk upsert in a single write transaction.
  void upsertNotes(List<NoteDto> dtos) {
    _db.runWriteTx(() {
      for (final dto in dtos) {
        _prepareNote(dto);
      }
      _notes.putMany(dtos);
    });
  }

  void deleteNoteByRemoteId(String remoteId) {
    final existing = findNoteByRemoteId(remoteId);
    if (existing != null) _notes.remove(existing.dbId);
  }

  void markNoteSynced(String remoteId) {
    final existing = findNoteByRemoteId(remoteId);
    if (existing == null) return;
    existing.syncPending = false;
    _notes.put(existing);
  }

  void batchAssignNotesToFolder({
    required List<String> remoteNoteIds,
    required String remoteFolderId,
  }) {
    final folderDto = findFolderByRemoteId(remoteFolderId);

    // Nothing to wire against; bail early rather than writing garbage.
    if (folderDto == null) {
      throw const MenoException('Folder not found, skipping optimistic write');
    }

    _db.runWriteTx(() {
      _mergeFolderDbId(folderDto);
      final notesToUpdate = <NoteDto>[];
      for (final remoteId in remoteNoteIds) {
        final noteDto = findNoteByRemoteId(remoteId);

        if (noteDto == null) {
          // Note note yet in local cache, so it is not an error, just skip.
          log.w('batchAssignNotesToFolder: $remoteId not found — skipping.');
          continue;
        }

        noteDto.folder.target = folderDto;
        noteDto.syncPending = true;
        notesToUpdate.add(noteDto);
      }

      if (notesToUpdate.isNotEmpty) _notes.putMany(notesToUpdate);
    });
  }

  void batchRemoveNotesFromFolder(List<String> remoteNoteIds) {
    _db.runWriteTx(() {
      final notesToUpdate = <NoteDto>[];
      for (final remoteId in remoteNoteIds) {
        final noteDto = findNoteByRemoteId(remoteId);

        if (noteDto == null) {
          // Note note yet in local cache, so it is not an error, just skip.
          log.w('batchRemoveNotesFromFolder: $remoteId not found — skipping.');
          continue;
        }

        if (noteDto.folder.target == null) continue;

        noteDto.folder.target = null;
        noteDto.syncPending = true;
        notesToUpdate.add(noteDto);
      }

      if (notesToUpdate.isNotEmpty) _notes.putMany(notesToUpdate);
    });
  }

  // ========================================================================
  // FOLDERS — STREAMS
  // ========================================================================
  Stream<List<NoteFolderDto>> watchFolders({
    required String ownerId,
    String? keywords,
  }) {
    var condition = NoteFolderDto_.ownerId.equals(ownerId);

    if (keywords != null && keywords.isNotEmpty) {
      condition =
          condition &
          NoteFolderDto_.title.contains(keywords, caseSensitive: false);
    }

    return _folders
        .query(condition)
        .order(NoteFolderDto_.createdAt, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Stream<NoteFolderDto?> watchFolder({
    required String ownerId,
    required String folderId,
  }) {
    return _folders
        .query(
          NoteFolderDto_.ownerId.equals(ownerId) &
              NoteFolderDto_.id.equals(folderId),
        )
        .watch(triggerImmediately: true)
        .map((query) => query.findFirst());
  }

  // ========================================================================
  // FOLDERS — READS
  // ========================================================================
  NoteFolderDto? findFolderByRemoteId(String remoteId) =>
      _folders.query(NoteFolderDto_.id.equals(remoteId)).build().findFirst();

  List<NoteFolderDto> getPendingFolders(String ownerId) => _folders
      .query(
        NoteFolderDto_.ownerId.equals(ownerId) &
            NoteFolderDto_.syncPending.equals(true),
      )
      .build()
      .find();

  // ========================================================================
  // FOLDERS — WRITES
  // ========================================================================
  int upsertFolder(NoteFolderDto dto) {
    return _db.runWriteTx(() {
      _mergeFolderDbId(dto);
      return _folders.put(dto);
    });
  }

  void upsertFolders(List<NoteFolderDto> dtos) {
    _db.runWriteTx(() {
      for (final dto in dtos) {
        _mergeFolderDbId(dto);
      }
      _folders.putMany(dtos);
    });
  }

  /// Persists the compound [FolderWithNotes] from the server in a single
  /// atomic write transaction.
  ///
  /// - Upserts the folder row.
  /// - Upserts every note in the payload, wiring each note's [NoteDto.folder]
  ///   ToOne to point at the same folder.
  /// - Notes returned by this endpoint do NOT carry a nested folder object
  ///   themselves (the server omits it to avoid circular JSON), so we wire
  ///   the relation manually here.
  void upsertFolderWithNotes(FolderWithNotes dto) {
    _db.runWriteTx(() {
      // 1. Upsert the folder first so its dbId is available.
      _mergeFolderDbId(dto.folder);
      _folders.put(dto.folder);

      // 2. Upsert each note, attaching the folder target.
      for (final note in dto.notes) {
        // Wire the ToOne — the folder is already in the box so ObjectBox
        // will write only the foreign-key column, not re-insert the folder.
        note.folder.target = dto.folder;
        _prepareNote(note);
      }
      _notes.putMany(dto.notes);
    });
  }

  /// Deletes a folder and detaches its notes atomically.
  void deleteFolderByRemoteId(String remoteId) {
    final existing = findFolderByRemoteId(remoteId);
    if (existing == null) return;

    _db.runWriteTx(() {
      final orphansQuery = _notes.query();
      orphansQuery.link(NoteDto_.folder, NoteFolderDto_.id.equals(remoteId));

      final orphans = orphansQuery.build().find();

      for (final note in orphans) {
        note.folder.target = null;
      }
      _notes.putMany(orphans);
      _folders.remove(existing.dbId);
    });
  }

  void markFolderSynced(String remoteId) {
    final existing = findFolderByRemoteId(remoteId);
    if (existing == null) return;
    existing.syncPending = false;
    _folders.put(existing);
  }

  // ========================================================================
  // CLEAR
  // ========================================================================

  /// Removes only the rows belonging to [ownerId].
  /// Called when removing an account from the device.
  void clearForUser(String ownerId) {
    _db.runWriteTx(() {
      final noteIds = _notes
          .query(NoteDto_.ownerId.equals(ownerId))
          .build()
          .findIds();
      _notes.removeMany(noteIds);

      final folderIds = _folders
          .query(NoteFolderDto_.ownerId.equals(ownerId))
          .build()
          .findIds();
      _folders.removeMany(folderIds);
    });
  }

  // ========================================================================
  // PRIVATE HELPERS
  // ========================================================================

  /// Prepares a [NoteDto] for upsert:
  ///   1. Upserts creator target → valid dbId.
  ///   2. Upserts folder target  → valid dbId.
  ///   3. Resolves the note's own dbId from the existing row (if any).
  ///
  /// Must be called inside a write transaction.
  void _prepareNote(NoteDto note) {
    final creatorTarget = note.creator.target;
    if (creatorTarget != null) {
      _upsertNoteCreator(creatorTarget);
      note.creator.target = creatorTarget;
    }

    final folderTarget = note.folder.target;
    if (folderTarget != null) {
      _mergeFolderDbId(folderTarget);
      _folders.put(folderTarget);
      note.folder.target = folderTarget;
    }

    final existing = findNoteByRemoteId(note.id);
    if (existing != null) note.dbId = existing.dbId;
  }

  void _mergeFolderDbId(NoteFolderDto dto) {
    final existing = findFolderByRemoteId(dto.id);
    if (existing != null) dto.dbId = existing.dbId;
  }

  void _upsertNoteCreator(NoteCreatorDto creator) {
    final existing = _creators
        .query(NoteCreatorDto_.id.equals(creator.id))
        .build()
        .findFirst();
    if (existing != null) creator.dbId = existing.dbId;
    _creators.put(creator);
  }

  /// Builds a query for notes.
  QueryBuilder<NoteDto> _buildNoteQuery({
    required String ownerId,
    String? keywords,
    bool? pinned,
  }) {
    var condition = NoteDto_.ownerId.equals(ownerId);

    if (pinned != null) {
      condition = condition & NoteDto_.pinned.equals(pinned);
    }

    if (keywords != null && keywords.isNotEmpty) {
      final kwCondition = NoteDto_.title
          .contains(keywords, caseSensitive: false)
          .or(NoteDto_.content.contains(keywords, caseSensitive: false));
      condition = condition & kwCondition;
    }

    return _notes
        .query(condition)
        .order(NoteDto_.updatedAt, flags: Order.descending);
  }

  /// Removes all notes, folders, and creators from the local store.
  /// Called on logout before the user scope is destroyed.
  void clearAll() {
    _db.runWriteTx(() {
      _notes.removeAll();
      _folders.removeAll();
      _creators.removeAll();
    });
  }
}
