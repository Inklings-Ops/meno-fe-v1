import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/core/response/response.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

@Injectable(as: INoteFacade)
class NoteFacade implements INoteFacade {
  NoteFacade({
    required NetworkService network,
    required NoteRemoteDatasource remote,
  })  : _network = network,
        _remote = remote;

  final NetworkService _network;
  final NoteRemoteDatasource _remote;

  @override
  Future<Either<NoteException, Note>> createNote(Note note) async {
    if (!(await _network.isConnected)) {
      return const Left(NoteNetworkException());
    } else {
      try {
        final response = await _remote.createNote(
          title: note.title.getOrCrash(),
          content: note.content.getOrCrash(),
        );

        return Right(response.data!.toDomain);
      } on DioException catch (e) {
        if (e.message != null) {
          return Left(NoteExceptionWithMessage(e.message!));
        } else {
          return const Left(NoteUnknownException());
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
      return Right(Note.empty);
    } else {
      try {
        final response = await _remote.updateNote(
          noteId: note.id.getOrCrash(),
          title: note.title.getOrCrash(),
          content: note.content.getOrCrash(),
          pinned: pinned,
        );

        final dto = response.data;
        final noteEntity = dto!.toDomain;
        return Right(noteEntity);
      } on DioException catch (e) {
        if (e.message != null) {
          return Left(NoteExceptionWithMessage(e.message!));
        } else {
          return const Left(NoteUnknownException());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Unit>> deleteNote(ID noteId) async {
    if (!(await _network.isConnected)) {
      return const Left(NoteNetworkException());
    } else {
      try {
        await _remote.deleteNote(noteId.getOrCrash());
        return const Right(unit);
      } on DioException catch (e) {
        if (e.message != null) {
          return Left(NoteExceptionWithMessage(e.message!));
        } else {
          return const Left(NoteUnknownException());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Unit>> deleteFolder(ID folderId) async {
    if (!(await _network.isConnected)) {
      return const Left(NoteNetworkException());
    } else {
      try {
        await _remote.deleteFolder(folderId.getOrCrash());
        return const Right(unit);
      } on DioException catch (e) {
        if (e.message != null) {
          return Left(NoteExceptionWithMessage(e.message!));
        } else {
          return const Left(NoteUnknownException());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Note>> addNoteToFolder({
    required ID noteId,
    required ID folderId,
  }) async {
    if (!(await _network.isConnected)) {
      return const Left(NoteNetworkException());
    } else {
      try {
        final response = await _remote.addNoteToFolder(
          noteId: noteId.getOrCrash(),
          folderId: folderId.getOrCrash(),
        );

        return Right(response.data!.toDomain);
      } on DioException catch (e) {
        if (e.message != null) {
          return Left(NoteExceptionWithMessage(e.message!));
        } else {
          return const Left(NoteUnknownException());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Folder>> createFolder(Folder folder) async {
    if (!(await _network.isConnected)) {
      return const Left(NoteNetworkException());
    } else {
      try {
        final response = await _remote.createFolder(
          title: folder.title.getOrCrash(),
        );
        return Right(response.data!.toDomain);
      } on DioException catch (e) {
        if (e.message != null) {
          return Left(NoteExceptionWithMessage(e.message!));
        } else {
          return const Left(NoteUnknownException());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, PaginatedList<Folder?>>> getAllFolders({
    String? title,
    ID? folderId,
    bool? pinned,
    String? sortBy = 'createdAt',
    String? orderBy = 'DESC',
    int? page = 1,
    int? size = 50,
  }) async {
    if (!(await _network.isConnected)) {
      return const Left(NoteNetworkException());
    } else {
      try {
        final response = await _remote.getAllFolders(
          title: title,
          folderId: folderId?.getOrCrash(),
          pinned: pinned,
          sortBy: sortBy,
          orderBy: orderBy,
          page: page,
          size: size,
        );
        final data = response.data!;
        final paginatedList = PaginatedList(
          items: data.folders.map((dto) => dto?.toDomain).toList(),
          currentPage: data.currentPage,
          totalItems: data.totalItems,
          totalPages: data.totalPages,
        );
        return Right(paginatedList);
      } on DioException catch (e) {
        if (e.message != null) {
          return Left(NoteExceptionWithMessage(e.message!));
        } else {
          return const Left(NoteUnknownException());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, PaginatedList<Note?>>> getAllNotes({
    String? keywords,
    ID? noteId,
    bool? pinned,
    String? sortBy = 'createdAt',
    String? orderBy = 'DESC',
    int? page = 1,
    int? size = 6,
  }) async {
    if (!(await _network.isConnected)) {
      return const Left(NoteNetworkException());
    } else {
      try {
        final response = await _remote.getAllNotes(
          keywords: keywords,
          noteId: noteId?.getOrCrash(),
          pinned: pinned,
          sortBy: sortBy,
          orderBy: orderBy,
          page: page,
          size: size,
        );
        final data = response.data!;
        final paginatedList = PaginatedList(
          items: data.notes.map((dto) => dto?.toDomain).toList(),
          currentPage: data.currentPage,
          totalItems: data.totalItems,
          totalPages: data.totalPages,
        );
        return Right(paginatedList);
      } on DioException catch (e) {
        if (e.message != null) {
          return Left(NoteExceptionWithMessage(e.message!));
        } else {
          return const Left(NoteUnknownException());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Folder?>> getFolderWithNotes({
    required ID folderId,
    String? keywords,
    bool? pinned,
    String? sortBy = 'createdAt',
    String? orderBy = 'DESC',
    int? page = 1,
    int? size = 50,
    CancelToken? cancelToken,
  }) async {
    final folderIdString = folderId.getOrCrash();
    if (!(await _network.isConnected)) {
      return const Left(NoteNetworkException());
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
        final folder = response.data!.folder.toDomain;
        final notes = response.data!.notes.map((n) => n?.toDomain).toList();
        final folderWithNotes = folder.copyWith(notes: notes);
        return Right(folderWithNotes);
      } on DioException catch (e) {
        if (CancelToken.isCancel(e)) {
          return const Left(NoteExceptionWithMessage('Request cancelled'));
        } else if (e.message != null) {
          return Left(NoteExceptionWithMessage(e.message!));
        } else {
          return const Left(NoteUnknownException());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Folder?>> getFolder({
    required ID folderId,
    String? keywords,
    bool? pinned,
  }) async {
    if (!(await _network.isConnected)) {
      return const Left(NoteNetworkException());
    } else {
      try {
        final response = await _remote.getFolder(
          folderId: folderId.getOrCrash(),
          keywords: keywords,
          pinned: pinned,
        );
        return Right(response.data?.toDomain);
      } on DioException catch (e) {
        if (e.message != null) {
          return Left(NoteExceptionWithMessage(e.message!));
        } else {
          return const Left(NoteUnknownException());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Note?>> readNote(String noteId) async {
    if (!(await _network.isConnected)) {
      return const Left(NoteNetworkException());
    } else {
      try {
        final response = await _remote.getNote(noteId);
        final dto = response.data;
        final note = dto?.toDomain;
        return Right(note);
      } on DioException catch (e) {
        if (e.message != null) {
          return Left(NoteExceptionWithMessage(e.message!));
        } else {
          return const Left(NoteUnknownException());
        }
      }
    }
  }

  @override
  Future<Either<NoteException, Unit>> removeNoteFromFolder({
    required ID noteId,
    required ID folderId,
  }) async {
    if (!(await _network.isConnected)) {
      // how to remove item from folder on ObjectBox
      return const Left(NoteNetworkException());
    } else {
      try {
        await _remote.removeNoteFromFolder(
          noteId: noteId.getOrCrash(),
          folderId: folderId.getOrCrash(),
        );
        return const Right(unit);
      } on DioException catch (e) {
        if (e.message != null) {
          return Left(NoteExceptionWithMessage(e.message!));
        } else {
          return const Left(NoteUnknownException());
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
      return const Left(NoteNetworkException());
    } else {
      try {
        final response = await _remote.updateFolder(
          folderId: folder.id.getOrCrash(),
          title: folder.title.getOrCrash(),
          pinned: pinned,
        );
        final dto = response.data;
        return Right(dto!.toDomain);
      } on DioException catch (e) {
        if (e.message != null) {
          return Left(NoteExceptionWithMessage(e.message!));
        } else {
          return const Left(NoteUnknownException());
        }
      }
    }
  }

  @override
  Future<void> saveNoteLocally(Note note) async {}
}
