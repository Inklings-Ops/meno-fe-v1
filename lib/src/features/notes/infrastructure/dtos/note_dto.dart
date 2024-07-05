import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

import '../../domain/domain.dart';
import 'folder_dto.dart';
import 'note_creator_dto.dart';

part 'note_dto.freezed.dart';
part 'note_dto.g.dart';

@Freezed(addImplicitFinal: false)
@JsonSerializable(explicitToJson: true, createFactory: false)
class NoteDto with _$NoteDto {
  factory NoteDto({
    @JsonKey(name: 'id') required String uid,
    required String title,
    required String content,
    bool? pinned,
    FolderDto? folder,
    NoteCreatorDto? creator,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NoteDto;

  factory NoteDto.fromJson(Map<String, dynamic> json) =>
      _$NoteDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NoteDtoToJson(this);
}

extension NoteDtoToDomain on NoteDto {
  Note get toDomain {
    return Note(
      uid: Uid<Note>.fromString(uid),
      title: NoteTitle(title),
      content: NoteContent(content),
      pinned: pinned,
      createdAt: createdAt,
      updatedAt: updatedAt,
      folder: folder?.toDomain,
      creator: creator?.toDomain,
    );
  }
}

extension NoteDomainToDto on Note {
  NoteDto get toDto {
    return NoteDto(
      uid: uid.get()!,
      title: title.get()!,
      content: content.get()!,
      pinned: pinned,
      createdAt: createdAt,
      updatedAt: updatedAt,
      folder: folder?.toDto,
      creator: creator?.toDto,
    );
  }
}
