import 'package:freezed_annotation/freezed_annotation.dart';

part 'bible_response.freezed.dart';
part 'bible_response.g.dart';

@Freezed(genericArgumentFactories: true)
sealed class BibleResponse<T> with _$BibleResponse<T> {
  const factory BibleResponse({
    required T data,
    String? message,
    bool? success,
  }) = _BibleResponse;

  factory BibleResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) =>
      _$BibleResponseFromJson(json, fromJsonT);
}
