import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/folder.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/note.dart';
import 'package:meno_fe_v1/src/features/notes/domain/exceptions/note_exception.dart';

abstract class INoteFacade {
  Stream<List<Note?>> allNotesStream();

  Future<Either<NoteException, List<Note?>>> getAllNotes({
    String? keywords,
    Uid<Note>? noteId,
    bool? pinned,
    String? sortBy,
    String? orderBy,
    int? page,
    int? size,
  });

  Future<Either<NoteException, Note>> createNote(Note note);

  Future<Either<NoteException, Note?>> readNote(String noteId);

  Future<Either<NoteException, Note>> updateNote({
    required Note note,
    bool? pinned,
  });

  Future<Either<NoteException, Unit>> deleteNote(Uid<Note> noteId);

  Future<Either<NoteException, Note>> addNoteToFolder({
    required Uid<Note> noteId,
    required Uid<Folder> folderId,
  });

  Future<Either<NoteException, Unit>> removeNoteFromFolder({
    required Uid<Note> noteId,
    required Uid<Folder> folderId,
  });

  Future<Either<NoteException, List<Folder?>>> getAllFolders({
    String? title,
    Uid<Folder>? folderId,
    bool? pinned,
    String? sortBy,
    String? orderBy,
    int? page,
    int? size,
  });

  Future<Either<NoteException, Folder>> createFolder(Folder folder);

  Future<Either<NoteException, Folder?>> getFolder({
    required Uid<Folder> folderId,
    String? keywords,
    bool? pinned,
  });

  Future<Either<NoteException, Folder?>> getFolderWithNotes({
    required Uid<Folder> folderId,
    String? keywords,
    bool? pinned,
    String? sortBy,
    String? orderBy,
    int? page,
    int? size,
    CancelToken? cancelToken,
  });

  Future<Either<NoteException, Folder>> updateFolder({
    required Folder folder,
    bool? pinned,
  });

  Future<Either<NoteException, Unit>> deleteFolder(Uid<Folder> folderId);

  Future<void> saveNoteLocally(Note note);
}
