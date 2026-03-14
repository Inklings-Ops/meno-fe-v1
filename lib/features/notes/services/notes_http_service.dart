import 'package:dio/dio.dart' show CancelToken;
import 'package:meno/_core/exceptions/meno_exception.dart';
import 'package:meno/_core/value_objects/paged_list.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/notes/model/_model.dart';

class NotesHttpService {
  const NotesHttpService(this._http);

  final HttpClient _http;

  // ========================================================================
  // NOTES
  // ========================================================================
  /// Creates a new note on the remote and returns the persisted [NoteDto].
  Future<NoteDto> createNote({required String ownerId, required NoteDto dto}) {
    return _http.post(
      '/notes',
      data: {'title': dto.title, 'content': dto.content},
      fromJson: (json) => NoteDto.fromJson(json, ownerId),
    );
  }

  /// Fetches paginated list of notes.
  Future<PagedList<NoteDto>> getNotes(
    String ownerId, {
    String? noteId,
    SortBy sortBy = SortBy.updatedAt,
    OrderBy orderBy = OrderBy.desc,
    PaginationParams pagination = const PaginationParams(),
    String? keywords,
    bool? pinned,
    CancelToken? cancelToken,
  }) {
    return _http.get(
      '/notes/',
      fromJson: (json) => PagedList<NoteDto>.fromJson(
        json,
        (jsonT) => NoteDto.fromJson(jsonT, ownerId),
        listKey: 'notes',
      ),
      queryParameters: {
        if (keywords != null) 'keywords': keywords,
        if (noteId != null) 'noteId': noteId,
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
  Future<NoteDto> getNote({required String ownerId, required String noteId}) {
    return _http.get(
      '/notes/$noteId',
      fromJson: (json) => NoteDto.fromJson(json, ownerId),
    );
  }

  /// Updates an existing note.
  Future<NoteDto> updateNote({required String ownerId, required NoteDto dto}) {
    return _http.put(
      '/notes/${dto.id}',
      data: {'title': dto.title, 'content': dto.content, 'pinned': dto.pinned},
      fromJson: (json) => NoteDto.fromJson(json, ownerId),
    );
  }

  /// Deletes a note. Throws [MenoException] on failure.
  Future<void> deleteNote(String noteId) {
    return _http.deleteUnit('/notes/$noteId');
  }

  /// Adds a note to a folder and returns the updated [NoteDto] with the
  /// folder relation populated.
  Future<NoteDto> addNoteToFolder({
    required String ownerId,
    required String noteId,
    required String folderId,
  }) {
    return _http.put(
      '/notes/$noteId/folders/$folderId',
      fromJson: (json) => NoteDto.fromJson(json, ownerId),
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
  Future<PagedList<NoteFolderDto>> getFolders(
    String ownerId, {
    String? folderId,
    String? title,
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
        (jsonT) => NoteFolderDto.fromJson(json, ownerId: ownerId),
        listKey: 'folders',
      ),
      queryParameters: {
        if (title != null) 'title': title,
        if (folderId != null) 'folderId': folderId,
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
  Future<FolderWithNotes> getFolderWithNotes({
    required String ownerId,
    required String folderId,
    String? keywords,
    bool? pinned,
    SortBy sortBy = SortBy.createdAt,
    OrderBy orderBy = OrderBy.desc,
    PaginationParams pagination = const PaginationParams(),
    CancelToken? cancelToken,
  }) {
    return _http.get(
      '/folders/$folderId',
      fromJson: (json) => FolderWithNotes.fromJson(json, ownerId: ownerId),
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
  Future<NoteFolder> getFolder({
    required String ownerId,
    required String folderId,
    CancelToken? cancelToken,
  }) {
    return _http.get(
      '/folders/$folderId',
      fromJson: (e) => NoteFolderDto.fromJson(e, ownerId: ownerId).toDomain,
      queryParameters: {'includeNotes': false},
      cancelToken: cancelToken,
    );
  }

  /// Creates a new folder on the remote.
  Future<NoteFolder> createFolder({
    required String ownerId,
    required NoteFolderDto dto,
  }) {
    return _http.post(
      '/folders',
      data: {'title': dto.title},
      fromJson: (e) => NoteFolderDto.fromJson(e, ownerId: ownerId).toDomain,
    );
  }

  /// Updates an existing folder's title and/or pinned state.
  Future<NoteFolder> updateFolder({
    required String ownerId,
    required NoteFolderDto dto,
  }) {
    return _http.put(
      '/folders/${dto.id}',
      data: {'title': dto.title, 'pinned': dto.pinned},
      fromJson: (e) => NoteFolderDto.fromJson(e, ownerId: ownerId).toDomain,
    );
  }

  /// Deletes a folder. Notes inside are detached on the server side.
  Future<void> deleteFolder(String folderId) {
    return _http.deleteUnit('/folders/$folderId');
  }
}
