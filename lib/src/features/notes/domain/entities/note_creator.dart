import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_creator.freezed.dart';

@freezed
class NoteCreator with _$NoteCreator {
  factory NoteCreator({
    required String id,
    required String fullName,
    required String imageUrl,
  }) = _NoteCreator;
}
