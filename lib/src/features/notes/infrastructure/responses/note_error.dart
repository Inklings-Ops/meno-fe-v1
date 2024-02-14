import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_error.freezed.dart';
part 'note_error.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  createFactory: false,
)
class NoteError with _$NoteError {
  factory NoteError({
    String? title,
    String? content,
    String? pinned,
  }) = _NoteError;

  NoteError._();

  factory NoteError.fromJson(Map<String, dynamic> json) =>
      _$NoteErrorFromJson(json);

  List<String?> get props => [
        title,
        content,
        pinned,
      ];

  bool get hasError {
    return [
      title,
      content,
      pinned,
    ].any((prop) => prop != null);
  }
}
