import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation.freezed.dart';

@freezed
class Translation with _$Translation {
  const factory Translation({
    required String name, required String abbreviation, int? id,
  }) = _Translation;
}
