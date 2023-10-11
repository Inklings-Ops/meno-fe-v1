// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BroadcastResponse<T> _$BroadcastResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    BroadcastResponse<T>(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      error: json['error'] == null
          ? null
          : BroadcastError.fromJson(json['error'] as Map<String, dynamic>),
      path: json['path'] as String?,
      status: json['status'] as bool?,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
    );

Map<String, dynamic> _$BroadcastResponseToJson<T>(
  BroadcastResponse<T> instance,
  Object? Function(T value) toJsonT,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('statusCode', instance.statusCode);
  writeNotNull('message', instance.message);
  writeNotNull('error', instance.error?.toJson());
  writeNotNull('path', instance.path);
  writeNotNull('status', instance.status);
  writeNotNull('data', _$nullableGenericToJson(instance.data, toJsonT));
  return val;
}

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
