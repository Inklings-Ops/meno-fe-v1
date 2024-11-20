import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/note.dart';
import 'package:meno_fe_v1/src/features/notes/domain/value_objects/folder_title.dart';

part 'folder.freezed.dart';

@freezed
class Folder with _$Folder {
  factory Folder({
    required String id,
    required FolderTitle title,
    int? dbId,
    int? numberOfNotes,
    bool? pinned,
    DateTime? createdAt,
    List<Note?>? notes,
  }) = _Folder;

  factory Folder.empty() => Folder(id: '', title: FolderTitle(''));
}
