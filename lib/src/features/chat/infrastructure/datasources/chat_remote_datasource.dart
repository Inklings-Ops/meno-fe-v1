import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/response/response.dart' show BaseResponse;
import 'package:meno_fe_v1/src/features/chat/chat.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_remote_datasource.g.dart';

@injectable
@RestApi()
abstract class ChatRemoteDatasource {
  /// Creates a new `ChatRemoteDatasource` object.
  @factoryMethod
  factory ChatRemoteDatasource(
    Dio dio, {
    @Named('baseUrl') String baseUrl,
  }) = _ChatRemoteDatasource;

  @GET('/api/v1/chat-messages')
  Future<BaseResponse<PaginatedChatMessages<ChatDto?>>> chatMessages({
    @Query('broadcastId') required String broadcastId,
    @Query('orderBy') String? orderBy,
    @Query('page') int? page,
    @Query('size') int? size,
  });
}
