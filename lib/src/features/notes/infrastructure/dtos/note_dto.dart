import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';
import 'package:objectbox/objectbox.dart';

part 'note_dto.freezed.dart';
part 'note_dto.g.dart';

@Freezed(addImplicitFinal: false)
@JsonSerializable(explicitToJson: true, createFactory: false)
class NoteDto with _$NoteDto {
  @Entity(realClass: NoteDto)
  factory NoteDto({
    required String title,
    required String content,
    @_FolderConverter() required ToOne<FolderDto> folder,
    @_CreatorConverter() required ToOne<NoteCreatorDto> creator,
    @JsonKey(name: 'id') required String uid,
    @Id(assignable: true)
    @JsonKey(includeFromJson: false, includeToJson: false)
    int? id,
    bool? pinned,
    @Property(type: PropertyType.date) DateTime? createdAt,
    @Property(type: PropertyType.date) DateTime? updatedAt,
  }) = _NoteDto;

  NoteDto._();

  factory NoteDto.fromJson(Map<String, dynamic> json) =>
      _$NoteDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NoteDtoToJson(this);
}

typedef _Map = Map<String, dynamic>;

class _FolderConverter implements JsonConverter<ToOne<FolderDto>, _Map?> {
  const _FolderConverter();

  @override
  ToOne<FolderDto> fromJson(_Map? json) {
    return ToOne<FolderDto>(
      target: json == null ? null : FolderDto.fromJson(json),
    );
  }

  @override
  _Map? toJson(ToOne<FolderDto> rel) => rel.target?.toJson();
}

class _CreatorConverter implements JsonConverter<ToOne<NoteCreatorDto>, _Map?> {
  const _CreatorConverter();

  @override
  ToOne<NoteCreatorDto> fromJson(_Map? json) {
    return ToOne<NoteCreatorDto>(
      target: json == null ? null : NoteCreatorDto.fromJson(json),
    );
  }

  @override
  _Map? toJson(ToOne<NoteCreatorDto> rel) => rel.target?.toJson();
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
      folder: folder.target?.toDomain,
      creator: creator.target?.toDomain,
    );
  }
}

extension NoteDomainToDto on Note {
  NoteDto get toDto {
    return NoteDto(
      uid: uid.getOr(),
      title: title.getOr(),
      content: content.getOr(),
      pinned: pinned,
      createdAt: createdAt,
      updatedAt: updatedAt,
      folder: ToOne()..target = folder?.toDto,
      creator: ToOne()..target = creator?.toDto,
    );
  }
}
