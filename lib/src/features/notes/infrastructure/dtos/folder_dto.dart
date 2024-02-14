import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';

import '../../domain/domain.dart';

part 'folder_dto.freezed.dart';
part 'folder_dto.g.dart';

@Freezed(addImplicitFinal: false)
@JsonSerializable(explicitToJson: true, createFactory: false)
class FolderDto with _$FolderDto {
  @Entity(realClass: FolderDto)
  factory FolderDto({
    @Id() int? dbId,
    @Unique() required String id,
    required String title,
    int? numberOfNotes,
    bool? pinned,
    @Property(type: PropertyType.date) DateTime? createdAt,
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
      title: IFolderTitle(title),
      numberOfNotes: numberOfNotes,
      pinned: pinned,
      createdAt: createdAt,
    );
  }
}

extension FolderToDto on Folder {
  FolderDto get toDto {
    return FolderDto(
      dbId: dbId,
      id: id,
      title: title.get()!,
      numberOfNotes: numberOfNotes,
      pinned: pinned,
      createdAt: createdAt,
    );
  }
}
