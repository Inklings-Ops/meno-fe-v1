import 'package:dio/dio.dart' show CancelToken;
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/notes/model/_model.dart';

class NotesHttpService {
  const NotesHttpService(this._http);

  final HttpClient _http;

  // ========================================================================
  // NOTES
  // ========================================================================
  /// Creates a new note on the remote and returns the persisted [NoteDto].
  Future<NoteDto> createNote(NoteDto dto) {
    return _http.post(
      '/notes',
      data: {'title': dto.title, 'content': dto.content},
      fromJson: NoteDto.fromJson,
    );
  }

  /// Fetches paginated list of notes.
  Future<PagedList<NoteDto>> getNotes({
    Id? noteId,
    SortBy sortBy = SortBy.updatedAt,
    OrderBy orderBy = OrderBy.desc,
    PaginationParams pagination = const PaginationParams(),
    String? keywords,
    bool? pinned,
    CancelToken? cancelToken,
  }) {
    return _http.get(
      '/notes/',
      fromJson: (json) =>
          PagedList<NoteDto>.fromJson(json, NoteDto.fromJson, listKey: 'notes'),
      queryParameters: {
        if (keywords != null) 'keywords': keywords,
        if (noteId != null) 'noteId': noteId.getOrCrash(),
        if (pinned != null) 'pinned': pinned,
        'sortBy': sortBy.value,
        'orderBy': orderBy.value,
        'page': pagination.page,
        'size': pagination.size,
      },
      cancelToken: cancelToken,
    );
  }

  /// Fetches a single note by its remote id.
  Future<NoteDto> getNote(String noteId) {
    return _http.get('/notes/$noteId', fromJson: NoteDto.fromJson);
  }

  /// Updates an existing note.
  Future<NoteDto> updateNote(String noteId, NoteDto dto) {
    return _http.put(
      '/notes/$noteId',
      data: {'title': dto.title, 'content': dto.content, 'pinned': dto.pinned},
      fromJson: NoteDto.fromJson,
    );
  }

  /// Deletes a note. Throws [MenoException] on failure.
  Future<void> deleteNote(String noteId) {
    return _http.deleteUnit('/notes/$noteId');
  }

  /// Adds a note to a folder and returns the updated [NoteDto] with the
  /// folder relation populated.
  Future<NoteDto> addNoteToFolder({
    required String noteId,
    required String folderId,
  }) {
    return _http.put(
      '/notes/$noteId/folders/$folderId',
      fromJson: NoteDto.fromJson,
    );
  }

  /// Removes a note from its folder.
  Future<void> removeNoteFromFolder({
    required String noteId,
    required String folderId,
  }) => _http.deleteUnit('/notes/$noteId/folders/$folderId');

  // ===========================================================================
  // FOLDERS
  // ===========================================================================

  /// Fetches one page of folders.
  Future<PagedList<NoteFolderDto>> getFolders({
    SingleLineString? title,
    Id? folderId,
    bool? pinned,
    SortBy sortBy = SortBy.createdAt,
    OrderBy orderBy = OrderBy.desc,
    PaginationParams pagination = const PaginationParams(),
    CancelToken? cancelToken,
  }) {
    return _http.get(
      '/folders/',
      fromJson: (json) => PagedList<NoteFolderDto>.fromJson(
        json,
        NoteFolderDto.fromJson,
        listKey: 'folders',
      ),
      queryParameters: {
        if (title != null) 'title': title.getOrCrash(),
        if (folderId != null) 'folderId': folderId.getOrCrash(),
        if (pinned != null) 'pinned': pinned,
        'sortBy': sortBy.value,
        'orderBy': orderBy.value,
        'page': pagination.page,
        'size': pagination.size,
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
    Id folderId, {
    String? keywords,
    bool? pinned,
    SortBy sortBy = SortBy.createdAt,
    OrderBy orderBy = OrderBy.desc,
    PaginationParams pagination = const PaginationParams(),
    CancelToken? cancelToken,
  }) {
    return _http.get(
      '/folders/${folderId.getOrCrash()}',
      fromJson: FolderWithNotes.fromJson,
      queryParameters: {
        'includeNotes': true,
        if (keywords != null) 'keywords': keywords,
        if (pinned != null) 'pinned': pinned,
        'sortBy': sortBy.value,
        'orderBy': orderBy.value,
        'page': pagination.page,
        'size': pagination.size,
      },
      cancelToken: cancelToken,
    );
  }

  /// Fetches a single folder together without notes.
  Future<NoteFolder> getFolder(String folderId, {CancelToken? cancelToken}) {
    return _http.get(
      '/folders/$folderId',
      fromJson: (json) => NoteFolderDto.fromJson(json).toDomain,
      queryParameters: {'includeNotes': false},
      cancelToken: cancelToken,
    );
  }

  /// Creates a new folder on the remote.
  Future<NoteFolder> createFolder(NoteFolderDto dto) {
    return _http.post(
      '/folders',
      data: {'title': dto.title},
      fromJson: (json) => NoteFolderDto.fromJson(json).toDomain,
    );
  }

  /// Updates an existing folder's title and/or pinned state.
  Future<NoteFolder> updateFolder(String folderId, NoteFolderDto dto) {
    return _http.put(
      '/folders/$folderId',
      data: {'title': dto.title, 'pinned': dto.pinned},
      fromJson: (json) => NoteFolderDto.fromJson(json).toDomain,
    );
  }

  /// Deletes a folder. Notes inside are detached on the server side.
  Future<void> deleteFolder(String folderId) {
    return _http.deleteUnit('/folders/$folderId');
  }
}
