import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation.freezed.dart';

@freezed
class Translation with _$Translation {
  const factory Translation({
    String? name,
  }) = _Translation;

  factory Translation.empty() => const Translation(name: 'kjv');
}
