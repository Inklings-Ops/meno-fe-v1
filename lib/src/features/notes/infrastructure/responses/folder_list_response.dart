import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/notes/infrastructure/dtos/dtos.dart';

part 'folder_list_response.freezed.dart';
part 'folder_list_response.g.dart';

@freezed
@JsonSerializable(explicitToJson: true, createFactory: false)
class FolderListResponse with _$FolderListResponse {
  factory FolderListResponse({
    required List<FolderDto?> folders,
    required int totalPages,
    required int currentPage,
    required int totalItems,
  }) = _FolderListResponse;

  factory FolderListResponse.fromJson(Map<String, dynamic> json) =>
      _$FolderListResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FolderListResponseToJson(this);
}
