import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/broadcast/infrastructure/responses/broadcast_error.dart';

part 'broadcast_response.freezed.dart';
part 'broadcast_response.g.dart';

@Freezed(genericArgumentFactories: true)
class BroadcastResponse<T> with _$BroadcastResponse<T> {
  factory BroadcastResponse({
    int? statusCode,
    String? message,
    BroadcastError? error,
    String? path,
    bool? status,
    T? data,
  }) = _BroadcastResponse;

  factory BroadcastResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$BroadcastResponseFromJson(json, fromJsonT);
}
