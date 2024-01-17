import 'package:freezed_annotation/freezed_annotation.dart';

part 'm_response.freezed.dart';
part 'm_response.g.dart';

@Freezed(genericArgumentFactories: true)
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
sealed class MResponse<T> with _$MResponse<T> {
  const factory MResponse.data({
    @_Converter() T? data,
    int? statusCode,
    String? message,
    String? path,
    bool? status,
  }) = MResponseData;

  const factory MResponse.error({
    @_Converter() T? error,
    int? statusCode,
    String? message,
    String? path,
    bool? status,
  }) = MResponseError;

  factory MResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$MResponseFromJson(json, fromJsonT);
}

class _Converter<T> implements JsonConverter<T?, Map<String, dynamic>> {
  const _Converter();

  @override
  T? fromJson(Map<String, dynamic> json) {
    if (json['runtimeType'] != null) {
      return null;
    }

    if (json['error'] != null) {
      return  json['error'] as T?;
    }

    return json['data'] as T?;
  }

  @override
  Map<String, dynamic> toJson(T? data) => throw UnimplementedError();
}
