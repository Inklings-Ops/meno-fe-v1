import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';

import '../../domain/domain.dart';
import 'folder_dto.dart';
import 'note_creator_dto.dart';

part 'note_dto.freezed.dart';
part 'note_dto.g.dart';

@Freezed(addImplicitFinal: false)
@JsonSerializable(explicitToJson: true, createFactory: false)
class NoteDto with _$NoteDto {
  @Entity(realClass: NoteDto)
  factory NoteDto({
    @Id() int? dbId,
    @Unique() String? id,
    required String title,
    required String content,
    bool? pinned,
    @Property(type: PropertyType.date) DateTime? createdAt,
    @Property(type: PropertyType.date) DateTime? updatedAt,
    @_FToOneConverter() required ToOne<FolderDto> folder,
    @_CToOneConverter() required ToOne<NoteCreatorDto> creator,
  }) = _NoteDto;

  factory NoteDto.fromJson(Map<String, dynamic> json) =>
      _$NoteDtoFromJson(json);

  NoteDto._();

  @override
  Map<String, dynamic> toJson() => _$NoteDtoToJson(this);
}

extension NoteDtoToDomain on NoteDto {
  Note get toDomain {
    return Note(
      dbId: dbId,
      id: id,
      title: INoteTitle(title),
      content: INoteContent(content),
      pinned: pinned,
      createdAt: createdAt,
      updatedAt: updatedAt,
      folder: folder.target!.toDomain,
      creator: creator.target!.toDomain,
    );
  }
}

extension NoteToDto on Note {
  // NoteDto get toDomain {
  //   return NoteDto(
  //     dbId: dbId,
  //     id: id,
  //     title: title.get()!,
  //     content: content.get()!,
  //     pinned: pinned,
  //     createdAt: createdAt,
  //     updatedAt: updatedAt,
  //     folder: folder,
  //     creator: creator.toDto,
  //   );
  // }
}

class _FToOneConverter
    implements JsonConverter<ToOne<FolderDto>, Map<String, dynamic>?> {
  const _FToOneConverter();

  @override
  ToOne<FolderDto> fromJson(Map<String, dynamic>? json) =>
      ToOne<FolderDto>(target: json == null ? null : FolderDto.fromJson(json));

  @override
  Map<String, dynamic>? toJson(ToOne<FolderDto> rel) => rel.target?.toJson();
}

class _CToOneConverter
    implements JsonConverter<ToOne<NoteCreatorDto>, Map<String, dynamic>?> {
  const _CToOneConverter();

  @override
  ToOne<NoteCreatorDto> fromJson(Map<String, dynamic>? json) =>
      ToOne<NoteCreatorDto>(
          target: json == null ? null : NoteCreatorDto.fromJson(json));

  @override
  Map<String, dynamic>? toJson(ToOne<NoteCreatorDto> rel) =>
      rel.target?.toJson();
}
