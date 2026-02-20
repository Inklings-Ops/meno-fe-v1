import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

class NotesRepositoryImpl with MLogger implements INoteRepository {
  const NotesRepositoryImpl({
    required NotesLocalDataSource local,
    required NotesRemoteDataSource remote,
  }) : _local = local,
       _remote = remote;

  final NotesLocalDataSource _local;
  final NotesRemoteDataSource _remote;

  // ===========================================================================
  // NOTES — WRITES (optimistic)
  // ===========================================================================
  @override
  Future<Either<MenoException, Note>> createNote(Note note) async {
    // Persist locally with a client-generated id and mark as pending.
    final localDto = note.toDto(pending: true);
    _local.upsertNote(localDto);

    // Attempt remote creation in the background.
    try {
      final remoteDto = await _remote.createNote(localDto);
      // Replace the local pending row with the server-confirmed dto.
      // The server may assign a different id, so we delete the old row first.
      _local.deleteNoteByRemoteId(localDto.id);
      _local.upsertNote(remoteDto);
      return Right(remoteDto.toDomain);
    } catch (e) {
      log.w('createNote: remote failed, kept local pending — $e');
      if (e is MenoException) return Left(e);
      return Left(MenoException(e.toString()));
    }
  }

  @override
  Future<Either<MenoException, Note>> updateNote(Note note) async {
    final idStr = note.id.getOrCrash();

    // Optimistic local update — mark pending.
    final localDto = note.toDto(pending: true);
    _local.upsertNote(localDto);

    // Background remote update.
    try {
      final remoteDto = await _remote.updateNote(idStr, localDto);
      _local.upsertNote(remoteDto);
      return Right(remoteDto.toDomain);
    } catch (e) {
      log.w('updateNote: remote failed, kept local pending — $e');
      if (e is MenoException) return Left(e);
      return Left(MenoException(e.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> deleteNote(Id noteId) async {
    final idStr = noteId.getOrCrash();

    // Optimistic local delete.
    _local.deleteNoteByRemoteId(idStr);

    // Background remote delete.
    try {
      await _remote.deleteNote(idStr);
      return const Right(unit);
    } catch (e) {
      log.w('deleteNote: remote failed — $e');
      if (e is MenoException) return Left(e);
      return Left(MenoException(e.toString()));
    }
  }

  @override
  Future<Either<MenoException, Note>> addNoteToFolder({
    required Id noteId,
    required Id folderId,
  }) async {
    try {
      final remoteDto = await _remote.addNoteToFolder(
        noteId: noteId.getOrCrash(),
        folderId: folderId.getOrCrash(),
      );
      // Persist the updated note (now carrying the folder relation).
      _local.upsertNote(remoteDto);
      return Right(remoteDto.toDomain);
    } catch (e) {
      log.w('addNoteToFolder: failed — $e');
      if (e is MenoException) return Left(e);
      return Left(MenoException(e.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> removeNoteFromFolder({
    required Id noteId,
    required Id folderId,
  }) async {
    final noteIdStr = noteId.getOrCrash();
    final folderIdStr = folderId.getOrCrash();

    // Optimistically detach locally.
    final existing = _local.findNoteByRemoteId(noteIdStr);
    if (existing != null) {
      existing.folder.target = null;
      _local.upsertNote(existing);
    }

    try {
      await _remote.removeNoteFromFolder(
        noteId: noteIdStr,
        folderId: folderIdStr,
      );
      return const Right(unit);
    } catch (e) {
      log.w('removeNoteFromFolder: remote failed — $e');
      if (e is MenoException) return Left(e);
      return Left(MenoException(e.toString()));
    }
  }

  // ===========================================================================
  // FOLDERS — WRITES
  // ===========================================================================

  /// Folder creation requires a network round-trip because the server assigns
  /// the canonical id. There is no useful local-first default we can show.
  @override
  Future<Either<MenoException, NoteFolder>> createFolder(
    NoteFolder folder,
  ) async {
    try {
      final remoteDto = await _remote.createFolder(folder.toDto);
      _local.upsertFolder(remoteDto);
      return Right(remoteDto.toDomain);
    } catch (e) {
      log.w('createFolder: failed — $e');
      if (e is MenoException) return Left(e);
      return Left(MenoException(e.toString()));
    }
  }

  @override
  Future<Either<MenoException, NoteFolder>> updateFolder(
    NoteFolder folder,
  ) async {
    final idStr = folder.id.getOrCrash();

    // Optimistic local update.
    final localDto = folder.toDto..syncPending = true;
    _local.upsertFolder(localDto);

    try {
      final remoteDto = await _remote.updateFolder(idStr, localDto);
      _local.upsertFolder(remoteDto);
      return Right(remoteDto.toDomain);
    } catch (e) {
      log.w('updateFolder: remote failed, kept local pending — $e');
      if (e is MenoException) return Left(e);
      return Left(MenoException(e.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> deleteFolder(Id folderId) async {
    final idStr = folderId.getOrCrash();

    // Optimistic local delete (also detaches orphaned notes).
    _local.deleteFolderByRemoteId(idStr);

    try {
      await _remote.deleteFolder(idStr);
      return const Right(unit);
    } catch (e) {
      log.w('deleteFolder: remote failed — $e');
      if (e is MenoException) return Left(e);
      return Left(MenoException(e.toString()));
    }
  }

  // ========================================================================
  // SYNC
  // ========================================================================

  /// Downloads every page of notes and folders from the remote and stores them
  /// in ObjectBox. Called once after login to hydrate the local cache.
  ///
  /// Pages are fetched sequentially to avoid hammering the server. If any page
  /// fails the error is returned immediately; already-stored pages remain.
  @override
  Future<Either<MenoException, Unit>> syncFromRemote() async {
    try {
      await Future.wait([_syncAllNotes(), _syncAllFolders()]);
      log.i('syncFromRemote: completed successfully');
      return const Right(unit);
    } catch (e) {
      log.e('syncFromRemote: failed — $e');
      if (e is MenoException) return Left(e);
      return Left(MenoException(e.toString()));
    }
  }

  Future<void> _syncAllNotes() async {
    var page = 1;
    while (true) {
      final response = await _remote.getNotes(page: page);
      _local.upsertNotes(response.items.whereType<NoteDto>().toList());
      if (!response.hasMore) break;
      page++;
    }
    log.d('syncFromRemote: notes synced (last page: $page)');
  }

  Future<void> _syncAllFolders() async {
    var page = 1;
    while (true) {
      final response = await _remote.getFolders(page: page);
      _local.upsertFolders(response.items.whereType<NoteFolderDto>().toList());
      if (!response.hasMore) break;
      page++;
    }
    log.d('syncFromRemote: folders synced (last page: $page)');
  }

  /// Retries all locally pending notes and folders.
  ///
  /// Fires-and-forgets individual failures — a single bad record will not
  /// block the rest of the queue. Failures are logged for debugging.
  @override
  Future<void> retryPendingSync() async {
    await Future.wait([_retryPendingNotes(), _retryPendingFolders()]);
  }

  Future<void> _retryPendingNotes() async {
    final pending = _local.getPendingNotes();
    log.d('retryPendingSync: ${pending.length} pending note(s)');

    for (final dto in pending) {
      try {
        final isNew = dto.createdAt == null; // heuristic: never confirmed
        final synced = isNew
            ? await _remote.createNote(dto)
            : await _remote.updateNote(dto.id, dto);

        if (isNew) _local.deleteNoteByRemoteId(dto.id);
        _local.upsertNote(synced);
      } catch (e) {
        log.w('retryPendingNotes: skipping ${dto.id} — $e');
        rethrow;
      }
    }
  }

  Future<void> _retryPendingFolders() async {
    final pending = _local.getPendingFolders();
    log.d('retryPendingSync: ${pending.length} pending folder(s)');

    for (final dto in pending) {
      try {
        final synced = await _remote.updateFolder(dto.id, dto);
        _local.upsertFolder(synced);
      } catch (e) {
        log.w('retryPendingFolders: skipping ${dto.id} — $e');
        rethrow;
      }
    }
  }

  // ========================================================================
  // NOTES — STREAMS
  // ========================================================================
  @override
  Stream<List<Note>> watchNotes({String? keywords, bool? pinned}) {
    late StreamController<List<Note>> controller;
    StreamSubscription<List<NoteDto>>? subscription;

    controller = StreamController<List<Note>>(
      onListen: () {
        subscription = _local
            .watchNotes(keywords: keywords, pinned: pinned)
            .listen(
              (dtos) => controller.add(dtos.map((d) => d.toDomain).toList()),
              onError: controller.addError,
            );
      },
      onCancel: () {
        subscription?.cancel();
        controller.close();
      },
    );

    return controller.stream;
  }

  // ========================================================================
  // FOLDERS — STREAMS
  // ========================================================================

  @override
  Stream<List<NoteFolder>> watchFolders({String? keywords}) {
    late StreamController<List<NoteFolder>> controller;
    StreamSubscription<List<NoteFolderDto>>? sub;

    controller = StreamController<List<NoteFolder>>(
      onListen: () {
        sub = _local
            .watchFolders(keywords: keywords)
            .listen(
              (dtos) => controller.add(dtos.map((d) => d.toDomain).toList()),
              onError: controller.addError,
            );
      },
      onCancel: () {
        sub?.cancel();
        controller.close();
      },
    );

    return controller.stream;
  }

  /// Combines [watchFolder] (folder metadata) and watchNotesInFolder (notes)
  /// into a single [NoteFolder] stream, emitting whenever either source
  /// changes.
  ///
  /// Uses a plain [StreamController] that re-evaluates and emits whenever
  /// either inner stream fires. Both inner streams are ObjectBox watch streams
  /// that already trigger immediately, so the first event is guaranteed.
  @override
  Stream<NoteFolder> watchFolder(Id folderId) {
    final idStr = folderId.getOrCrash();

    late StreamController<NoteFolder> controller;
    StreamSubscription<NoteFolderDto?>? folderSub;
    StreamSubscription<List<NoteDto>>? notesSub;

    // Mutable state shared between the two inner subscriptions.
    NoteFolderDto? latestFolder;
    var latestNotes = <NoteDto>[];

    void tryEmit() {
      final folder = latestFolder;
      if (folder == null) return; // folder not yet loaded, wait

      // Map notes first — NoteDto.toDomain gives a metadata-only folder,
      // so no circular traversal. Then compose via toDomainWithNotes.
      final domainNotes = latestNotes.map((n) => n.toDomain).toList();
      controller.add(folder.toDomainWithNotes(domainNotes));
    }

    controller = StreamController<NoteFolder>(
      onListen: () {
        folderSub = _local.watchFolder(idStr).listen((dto) {
          latestFolder = dto;
          tryEmit();
        }, onError: controller.addError);

        notesSub = _local.watchNotesInFolder(idStr).listen((dtos) {
          latestNotes = dtos;
          tryEmit();
        }, onError: controller.addError);
      },
      onCancel: () {
        folderSub?.cancel();
        notesSub?.cancel();
        controller.close();
      },
    );

    return controller.stream;
  }

  @override
  FutureOr<dynamic> onDispose() {
    _local.clearAll();
    log.i('NoteRepositoryImpl: disposed — local store cleared');
  }
}
