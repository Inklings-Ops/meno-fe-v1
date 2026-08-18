import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/notes/services/_services.dart';

final class NoteActionsManager with MLogger implements Disposable {
  NoteActionsManager({
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
  // NOTE LIFECYCLE
  // =========================================================================
  /// Deletes a note.
  late final deleteNote = Command.createAsyncNoResult<Id>((noteId) async {
    final remoteId = noteId.getOrCrash();
    _local.deleteNoteByRemoteId(remoteId);
    await _http.deleteNote(remoteId);
  }, errorFilterFn: (e, _) => ErrorReaction.globalHandler);

  // =========================================================================
  // SINGLE-NOTE FOLDER RELATIONS
  // =========================================================================

  /// Can be used to add notes to a folder and to move notes from a folder to
  /// the target folder
  late final assignNotesToFolder = Command.createAsyncNoResult((
    ({List<Id> noteIds, Id targetFolderId}) args,
  ) async {
    if (args.noteIds.isEmpty) throw const MenoException('No notes selected');

    final remoteFolderId = args.targetFolderId.getOrCrash();

    _local.batchAssignNotesToFolder(
      remoteFolderId: remoteFolderId,
      remoteNoteIds: args.noteIds.map((id) => id.getOrCrash()).toList(),
    );

    final result = await Future.wait<(Id, dynamic)>(
      args.noteIds.map((noteId) async {
        try {
          final dto = await _http.addNoteToFolder(
            ownerId: _ownerId,
            noteId: noteId.getOrCrash(),
            folderId: remoteFolderId,
          );

          _local.upsertNote(dto);

          // We simply just return a Record of the note's id and a null error
          return (noteId, null);
        } catch (e) {
          log.w('addNotesToFolder: ${noteId.getOrCrash()} failed — $e');
          // We also return a record of the note that failed and the error
          return (noteId, e);
        }
      }),
    );

    final succeededIds = <Id>[];
    final failedIds = <Id>[];

    for (final (id, error) in result) {
      error == null ? succeededIds.add(id) : failedIds.add(id);
    }

    if (failedIds.isNotEmpty) {
      final count = failedIds.length;
      throw MenoException(
        '$count note${count == 1 ? '' : 's'} could not sync '
        'and will retry automatically.',
      );
    }
  }, errorFilterFn: (e, _) => ErrorReaction.globalHandler);

  late final removeNotesFromFolder = Command.createAsyncNoResult((
    ({List<Id> noteIds, Id folderId}) args,
  ) async {
    if (args.noteIds.isEmpty) throw const MenoException('No notes selected');

    final remoteNoteIds = args.noteIds.map((id) => id.getOrCrash()).toList();

    _local.batchRemoveNotesFromFolder(remoteNoteIds);

    final result = await Future.wait<(Id, dynamic)>(
      args.noteIds.map((noteId) async {
        try {
          await _http.removeNoteFromFolder(
            noteId: noteId.getOrCrash(),
            folderId: args.folderId.getOrCrash(),
          );

          final existing = _local.findNoteByRemoteId(noteId.getOrCrash());
          if (existing != null) _local.upsertNote(existing);

          // We simply just return a Record of the note's id and a null error
          return (noteId, null);
        } catch (e) {
          log.w('removeNotesFromFolder: ${noteId.getOrCrash()} failed — $e');
          // We also return a record of the note that failed and the error
          return (noteId, e);
        }
      }),
    );

    final succeededIds = <Id>[];
    final failedIds = <Id>[];

    for (final (id, error) in result) {
      error == null ? succeededIds.add(id) : failedIds.add(id);
    }

    if (failedIds.isNotEmpty) {
      final count = failedIds.length;
      throw MenoException(
        '$count note${count == 1 ? '' : 's'} could not sync '
        'and will retry automatically.',
      );
    }
  }, errorFilterFn: (e, _) => ErrorReaction.globalHandler);

  @override
  FutureOr<dynamic> onDispose() {
    log.d('NoteActionsManager: Disposing...');

    deleteNote.dispose();
    assignNotesToFolder.dispose();
    removeNotesFromFolder.dispose();
  }
}
