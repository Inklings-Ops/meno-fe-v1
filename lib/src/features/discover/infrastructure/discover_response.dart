import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/infrastructure/responses/broadcast_error.dart';

part 'discover_response.freezed.dart';
part 'discover_response.g.dart';

@Freezed(genericArgumentFactories: true)
class DiscoverResponse<T> with _$DiscoverResponse<T> {
  factory DiscoverResponse({
    required int? statusCode,
    required String? message,
    required BroadcastError? error,
    required String? path,
    required bool? status,
    required T? data,
  }) = _DiscoverResponse;

  factory DiscoverResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$DiscoverResponseFromJson(json, fromJsonT);
}
