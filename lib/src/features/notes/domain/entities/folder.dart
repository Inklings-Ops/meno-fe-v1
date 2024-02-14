import 'package:freezed_annotation/freezed_annotation.dart';

import '../inputs/i_folder_title.dart';

part 'folder.freezed.dart';

@freezed
class Folder with _$Folder {
  factory Folder({
    required String id,
    required IFolderTitle title,
    int? numberOfNotes,
    bool? pinned,
    DateTime? createdAt,
  }) = _Folder;
}
