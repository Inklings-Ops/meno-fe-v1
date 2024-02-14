import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';

 
part 'folder_dto.freezed.dart';
part 'folder_dto.g.dart';

@freezed
@JsonSerializable(explicitToJson: true, createFactory: false)
class FolderDto with _$FolderDto {
  factory FolderDto({
    required String id,
    required String title,
    int? numberOfNotes,
    bool? pinned,
    DateTime? createdAt,
  }) = _FolderDto;

  factory FolderDto.fromJson(Map<String, dynamic> json) =>
      _$FolderDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FolderDtoToJson(this);
}

extension FolderDtoToDomain on FolderDto {
  Folder get toDomain {
    return Folder(
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
      id: id,
      title: title.get()!,
      numberOfNotes: numberOfNotes,
      pinned: pinned,
      createdAt: createdAt,
    );
  }
}
