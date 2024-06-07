import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_creator.freezed.dart';

@freezed
class NoteCreator with _$NoteCreator {
  factory NoteCreator({
    int? dbId,
    required String id,
    required String fullName,
    required String email,
    String? imageUrl,
  }) = _NoteCreator;

  factory NoteCreator.empty() => NoteCreator(
        id: '',
        fullName: '',
        imageUrl: '',
        email: '',
      );
}
