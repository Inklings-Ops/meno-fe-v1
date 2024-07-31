import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/notes/infrastructure/dtos/dtos.dart';

part 'folder_response.freezed.dart';
part 'folder_response.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class FolderResponse with _$FolderResponse {
  factory FolderResponse({
    required FolderDto folder,
  }) = _FolderResponse;

  factory FolderResponse.fromJson(Map<String, dynamic> json) =>
      _$FolderResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FolderResponseToJson(this);
}
