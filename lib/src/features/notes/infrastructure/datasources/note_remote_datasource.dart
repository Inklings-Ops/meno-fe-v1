import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../dtos/dtos.dart';
import '../responses/responses.dart';

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
    @Part() required String title,
    @Part() required String content,
  });

  @GET('/api/v1/notes/{noteId}')
  Future<NoteResponse<NoteDto?>> getNote(@Path('noteId') String noteId);

  @GET('/api/v1/notes/{noteId}')
  Future<NoteResponse<NoteDto?>> updateNote({
    @Path('noteId') required String noteId,
    @Part() String? title,
    @Part() String? content,
  });

  @DELETE('/api/v1/notes/{noteId}')
  Future<NoteResponse> deleteNote(@Path('noteId') String noteId);

  @PUT('/api/v1/notes/{noteId}/folders/{folderId}')
  Future<NoteResponse> addNoteToFolder({
    @Path('noteId') required String noteId,
    @Path('folderId') required String folderId,
  });

  @DELETE('/api/v1/notes/{noteId}/folders/{folderId}')
  Future<NoteResponse> removeNoteFromFolder({
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
    @Part() required String title,
  });

  @GET('/api/v1/folders/{folderId}')
  Future<NoteResponse<FolderDto?>> getFolder(@Path('folderId') String folderId);

  @PUT('/api/v1/folders/{folderId}')
  Future<NoteResponse<FolderDto?>> updateFolder({
    @Path('folderId') required String folderId,
    @Part() String? title,
  });

  @DELETE('/api/v1/folders/{folderId}')
  Future<NoteResponse> deleteFolder(@Path('folderId') String folderId);
}
