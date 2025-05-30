import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

part 'note_dto.g.dart';

@JsonSerializable()
class NoteDto with EquatableMixin {
  const NoteDto({
    required this.id,
    required this.title,
    required this.content,
    this.folder,
    this.creator,
    this.pinned,
    this.createdAt,
    this.updatedAt,
  });

  factory NoteDto.fromJson(Map<String, dynamic> json) =>
      _$NoteDtoFromJson(json);

  final String id;
  final String title;
  final String content;
  final FolderDto? folder;
  final NoteCreatorDto? creator;
  final bool? pinned;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$NoteDtoToJson(this);

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        folder,
        creator,
        pinned,
        createdAt,
        updatedAt,
      ];
}

extension NoteDtoToDomain on NoteDto {
  Note get toDomain {
    return Note(
      id: ID.fromString(id),
      title: SingleLineString(title),
      content: MultiLineString(content),
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
      id: id.getOrCrash(),
      title: title.getOrCrash(),
      content: content.getOrCrash(),
      pinned: pinned,
      createdAt: createdAt,
      updatedAt: updatedAt,
      folder: folder?.toDto,
      creator: creator?.toDto,
    );
  }
}
