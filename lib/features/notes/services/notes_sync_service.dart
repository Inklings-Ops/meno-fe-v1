import 'dart:async';

import 'package:meno/_core/_core.dart';
import 'package:meno/features/notes/model/_model.dart';
import 'package:meno/features/notes/services/_services.dart';

class NotesSyncService with MLogger {
  NotesSyncService({
    required NotesHttpService http,
    required NotesLocalService local,
    required Id currentUserId,
  }) : _http = http,
       _local = local,
       _ownerId = currentUserId.getOrCrash();

  final NotesHttpService _http;
  final NotesLocalService _local;
  final String _ownerId;

  // =========================================================================
  // RETRY PENDING SYNC
  // =========================================================================

  Future<void> retryPendingSync() async {
    try {
      await Future.wait([_retryPendingNotes(), _retryPendingFolders()]);
    } catch (error) {
      log.e('retryPendingSync: failed — $error');
      rethrow;
    }
  }

  Future<void> _retryPendingNotes() async {
    final pendingDtos = _local.getPendingNotes(_ownerId);
    log.d('NotesSyncService: ${pendingDtos.length} pending note(s)');

    for (final dto in pendingDtos) {
      try {
        // createdAt == null means the server has never confirmed this note.
        final isNew = dto.createdAt == null;

        final confirmed = isNew
            ? await _http.createNote(ownerId: _ownerId, dto: dto)
            : await _http.updateNote(ownerId: _ownerId, dto: dto);

        // For new notes the server may assign a different canonical id —
        // delete the client-id row before upserting the confirmed one.
        if (isNew) _local.deleteNoteByRemoteId(dto.id);
        _local.upsertNote(confirmed);
      } catch (e) {
        // Skip this record and continue — do not rethrow.
        log.w('NotesSyncService._retryPendingNotes: skipping ${dto.id} — $e');
      }
    }
  }

  Future<void> _retryPendingFolders() async {
    final pendingFoldersDtos = _local.getPendingFolders(_ownerId);
    log.d('NotesSyncService: ${pendingFoldersDtos.length} pending folder(s)');

    for (final dto in pendingFoldersDtos) {
      try {
        final isNew = dto.createdAt == null;

        final confirmed = isNew
            ? await _http.createFolder(ownerId: _ownerId, dto: dto)
            : await _http.updateFolder(ownerId: _ownerId, dto: dto);

        if (isNew) _local.deleteFolderByRemoteId(dto.id);
        _local.upsertFolder(confirmed.toDto(ownerId: _ownerId));
      } catch (e) {
        // Skip this record and continue — do not rethrow.
        log.w('NotesSyncService._retryPendingFolders: skipping ${dto.id} — $e');
      }
    }
  }
}
