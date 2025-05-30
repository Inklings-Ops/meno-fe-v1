import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

part 'folder_dto.g.dart';

@JsonSerializable()
class FolderDto with EquatableMixin {
  const FolderDto({
    required this.id,
    required this.title,
    this.notes = const <NoteDto?>[],
    this.numberOfNotes,
    this.pinned,
    this.createdAt,
  });

  factory FolderDto.fromJson(Map<String, dynamic> json) =>
      _$FolderDtoFromJson(json);

  final String id;
  final String title;
  final List<NoteDto?> notes;
  final int? numberOfNotes;
  final bool? pinned;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() => _$FolderDtoToJson(this);

  @override
  List<Object?> get props => [
        id,
        title,
        notes,
        numberOfNotes,
        pinned,
        createdAt,
      ];
}

extension FolderDtoToDomain on FolderDto {
  Folder get toDomain {
    return Folder(
      id: ID.fromString(id),
      title: SingleLineString(title),
      numberOfNotes: numberOfNotes,
      pinned: pinned,
      createdAt: createdAt,
      notes: notes.map((note) => note?.toDomain).toList(),
    );
  }
}

extension FolderToDto on Folder {
  FolderDto get toDto {
    return FolderDto(
      id: id.getOrCrash(),
      title: title.getOrCrash(),
      numberOfNotes: numberOfNotes,
      pinned: pinned,
      createdAt: createdAt,
      notes: notes.isNotEmpty ? notes.map((e) => e?.toDto).toList() : [],
    );
  }
}
