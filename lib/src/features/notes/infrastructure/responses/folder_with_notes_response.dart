import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/notes/infrastructure/dtos/dtos.dart';
import 'package:meno_fe_v1/src/features/notes/infrastructure/responses/note_meta_data.dart';

part 'folder_with_notes_response.freezed.dart';
part 'folder_with_notes_response.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class FolderWithNotesResponse with _$FolderWithNotesResponse {
  factory FolderWithNotesResponse({
    required FolderDto folder,
    required List<NoteDto?> notes,
    required NoteMetaData noteMetadata,
  }) = _FolderWithNotesResponse;

  factory FolderWithNotesResponse.fromJson(Map<String, dynamic> json) =>
      _$FolderWithNotesResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FolderWithNotesResponseToJson(this);
}
