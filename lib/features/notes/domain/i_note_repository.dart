import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/domain/entities/entities.dart';
import 'package:meno/shared/domain/domain.dart';

abstract class INoteRepository implements Disposable {
  // =========================================================================
  // NOTES
  // =========================================================================
  /// Live stream of all notes from local DB, sorted by updatedAt DESC.
  Stream<List<Note>> watchNotes({String? keywords, bool? pinned});

  /// Optimistically creates locally, then syncs to remote.
  Future<Either<MenoException, Note>> createNote(Note note);

  /// Optimistically updates locally, then syncs to remote.
  Future<Either<MenoException, Note>> updateNote(Note note);

  /// Optimistically deletes locally, then syncs to remote.
  Future<Either<MenoException, Unit>> deleteNote(Id noteId);

  Future<Either<MenoException, Note>> addNoteToFolder({
    required Id noteId,
    required Id folderId,
  });

  Future<Either<MenoException, Unit>> removeNoteFromFolder({
    required Id noteId,
    required Id folderId,
  });

  // =========================================================================
  // FOLDERS
  // =========================================================================
  /// Live stream of all folders from local DB.
  Stream<List<NoteFolder>> watchFolders({String? keywords});

  /// Live stream of a single folder + its notes.
  Stream<NoteFolder> watchFolder(Id folderId);

  Future<Either<MenoException, NoteFolder>> createFolder(NoteFolder folder);

  Future<Either<MenoException, NoteFolder>> updateFolder(NoteFolder folder);

  Future<Either<MenoException, Unit>> deleteFolder(Id folderId);

  // =========================================================================
  // SYNC
  // =========================================================================
  /// Called after login: downloads all notes & folders from remote and stores
  /// them in the local ObjectBox database.
  Future<Either<MenoException, Unit>> syncFromRemote();

  /// Retries all locally pending (un-synced) operations.
  Future<void> retryPendingSync();
}
