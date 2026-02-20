import 'package:dio/dio.dart' show CancelToken;
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';

class NoteRemoteDataSource {
  const NoteRemoteDataSource(this._api);

  final ApiClient _api;

  // ========================================================================
  // NOTES
  // ========================================================================
  /// Creates a new note on the remote and returns the persisted [NoteDto].
  Future<NoteDto> createNote(NoteDto dto) {
    return _api.post(
      '/api/v1/notes',
      data: {'title': dto.title, 'content': dto.content},
      fromJson: NoteDto.fromJson,
    );
  }

  /// Fetches paginated list of notes.
  Future<PagedList<NoteDto>> getNotes({
    String? keywords,
    String? noteId,
    bool? pinned,
    String sortBy = 'updatedAt',
    String orderBy = 'DESC',
    int page = 1,
    int size = 100,
    CancelToken? cancelToken,
  }) {
    return _api.get(
      '/api/v1/notes/',
      fromJson: (json) =>
          PagedList<NoteDto>.fromJson(json, NoteDto.fromJson, listKey: 'notes'),
      queryParameters: {
        if (keywords != null) 'keywords': keywords,
        if (noteId != null) 'noteId': noteId,
        if (pinned != null) 'pinned': pinned,
        'sortBy': sortBy,
        'orderBy': orderBy,
        'page': page,
        'size': size,
      },
      cancelToken: cancelToken,
    );
  }

  /// Fetches a single note by its remote id.
  Future<NoteDto> getNote(String noteId) {
    return _api.get('/api/v1/notes/$noteId', fromJson: NoteDto.fromJson);
  }

  /// Updates an existing note.
  Future<NoteDto> updateNote(String noteId, NoteDto dto) {
    return _api.put(
      '/api/v1/notes/$noteId',
      data: {'title': dto.title, 'content': dto.content, 'pinned': dto.pinned},
      fromJson: NoteDto.fromJson,
    );
  }

  /// Deletes a note. Throws [MenoException] on failure.
  Future<void> deleteNote(String noteId) {
    return _api.deleteUnit('/api/v1/notes/$noteId');
  }

  /// Adds a note to a folder and returns the updated [NoteDto] with the
  /// folder relation populated.
  Future<NoteDto> addNoteToFolder({
    required String noteId,
    required String folderId,
  }) {
    return _api.put(
      '/api/v1/notes/$noteId/folders/$folderId',
      fromJson: NoteDto.fromJson,
    );
  }

  /// Removes a note from its folder.
  Future<void> removeNoteFromFolder({
    required String noteId,
    required String folderId,
  }) {
    return _api.deleteUnit('/api/v1/notes/$noteId/folders/$folderId');
  }

  // ===========================================================================
  // FOLDERS
  // ===========================================================================

  /// Fetches one page of folders.
  Future<PagedList<NoteFolderDto>> getFolders({
    String? title,
    String? folderId,
    bool? pinned,
    String sortBy = 'createdAt',
    String orderBy = 'DESC',
    int page = 1,
    int size = 100,
    CancelToken? cancelToken,
  }) {
    return _api.get(
      '/api/v1/folders/',
      fromJson: (json) => PagedList<NoteFolderDto>.fromJson(
        json,
        NoteFolderDto.fromJson,
        listKey: 'folders',
      ),
      queryParameters: {
        if (title != null) 'title': title,
        if (folderId != null) 'folderId': folderId,
        if (pinned != null) 'pinned': pinned,
        'sortBy': sortBy,
        'orderBy': orderBy,
        'page': page,
        'size': size,
      },
      cancelToken: cancelToken,
    );
  }

  /// Fetches a single folder together with its first page of notes.
  ///
  /// The compound response is parsed into a [FolderWithNotes] which carries
  /// the folder metadata, the notes list, and the notes pagination info
  /// separately — matching the server shape exactly.
  Future<FolderWithNotes> getFolderWithNotes(
    String folderId, {
    String? keywords,
    bool? pinned,
    String sortBy = 'createdAt',
    String orderBy = 'DESC',
    int page = 1,
    int size = 50,
    CancelToken? cancelToken,
  }) {
    return _api.get(
      '/api/v1/folders/$folderId',
      fromJson: (json) =>
          FolderWithNotes.fromJson(json as Map<String, dynamic>),
      queryParameters: {
        'includeNotes': true,
        if (keywords != null) 'keywords': keywords,
        if (pinned != null) 'pinned': pinned,
        'sortBy': sortBy,
        'orderBy': orderBy,
        'page': page,
        'size': size,
      },
      cancelToken: cancelToken,
    );
  }

  /// Fetches a single folder together without notes.
  Future<NoteFolderDto> getFolder(String folderId, {CancelToken? cancelToken}) {
    return _api.get(
      '/api/v1/folders/$folderId',
      fromJson: NoteFolderDto.fromJson,
      queryParameters: {'includeNotes': false},
      cancelToken: cancelToken,
    );
  }

  /// Creates a new folder on the remote.
  Future<NoteFolderDto> createFolder(NoteFolderDto dto) {
    return _api.post(
      '/api/v1/folders',
      data: {'title': dto.title},
      fromJson: NoteFolderDto.fromJson,
    );
  }

  /// Updates an existing folder's title and/or pinned state.
  Future<NoteFolderDto> updateFolder(String folderId, NoteFolderDto dto) {
    return _api.put(
      '/api/v1/folders/$folderId',
      data: {'title': dto.title, 'pinned': dto.pinned},
      fromJson: NoteFolderDto.fromJson,
    );
  }

  /// Deletes a folder. Notes inside are detached on the server side.
  Future<void> deleteFolder(String folderId) {
    return _api.deleteUnit('/api/v1/folders/$folderId');
  }
}
