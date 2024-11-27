import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';
import 'package:objectbox/objectbox.dart';

@Injectable(as: INoteFacade)
class NoteFacade implements INoteFacade {
  NoteFacade({
    required NetworkService network,
    required NoteLocalDatasource local,
    required NoteRemoteDatasource remote,
  })  : _network = network,
        _local = local,
        _remote = remote;
  final NetworkService _network;
  final NoteLocalDatasource _local;
  final NoteRemoteDatasource _remote;

  @override
  Stream<List<Note?>> allNotesStream() {
    final notes = _local
        .allNotesStream()
        .map((dtos) => dtos.map((dto) => dto?.toDomain).toList());
    return notes;
  }

  @override
  Future<Either<NoteException, Note>> createNote(Note note) async {
    if (!(await _network.isConnected)) {
      return left(const NoteException.networkError());
    } else {
      final titleStr = note.title.value.getOrElse(() => 'Unknown Title');
      final contentStr = note.content.value.getOrElse(() => 'Unknown content');

      try {
        final response = await _remote.createNote(
          title: titleStr,
          content: contentStr,
        );

        return right(response.data!.toDomain);
      } on DioException catch (e) {
        if (e.message != null) {
          return left(NoteException.message(e.message!));
        } else {
          return left(const NoteException.unknownError());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Note>> updateNote({
    required Note note,
    bool? pinned,
  }) async {
    if (!(await _network.isConnected)) {
      return right(Note.empty());
    } else {
      try {
        final response = await _remote.updateNote(
          noteId: note.uid.value.getOrElse(() => 'Invalid id'),
          title: note.title.value.getOrElse(() => 'Invalid title'),
          content: note.content.value.getOrElse(() => 'Invalid content'),
          pinned: pinned,
        );
        final dto = response.data;
        final noteEntity = dto!.toDomain;

        return right(noteEntity);
      } on DioException catch (e) {
        if (e.message != null) {
          return left(NoteException.message(e.message!));
        } else {
          return left(const NoteException.unknownError());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Unit>> deleteNote(Uid<Note> noteId) async {
    if (!(await _network.isConnected)) {
      return left(const NoteException.networkError());
    } else {
      try {
        final uidStr = noteId.value.getOrElse(() => 'Invalid id');
        await _remote.deleteNote(uidStr);
        return right(unit);
      } on DioException catch (e) {
        if (e.message != null) {
          return left(NoteException.message(e.message!));
        } else {
          return left(const NoteException.unknownError());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Unit>> deleteFolder(Uid<Folder> folderId) async {
    if (!(await _network.isConnected)) {
      return left(const NoteException.networkError());
    } else {
      try {
        await _remote.deleteFolder(folderId.getOr());
        return right(unit);
      } on DioException catch (e) {
        if (e.message != null) {
          return left(NoteException.message(e.message!));
        } else {
          return left(const NoteException.unknownError());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Note>> addNoteToFolder({
    required Uid<Note> noteId,
    required Uid<Folder> folderId,
  }) async {
    if (!(await _network.isConnected)) {
      return left(const NoteException.networkError());
    } else {
      try {
        final response = await _remote.addNoteToFolder(
          noteId: noteId.getOr(),
          folderId: folderId.getOr(),
        );

        return right(response.data!.toDomain);
      } on DioException catch (e) {
        if (e.message != null) {
          return left(NoteException.message(e.message!));
        } else {
          return left(const NoteException.unknownError());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Folder>> createFolder(Folder folder) async {
    if (!(await _network.isConnected)) {
      return left(const NoteException.networkError());
    } else {
      final titleValue = folder.title.value.getOrElse(() => 'Unknown folder');
      try {
        final response = await _remote.createFolder(title: titleValue);
        return right(response.data!.toDomain);
      } on DioException catch (e) {
        if (e.message != null) {
          return left(NoteException.message(e.message!));
        } else {
          return left(const NoteException.unknownError());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, List<Folder?>>> getAllFolders({
    String? title,
    Uid<Folder>? folderId,
    bool? pinned,
    String? sortBy = 'createdAt',
    String? orderBy = 'DESC',
    int? page = 1,
    int? size = 50,
  }) async {
    if (!(await _network.isConnected)) {
      // final folderDtos = await _local.getAllFolders();
      // final folders = folderDtos.map((e) => e?.toDomain).toList();
      // return right(folders);
      return left(const NoteException.networkError());
    } else {
      try {
        final response = await _remote.getAllFolders(
          title: title,
          folderId: folderId?.getOr(),
          pinned: pinned,
          sortBy: sortBy,
          orderBy: orderBy,
          page: page,
          size: size,
        );
        final dtos = response.data!.folders;
        final folders = dtos.map((e) => e?.toDomain).toList();
        return right(folders);
      } on DioException catch (e) {
        if (e.message != null) {
          return left(NoteException.message(e.message!));
        } else {
          return left(const NoteException.unknownError());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, List<Note?>>> getAllNotes({
    String? keywords,
    Uid<Note>? noteId,
    bool? pinned,
    String? sortBy = 'createdAt',
    String? orderBy = 'DESC',
    int? page = 1,
    int? size = 6,
  }) async {
    if (!(await _network.isConnected)) {
      // final noteDtos = await _local.getAllNotes();
      // final notes = noteDtos.map((e) => e?.toDomain).toList();
      // return right(notes);
      return left(const NoteException.networkError());
    } else {
      try {
        final response = await _remote.getAllNotes(
          keywords: keywords,
          noteId: noteId?.getOr(),
          pinned: pinned,
          sortBy: sortBy,
          orderBy: orderBy,
          page: page,
          size: size,
        );
        final dtos = response.data!.notes;

        final notes = dtos.map((e) => e?.toDomain).toList();
        return right(notes);
      } on DioException catch (e) {
        if (e.message != null) {
          return left(NoteException.message(e.message!));
        } else {
          return left(const NoteException.unknownError());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Folder?>> getFolderWithNotes({
    required Uid<Folder> folderId,
    String? keywords,
    bool? pinned,
    String? sortBy = 'createdAt',
    String? orderBy = 'DESC',
    int? page = 1,
    int? size = 50,
    CancelToken? cancelToken,
  }) async {
    final folderIdString = folderId.getOr();
    // final localFolder = _local.getFolder(folderIdString);
    // if (localFolder != null) return right(localFolder.toDomain);

    if (!(await _network.isConnected)) {
      return left(const NoteException.networkError());
    } else {
      try {
        final response = await _remote.getFolderWithNotes(
          folderId: folderIdString,
          keywords: keywords,
          pinned: pinned,
          sortBy: sortBy,
          orderBy: orderBy,
          page: page,
          size: size,
          cancelToken: cancelToken,
        );
        final resNotes = response.data!.notes;
        final notes = ToMany<NoteDto>()..addAll(resNotes.whereType<NoteDto>());
        final folderWithNotes = response.data!.folder.copyWith(notes: notes);
        // _local.storeFolder(folderWithNotes);
        return right(folderWithNotes.toDomain);
      } on DioException catch (e) {
        if (CancelToken.isCancel(e)) {
          return left(const NoteException.message('Request cancelled'));
        } else if (e.message != null) {
          return left(NoteException.message(e.message!));
        } else {
          return left(const NoteException.unknownError());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Folder?>> getFolder({
    required Uid<Folder> folderId,
    String? keywords,
    bool? pinned,
  }) async {
    if (!(await _network.isConnected)) {
      // final folderDto = await _local.getFolder(folderId);
      // final folder = folderDto?.toDomain;
      // return right(folder);
      return left(const NoteException.networkError());
    } else {
      try {
        final response = await _remote.getFolder(
          folderId: folderId.getOr(),
          keywords: keywords,
          pinned: pinned,
        );
        final folderResponse = response.data;
        return right(folderResponse!.folder.toDomain);
      } on DioException catch (e) {
        if (e.message != null) {
          return left(NoteException.message(e.message!));
        } else {
          return left(const NoteException.unknownError());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Note?>> readNote(String noteId) async {
    if (!(await _network.isConnected)) {
      // final noteDto = await _local.getNote(noteId);
      // final note = noteDto?.toDomain;
      // return right(note);
      return left(const NoteException.networkError());
    } else {
      try {
        final response = await _remote.getNote(noteId);
        final dto = response.data;
        final note = dto?.toDomain;
        return right(note);
      } on DioException catch (e) {
        if (e.message != null) {
          return left(NoteException.message(e.message!));
        } else {
          return left(const NoteException.unknownError());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Unit>> removeNoteFromFolder({
    required Uid<Note> noteId,
    required Uid<Folder> folderId,
  }) async {
    if (!(await _network.isConnected)) {
      // how to remove item from folder on ObjectBox
      return left(const NoteException.networkError());
    } else {
      try {
        await _remote.removeNoteFromFolder(
          noteId: noteId.getOr(),
          folderId: folderId.getOr(),
        );
        return right(unit);
      } on DioException catch (e) {
        if (e.message != null) {
          return left(NoteException.message(e.message!));
        } else {
          return left(const NoteException.unknownError());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Folder>> updateFolder({
    required Folder folder,
    bool? pinned,
  }) async {
    if (!(await _network.isConnected)) {
      // final dto = await _local.getFolder(id);
      // final titleValue = title?.getOr() ?? dto!.title;
      // final updatedDto = dto?.copyWith(title: titleValue, pinned: pinned);
      // final folder = updatedDto!.toDomain;
      // return right(folder);
      return left(const NoteException.networkError());
    } else {
      try {
        final response = await _remote.updateFolder(
          folderId: folder.id.getOr(),
          title: folder.title.value.getOrElse(() => 'Unknown folder'),
          pinned: pinned,
        );
        final dto = response.data;
        return right(dto!.toDomain);
      } on DioException catch (e) {
        if (e.message != null) {
          return left(NoteException.message(e.message!));
        } else {
          return left(const NoteException.unknownError());
        }
      }
    }
  }

  @override
  Future<void> saveNoteLocally(Note note) async {}
}
