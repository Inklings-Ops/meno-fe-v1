import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/response/response.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:retrofit/retrofit.dart';

part 'note_remote_datasource.g.dart';

@injectable
@RestApi()
abstract class NoteRemoteDatasource {
  @factoryMethod
  factory NoteRemoteDatasource(
    Dio dio, {
    @Named('baseUrl') String baseUrl,
  }) = _NoteRemoteDatasource;

  @GET('/api/v1/notes/')
  Future<BaseResponse<PaginatedNotes<NoteDto?>>> getAllNotes({
    @Query('keywords') String? keywords,
    @Query('noteId') String? noteId,
    @Query('pinned') bool? pinned,
    @Query('sortBy') String? sortBy = 'createdAt',
    @Query('orderBy') String? orderBy = 'DESC',
    @Query('page') int? page = 1,
    @Query('size') int? size = 1,
    @CancelRequest() CancelToken? cancelToken,
  });

  @POST('/api/v1/notes')
  Future<BaseResponse<NoteDto?>> createNote({
    @Field() required String title,
    @Field() required String content,
  });

  @GET('/api/v1/notes/{noteId}')
  Future<BaseResponse<NoteDto?>> getNote(@Path('noteId') String noteId);

  @PUT('/api/v1/notes/{noteId}')
  Future<BaseResponse<NoteDto?>> updateNote({
    @Path('noteId') required String noteId,
    @Field() String? title,
    @Field() String? content,
    @Field() bool? pinned,
  });

  @DELETE('/api/v1/notes/{noteId}')
  Future<BaseResponse<dynamic>> deleteNote(@Path('noteId') String noteId);

  @PUT('/api/v1/notes/{noteId}/folders/{folderId}')
  Future<BaseResponse<NoteDto?>> addNoteToFolder({
    @Path('noteId') required String noteId,
    @Path('folderId') required String folderId,
  });

  @DELETE('/api/v1/notes/{noteId}/folders/{folderId}')
  Future<BaseResponse<dynamic>> removeNoteFromFolder({
    @Path('noteId') required String noteId,
    @Path('folderId') required String folderId,
  });

  @GET('/api/v1/folders/')
  Future<BaseResponse<PaginatedFolders<FolderDto?>>> getAllFolders({
    @Query('title') String? title,
    @Query('folderId') String? folderId,
    @Query('pinned') bool? pinned,
    @Query('sortBy') String? sortBy = 'createdAt',
    @Query('orderBy') String? orderBy = 'DESC',
    @Query('page') int? page = 1,
    @Query('size') int? size = 1,
  });

  @POST('/api/v1/folders')
  Future<BaseResponse<FolderDto?>> createFolder({
    @Field() required String title,
  });

  @GET('/api/v1/folders/{folderId}')
  Future<BaseResponse<FolderDto>> getFolder({
    @Path('folderId') required String folderId,
    @Query('includeNotes') bool includeNotes = false,
    @Query('keywords') String? keywords,
    @Query('pinned') bool? pinned,
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET('/api/v1/folders/{folderId}')
  Future<BaseResponse<FolderWithNotesResponse>> getFolderWithNotes({
    @Path('folderId') required String folderId,
    @Query('includeNotes') bool includeNotes = true,
    @Query('keywords') String? keywords,
    @Query('pinned') bool? pinned,
    @Query('sortBy') String? sortBy = 'createdAt',
    @Query('orderBy') String? orderBy = 'DESC',
    @Query('page') int? page = 1,
    @Query('size') int? size = 1,
    @CancelRequest() CancelToken? cancelToken,
  });

  @PUT('/api/v1/folders/{folderId}')
  Future<BaseResponse<FolderDto?>> updateFolder({
    @Path('folderId') required String folderId,
    @Field() String? title,
    @Field() bool? pinned,
  });

  @DELETE('/api/v1/folders/{folderId}')
  Future<BaseResponse<dynamic>> deleteFolder(@Path('folderId') String folderId);
}
