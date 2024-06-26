import 'package:dartz/dartz.dart';

import 'entities/folder.dart';
import 'entities/note.dart';
import 'exceptions/note_exception.dart';
import 'inputs/i_folder_title.dart';
import 'inputs/i_note_content.dart';
import 'inputs/i_note_title.dart';

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

  Future<Either<NoteException, Note>> createNote({
    required INoteTitle title,
    required INoteContent content,
  });

  Future<Either<NoteException, Note?>> readNote(String noteId);

  Future<Either<NoteException, Note>> updateNote({
    required String id,
    INoteTitle? title,
    INoteContent? content,
    bool? pinned,
  });

  Future<Either<NoteException, Unit>> deleteNote(String noteId);

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

  Future<Either<NoteException, Folder>> createFolder(IFolderTitle title);

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
    IFolderTitle? title,
    bool? pinned,
  });

  Future<Either<NoteException, Unit>> deleteFolder(String folderId);

  Future<void> saveNoteLocally(Note note);
}
