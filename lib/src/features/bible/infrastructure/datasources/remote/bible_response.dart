import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bible_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
final class BibleResponse<T> with EquatableMixin {
  const BibleResponse({
    required this.data,
    this.message,
    this.success,
  });

  factory BibleResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) =>
      _$BibleResponseFromJson(json, fromJsonT);

  final T data;
  final String? message;
  final bool? success;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BibleResponseToJson(this, toJsonT);

  @override
  List<Object?> get props => [data, message, success];
}
