import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_response.freezed.dart';
part 'chat_response.g.dart';

@Freezed(genericArgumentFactories: true)
class ChatResponse<T> with _$ChatResponse<T> {
  factory ChatResponse({
    int? statusCode,
    String? message,
    T? data,
    bool? status,
  }) = _ChatResponse;

  factory ChatResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ChatResponseFromJson(json, fromJsonT);
}
