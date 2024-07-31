import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:meno_fe_v1/src/features/auth/infrastructure/responses/auth_field_error.dart';

part 'auth_response.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  genericArgumentFactories: true,
)
class AuthResponse<T> extends Equatable {
  const AuthResponse({
    this.statusCode,
    this.message,
    this.error,
    this.path,
    this.status,
    this.data,
  });

  factory AuthResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$AuthResponseFromJson<T>(json, fromJsonT);

  final int? statusCode;
  final String? message;
  final AuthFieldError? error;
  final String? path;
  final bool? status;
  final T? data;

  Map<String, dynamic> toJson(Object Function(T) toJsonT) =>
      _$AuthResponseToJson<T>(this, toJsonT);

  @override
  List<Object?> get props => [statusCode, message, error, path, status, data];
}
