import 'package:dartz/dartz.dart';

import 'package:meno_fe_v1/src/features/notes/domain/entities/folder.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/note.dart';
import 'package:meno_fe_v1/src/features/notes/domain/exceptions/note_exception.dart';
import 'package:meno_fe_v1/src/features/notes/domain/value_objects/folder_title.dart';

abstract class INoteFacade {
  Future<Either<NoteException, List<Note?>>> getAllNotes({
    String? keywords,
    String? noteId,
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

  Future<Either<NoteException, Unit>> deleteNote(Note note);

  Future<Either<NoteException, Note>> addNoteToFolder({
    required String noteId,
    required String folderId,
  });

  Future<Either<NoteException, Unit>> removeNoteFromFolder({
    required String noteId,
    required String folderId,
  });

  Future<Either<NoteException, List<Folder?>>> getAllFolders({
    String? title,
    String? folderId,
    bool? pinned,
    String? sortBy,
    String? orderBy,
    int? page,
    int? size,
  });

  Future<Either<NoteException, Folder>> createFolder(FolderTitle title);

  Future<Either<NoteException, Folder?>> getFolder({
    required String folderId,
    String? keywords,
    bool? pinned,
  });

  Future<Either<NoteException, Folder?>> getFolderWithNotes({
    required String folderId,
    String? keywords,
    bool? pinned,
    String? sortBy,
    String? orderBy,
    int? page,
    int? size,
  });

  Future<Either<NoteException, Folder>> updateFolder({
    required String id,
    FolderTitle? title,
    bool? pinned,
  });

  Future<Either<NoteException, Unit>> deleteFolder(String folderId);

  Future<void> saveNoteLocally(Note note);
}
