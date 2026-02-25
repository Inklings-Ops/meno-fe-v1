import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

class NoteActionsManager with MLogger implements Disposable {
  NoteActionsManager(this._repository);

  final INotesRepository _repository;

  // =========================================================================
  // NOTE LIFECYCLE
  // =========================================================================
  /// Deletes a note.
  late final deleteNote = Command.createAsync<Id, bool?>(
    (noteId) async {
      final result = await _repository.deleteNote(noteId);
      return result.fold((failure) => throw failure, (_) => true);
    },
    initialValue: null,
    errorFilterFn: (e, _) => ErrorReaction.globalHandler,
  );

  // =========================================================================
  // SINGLE-NOTE FOLDER RELATIONS
  // =========================================================================

  /// Can be used to add notes to a folder and to move notes from a folder to
  /// the target folder
  late final assignNotesToFolder = Command.createAsyncNoResult((
    ({List<Id> noteIds, Id targetFolderId}) args,
  ) async {
    if (args.noteIds.isEmpty) throw const MenoException('No notes selected');

    final result = await _repository.assignNotesToFolder(
      noteIds: args.noteIds,
      folderId: args.targetFolderId,
    );

    if (result.hasFailures) {
      final count = result.failedIds.length;
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

    final result = await _repository.unassignNotesFromFolder(
      noteIds: args.noteIds,
      folderId: args.folderId,
    );

    if (result.hasFailures) {
      final count = result.failedIds.length;
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
