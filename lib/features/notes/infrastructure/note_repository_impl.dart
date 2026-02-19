import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

class NoteRepositoryImpl with MLogger implements INoteRepository {
  const NoteRepositoryImpl({
    required NoteLocalDataSource local,
    required NoteRemoteDataSource remote,
  }) : _local = local,
       _remote = remote;

  final NoteLocalDataSource _local;
  final NoteRemoteDataSource _remote;

  @override
  Future<Either<MenoException, Note>> addNoteToFolder({
    required Id noteId,
    required Id folderId,
  }) {
    // TODO: implement addNoteToFolder
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, NoteFolder>> createFolder(NoteFolder folder) {
    // TODO: implement createFolder
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, Note>> createNote(Note note) {
    // TODO: implement createNote
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, Unit>> deleteFolder(Id folderId) {
    // TODO: implement deleteFolder
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, Unit>> deleteNote(Id noteId) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  FutureOr<dynamic> onDispose() {
    // TODO: implement onDispose
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, Unit>> removeNoteFromFolder({
    required Id noteId,
    required Id folderId,
  }) {
    // TODO: implement removeNoteFromFolder
    throw UnimplementedError();
  }

  @override
  Future<void> retryPendingSync() {
    // TODO: implement retryPendingSync
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, Unit>> syncFromRemote() {
    // TODO: implement syncFromRemote
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, NoteFolder>> updateFolder(NoteFolder folder) {
    // TODO: implement updateFolder
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, Note>> updateNote(Note note) {
    // TODO: implement updateNote
    throw UnimplementedError();
  }

  @override
  Stream<NoteFolder> watchFolder(Id folderId) {
    // TODO: implement watchFolder
    throw UnimplementedError();
  }

  @override
  Stream<List<NoteFolder>> watchFolders({String? keywords}) {
    // TODO: implement watchFolders
    throw UnimplementedError();
  }

  @override
  Stream<List<Note>> watchNotes({String? keywords, bool? pinned}) {
    // TODO: implement watchNotes
    throw UnimplementedError();
  }
}
