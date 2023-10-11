import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'broadcast_error.dart';

part 'broadcast_response.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  genericArgumentFactories: true,
)
class BroadcastResponse<T> extends Equatable {
  final int? statusCode;
  final String? message;
  final BroadcastError? error;
  final String? path;
  final bool? status;
  final T? data;

  const BroadcastResponse({
    this.statusCode,
    this.message,
    this.error,
    this.path,
    this.status,
    this.data,
  });

  factory BroadcastResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BroadcastResponseFromJson<T>(json, fromJsonT);

  @override
  List<Object?> get props => [statusCode, message, error, path, status, data];

  Map<String, dynamic> toJson(Object Function(T) toJsonT) =>
      _$BroadcastResponseToJson<T>(this, toJsonT);
}
