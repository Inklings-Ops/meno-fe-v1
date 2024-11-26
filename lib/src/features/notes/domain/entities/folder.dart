import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/note.dart';
import 'package:meno_fe_v1/src/features/notes/domain/value_objects/folder_title.dart';
import 'package:meno_fe_v1/src/shared/value_objects/uid.dart';

part 'folder.freezed.dart';

@freezed
class Folder with _$Folder {
  factory Folder({
    required Uid<Folder> id,
    required FolderTitle title,
    int? dbId,
    int? numberOfNotes,
    bool? pinned,
    DateTime? createdAt,
    @Default([]) List<Note?> notes,
  }) = _Folder;

  factory Folder.empty() => Folder(
        id: Uid.fromString(''),
        title: FolderTitle(''),
      );
}
