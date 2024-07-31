import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:retrofit/retrofit.dart';

part 'note_remote_datasource.g.dart';

@RestApi()
abstract class NoteRemoteDatasource {
  @factoryMethod
  factory NoteRemoteDatasource(Dio dio, {String baseUrl}) =
      _NoteRemoteDatasource;

  @GET('/api/v1/notes/')
  Future<NoteResponse<NoteListResponse>> getAllNotes({
    @Query('keywords') String? keywords,
    @Query('noteId') String? noteId,
    @Query('pinned') bool? pinned,
    @Query('sortBy') String? sortBy = 'createdAt',
    @Query('orderBy') String? orderBy = 'DESC',
    @Query('page') int? page = 1,
    @Query('size') int? size = 1,
  });

  @POST('/api/v1/notes')
  Future<NoteResponse<NoteDto?>> createNote({
    @Field() required String title,
    @Field() required String content,
  });

  @GET('/api/v1/notes/{noteId}')
  Future<NoteResponse<NoteDto?>> getNote(@Path('noteId') String noteId);

  @PUT('/api/v1/notes/{noteId}')
  Future<NoteResponse<NoteDto?>> updateNote({
    @Path('noteId') required String noteId,
    @Field() String? title,
    @Field() String? content,
    @Field() bool? pinned,
  });

  @DELETE('/api/v1/notes/{noteId}')
  Future<NoteResponse<dynamic>> deleteNote(@Path('noteId') String noteId);

  @PUT('/api/v1/notes/{noteId}/folders/{folderId}')
  Future<NoteResponse<NoteDto?>> addNoteToFolder({
    @Path('noteId') required String noteId,
    @Path('folderId') required String folderId,
  });

  @DELETE('/api/v1/notes/{noteId}/folders/{folderId}')
  Future<NoteResponse<dynamic>> removeNoteFromFolder({
    @Path('noteId') required String noteId,
    @Path('folderId') required String folderId,
  });

  @GET('/api/v1/folders/')
  Future<NoteResponse<FolderListResponse>> getAllFolders({
    @Query('title') String? title,
    @Query('folderId') String? folderId,
    @Query('pinned') bool? pinned,
    @Query('sortBy') String? sortBy = 'createdAt',
    @Query('orderBy') String? orderBy = 'DESC',
    @Query('page') int? page = 1,
    @Query('size') int? size = 1,
  });

  @POST('/api/v1/folders')
  Future<NoteResponse<FolderDto?>> createFolder({
    @Field() required String title,
  });

  @GET('/api/v1/folders/{folderId}')
  Future<NoteResponse<FolderResponse>> getFolder({
    @Path('folderId') required String folderId,
    @Query('includeNotes') bool includeNotes = false,
    @Query('keywords') String? keywords,
    @Query('pinned') bool? pinned,
  });

  @GET('/api/v1/folders/{folderId}')
  Future<NoteResponse<FolderWithNotesResponse>> getFolderWithNotes({
    @Path('folderId') required String folderId,
    @Query('includeNotes') bool includeNotes = true,
    @Query('keywords') String? keywords,
    @Query('pinned') bool? pinned,
    @Query('sortBy') String? sortBy = 'createdAt',
    @Query('orderBy') String? orderBy = 'DESC',
    @Query('page') int? page = 1,
    @Query('size') int? size = 1,
  });

  @PUT('/api/v1/folders/{folderId}')
  Future<NoteResponse<FolderDto?>> updateFolder({
    @Path('folderId') required String folderId,
    @Field() String? title,
    @Field() bool? pinned,
  });

  @DELETE('/api/v1/folders/{folderId}')
  Future<NoteResponse<dynamic>> deleteFolder(@Path('folderId') String folderId);
}
