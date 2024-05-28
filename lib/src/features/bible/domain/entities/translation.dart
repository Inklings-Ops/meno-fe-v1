import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation.freezed.dart';

@freezed
class Translation with _$Translation {
  const factory Translation({
    int? id,
    required String name,
    required String abbreviation,
  }) = _Translation;
}
