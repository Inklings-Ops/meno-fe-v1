import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'note_error.dart';

part 'note_response.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  genericArgumentFactories: true,
)
class NoteResponse<T> extends Equatable {
  final int? statusCode;
  final String? message;
  final NoteError? error;
  final String? path;
  final bool? status;
  final T? data;

  const NoteResponse({
    this.statusCode,
    this.message,
    this.error,
    this.path,
    this.status,
    this.data,
  });

  factory NoteResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$NoteResponseFromJson<T>(json, fromJsonT);

  @override
  List<Object?> get props => [statusCode, message, error, path, status, data];

  Map<String, dynamic> toJson(Object Function(T) toJsonT) =>
      _$NoteResponseToJson<T>(this, toJsonT);
}
