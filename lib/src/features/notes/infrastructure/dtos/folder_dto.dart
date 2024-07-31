import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/features/notes/infrastructure/dtos/note_dto.dart';
import 'package:objectbox/objectbox.dart';

part 'folder_dto.freezed.dart';
part 'folder_dto.g.dart';

@Freezed(addImplicitFinal: false)
@JsonSerializable(explicitToJson: true, createFactory: false)
class FolderDto with _$FolderDto {
  @Entity(realClass: FolderDto)
  factory FolderDto({
    @Unique() required String id, required String title, @Id() int? dbId,
    int? numberOfNotes,
    bool? pinned,
    @Property(type: PropertyType.date) DateTime? createdAt,
    List<NoteDto?>? notes,
  }) = _FolderDto;

  FolderDto._();

  factory FolderDto.fromJson(Map<String, dynamic> json) =>
      _$FolderDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FolderDtoToJson(this);
}

extension FolderDtoToDomain on FolderDto {
  Folder get toDomain {
    return Folder(
      dbId: dbId,
      id: id,
      title: FolderTitle(title),
      numberOfNotes: numberOfNotes,
      pinned: pinned,
      createdAt: createdAt,
      notes: notes?.map((e) => e?.toDomain).toList(),
    );
  }
}

extension FolderToDto on Folder {
  FolderDto get toDto {
    return FolderDto(
      dbId: dbId,
      id: id,
      title: title.getOr(),
      numberOfNotes: numberOfNotes,
      pinned: pinned,
      createdAt: createdAt,
      notes: notes?.map((e) => e?.toDto).toList(),
    );
  }
}
