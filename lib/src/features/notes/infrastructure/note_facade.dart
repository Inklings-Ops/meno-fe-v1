import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/notes/infrastructure/dtos/dtos.dart';

import '../../../services/network_service.dart';
import '../domain/domain.dart';
import '../domain/exceptions/note_exception.dart';
import 'datasources/datasources.dart';

@Injectable(as: INoteFacade)
class NoteFacade implements INoteFacade {
  final NetworkService _network;
  final NoteLocalDatasource _local;
  final NoteRemoteDatasource _remote;

  NoteFacade({
    required NetworkService network,
    required NoteLocalDatasource local,
    required NoteRemoteDatasource remote,
  })  : _network = network,
        _local = local,
        _remote = remote;

  @override
  Future<Either<NoteException, Unit>> addNoteToFolder({
    required String noteId,
    required String folderId,
  }) async {
    if (!(await _network.isConnected)) {
      return left(const NoteException.networkError());
    } else {
      try {
        await _remote.addNoteToFolder(noteId: noteId, folderId: folderId);
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
  Future<Either<NoteException, Folder>> createFolder(IFolderTitle title) async {
    if (!(await _network.isConnected)) {
      return left(const NoteException.networkError());
    } else {
      final titleValue = title.get()!;

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
  Future<Either<NoteException, Note>> createNote({
    required INoteTitle title,
    required INoteContent content,
  }) async {
    if (!(await _network.isConnected)) {
      return left(const NoteException.networkError());
    } else {
      final titleValue = title.get()!;
      final contentValue = content.get()!;

      try {
        final response = await _remote.createNote(
          title: titleValue,
          content: contentValue,
        );

        // TODO: Need to know if we need to save the Note offline first
        await _local.storeNote(response.data!);

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
  Future<Either<NoteException, Unit>> deleteFolder(String folderId) async {
    if (!(await _network.isConnected)) {
      return left(const NoteException.networkError());
    } else {
      try {
        await Future.wait([
          _remote.deleteFolder(folderId),
          _local.deleteFolder(folderId),
        ]);
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
  Future<Either<NoteException, Unit>> deleteNote(String noteId) async {
    if (!(await _network.isConnected)) {
      return left(const NoteException.networkError());
    } else {
      try {
        await Future.wait([
          _remote.deleteNote(noteId),
          _local.deleteNote(noteId),
        ]);
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
  Future<Either<NoteException, List<Folder?>>> getAllFolders({
    String? title,
    String? folderId,
    bool? pinned,
    String? sortBy = 'createdAt',
    String? orderBy = 'DESC',
    int? page = 1,
    int? size = 1,
  }) async {
    if (!(await _network.isConnected)) {
      final folderDtos = await _local.getAllFolders();
      final folders = folderDtos.map((e) => e?.toDomain).toList();
      return right(folders);
    } else {
      try {
        final response = await _remote.getAllFolders(
          title: title,
          folderId: folderId,
          pinned: pinned,
          sortBy: sortBy,
          orderBy: orderBy,
          page: page,
          size: size,
        );
        final dtos = response.data!.notes;
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
    String? noteId,
    bool? pinned,
    String? sortBy = 'createdAt',
    String? orderBy = 'DESC',
    int? page = 1,
    int? size = 1,
  }) async {
    if (!(await _network.isConnected)) {
      final noteDtos = await _local.getAllNotes();
      final notes = noteDtos.map((e) => e?.toDomain).toList();
      return right(notes);
    } else {
      try {
        final response = await _remote.getAllNotes(
          keywords: keywords,
          noteId: noteId,
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
  Future<Either<NoteException, Folder?>> readFolder({
    required String folderId,
    bool includeNotes = true,
    String? keywords,
    bool? pinned,
    String? sortBy = 'createdAt',
    String? orderBy = 'DESC',
    int? page = 1,
    int? size = 1,
  }) async {
    if (!(await _network.isConnected)) {
      final folderDto = await _local.getFolder(folderId);
      final folder = folderDto?.toDomain;
      return right(folder);
    } else {
      try {
        final response = await _remote.getFolder(
          folderId: folderId,
          includeNotes: includeNotes,
          keywords: keywords,
          pinned: pinned,
          sortBy: sortBy,
          orderBy: orderBy,
          page: page,
          size: size,
        );
        final dto = response.data;
        final folder = dto?.toDomain;
        return right(folder);
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
      final noteDto = await _local.getNote(noteId);
      final note = noteDto?.toDomain;
      return right(note);
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
    required String noteId,
    required String folderId,
  }) async {
    if (!(await _network.isConnected)) {
      // TODO: check how to remove note from  folder on ObjectBox
      return left(const NoteException.networkError());
    } else {
      try {
        await _remote.removeNoteFromFolder(
          noteId: noteId,
          folderId: folderId,
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
    required String id,
    IFolderTitle? title,
    bool? pinned,
  }) async {
    if (!(await _network.isConnected)) {
      final dto = await _local.getFolder(id);
      final titleValue = title?.get() ?? dto!.title;
      final updatedDto = dto?.copyWith(title: titleValue, pinned: pinned);
      final folder = updatedDto!.toDomain;
      return right(folder);
    } else {
      try {
        final response = await _remote.updateFolder(
          folderId: id,
          title: title?.get(),
          pinned: pinned,
        );
        final dto = response.data;
        final folder = dto!.toDomain;
        return right(folder);
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
    required String id,
    INoteTitle? title,
    INoteContent? content,
    bool? pinned,
  }) async {
    if (!(await _network.isConnected)) {
      final dto = await _local.getNote(id);
      final titleValue = title?.get() ?? dto!.title;
      final contentValue = content?.get() ?? dto!.content;

      final updatedDto = dto?.copyWith(
        title: titleValue,
        content: contentValue,
        pinned: pinned,
      );
      final note = updatedDto!.toDomain;
      return right(note);
    } else {
      try {
        final response = await _remote.updateNote(
          noteId: id,
          title: title?.get(),
          content: content?.get(),
          pinned: pinned,
        );
        final dto = response.data;
        final note = dto!.toDomain;
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
}
