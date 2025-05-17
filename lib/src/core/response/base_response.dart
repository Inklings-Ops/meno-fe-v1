import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
final class BaseResponse<T> with EquatableMixin {
  const BaseResponse({
    this.statusCode,
    this.message,
    this.success,
    this.status,
    this.data,
    this.path,
    this.error,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$BaseResponseFromJson(json, fromJsonT);

  final int? statusCode;
  final String? message;
  final bool? success;
  final bool? status;
  final T? data;
  final String? path;
  final dynamic error;

  @override
  List<Object?> get props => [
    statusCode,
    message,
    success,
    status,
    data,
    path,
    error,
  ];

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);

  @override
  String toString() {
    return '''
BaseResponse{statusCode=$statusCode, message=$message, success=$success, status=$status, data=$data, path=$path, error=$error}''';
  }
}
