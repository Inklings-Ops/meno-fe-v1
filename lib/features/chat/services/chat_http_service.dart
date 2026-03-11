import 'package:dio/dio.dart' show CancelToken;
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/chat/model/_model.dart';

final class ChatHttpService {
  const ChatHttpService(this._client);

  final HttpClient _client;

  Future<PagedList<Message>> getMessages(
    String broadcastId, {
    OrderBy orderBy = OrderBy.desc,
    PaginationParams pagination = const PaginationParams(size: 100),
    CancelToken? cancelToken,
  }) {
    return _client.get(
      '/chat-messages',
      fromJson: (json) => PagedList.fromJson(
        json,
        (jsonT) => MessageDto.fromJson(jsonT).toDomain,
        listKey: 'chatMessages',
      ),
      cancelToken: cancelToken,
      queryParameters: {
        'broadcastId': broadcastId,
        'page': pagination.page,
        'size': pagination.size,
        'orderBy': orderBy.value,
      },
    );
  }
}
