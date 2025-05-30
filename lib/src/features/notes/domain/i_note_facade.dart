import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/folder.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/note.dart';

abstract class INoteFacade {
  Future<Either<NoteException, PaginatedList<Note?>>> getAllNotes({
    String? keywords,
    ID? noteId,
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

  Future<Either<NoteException, Unit>> deleteNote(ID noteId);

  Future<Either<NoteException, Note>> addNoteToFolder({
    required ID noteId,
    required ID folderId,
  });

  Future<Either<NoteException, Unit>> removeNoteFromFolder({
    required ID noteId,
    required ID folderId,
  });

  Future<Either<NoteException, PaginatedList<Folder?>>> getAllFolders({
    String? title,
    ID? folderId,
    bool? pinned,
    String? sortBy,
    String? orderBy,
    int? page,
    int? size,
  });

  Future<Either<NoteException, Folder>> createFolder(Folder folder);

  Future<Either<NoteException, Folder?>> getFolder({
    required ID folderId,
    String? keywords,
    bool? pinned,
  });

  Future<Either<NoteException, Folder?>> getFolderWithNotes({
    required ID folderId,
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

  Future<Either<NoteException, Unit>> deleteFolder(ID folderId);

  Future<void> saveNoteLocally(Note note);
}
