import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';
import 'folder_dto.dart';
import 'note_creator_dto.dart';

part 'note_dto.freezed.dart';
part 'note_dto.g.dart';

@freezed
@JsonSerializable(explicitToJson: true, createFactory: false)
class NoteDto with _$NoteDto {
  factory NoteDto({
    required String id,
    required String title,
    required String content,
    required bool pinned,
    required DateTime createdAt,
    required DateTime updatedAt,
    required FolderDto folder,
    required NoteCreatorDto creator,
  }) = _NoteDto;

  factory NoteDto.fromJson(Map<String, dynamic> json) =>
      _$NoteDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NoteDtoToJson(this);
}

extension NoteDtoToDomain on NoteDto {
  Note get toDomain {
    return Note(
      id: id,
      title: INoteTitle(title),
      content: INoteContent(content),
      pinned: pinned,
      createdAt: createdAt,
      updatedAt: updatedAt,
      folder: folder.toDomain,
      creator: creator.toDomain,
    );
  }
}

extension NoteToDto on Note {
  NoteDto get toDomain {
    return NoteDto(
      id: id,
      title: title.get()!,
      content: content.get()!,
      pinned: pinned,
      createdAt: createdAt,
      updatedAt: updatedAt,
      folder: folder.toDto,
      creator: creator.toDto,
    );
  }
}
