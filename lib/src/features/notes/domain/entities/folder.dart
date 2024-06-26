import 'package:freezed_annotation/freezed_annotation.dart';

import '../inputs/i_folder_title.dart';
import 'note.dart';

part 'folder.freezed.dart';

@freezed
class Folder with _$Folder {
  factory Folder({
    int? dbId,
    required String id,
    required IFolderTitle title,
    int? numberOfNotes,
    bool? pinned,
    DateTime? createdAt,
    List<Note?>? notes,
  }) = _Folder;

  factory Folder.empty() => Folder(id: '', title: IFolderTitle(''));
  
}
