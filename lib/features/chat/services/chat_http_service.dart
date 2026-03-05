import 'package:dio/dio.dart' show CancelToken;
import 'package:meno/_shared/services/http_client.dart';

final class ChatHttpService {
  const ChatHttpService(this._client);

  final HttpClient _client;

  Future<dynamic> getMessages(
    String broadcastId, {
    CancelToken? cancelToken,
    int page = 1,
    int size = 100,
  }) {
    return _client.get(
      '/chat-messages',
      fromJson: (json) => json,
      cancelToken: cancelToken,
      queryParameters: {
        'broadcastId': broadcastId,
        'page': page,
        'size': size,
        'order_by': 'desc',
      },
    );
  }
}
