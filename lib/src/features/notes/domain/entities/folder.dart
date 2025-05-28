import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/note.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

part 'folder.freezed.dart';

@freezed
class Folder with _$Folder {
  factory Folder({
    required ID id,
    required SingleLineString title,
    int? dbId,
    int? numberOfNotes,
    bool? pinned,
    DateTime? createdAt,
    @Default([]) List<Note?> notes,
  }) = _Folder;

  factory Folder.empty() => Folder(
        id: ID.fromString(''),
        title: SingleLineString(''),
      );
}
