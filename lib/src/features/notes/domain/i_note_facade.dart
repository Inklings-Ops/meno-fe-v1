import 'package:dartz/dartz.dart';

import '../infrastructure/responses/note_list_response.dart';
import 'entities/folder.dart';
import 'entities/note.dart';
import 'exceptions/note_exception.dart';
import 'inputs/i_folder_title.dart';
import 'inputs/i_note_content.dart';
import 'inputs/i_note_title.dart';

abstract class INoteFacade {
  Future<Either<NoteException, NoteListResponse>> getAllNotes({
    String? keywords,
    String? noteId,
    bool? pinned,
    String? sortBy = 'createdAt',
    String? orderBy = 'DESC',
    int? page = 1,
    int? size = 1,
  });

  Future<Either<NoteException, Note>> createNote({
    required INoteTitle title,
    required INoteContent content,
  });

  Future<Either<NoteException, Note>> readNote(String noteId);

  Future<Either<NoteException, Note>> updateNote({
    required String id,
    INoteTitle? title,
    INoteContent? content,
    bool? pinned,
  });

  Future<Either<NoteException, Unit>> deleteNote(String noteId);

  Future<Either<NoteException, Unit>> addNoteToFolder({
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
    String? sortBy = 'createdAt',
    String? orderBy = 'DESC',
    int? page = 1,
    int? size = 1,
  });

  Future<Either<NoteException, Folder>> createFolder(IFolderTitle title);

  Future<Either<NoteException, Folder?>> readFolder({
    required String folderId,
    bool includeNotes = true,
    String? keywords,
    bool? pinned,
    String? sortBy = 'createdAt',
    String? orderBy = 'DESC',
    int? page = 1,
    int? size = 1,
  });

  Future<Either<NoteException, Folder>> updateFolder({
    required String id,
    IFolderTitle? title,
    bool? pinned,
  });

  Future<Either<NoteException, Unit>> deleteFolder(String folderId);
}
