import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:meno_fe_v1/src/features/notes/infrastructure/dtos/dtos.dart';
import 'package:meno_fe_v1/src/features/notes/infrastructure/responses/note_meta_data.dart';

part 'folder_with_notes_response.g.dart';

@JsonSerializable()
class FolderWithNotesResponse with EquatableMixin {
  const FolderWithNotesResponse({
    required this.folder,
    required this.notes,
    required this.noteMetadata,
  });

  factory FolderWithNotesResponse.fromJson(Map<String, dynamic> json) =>
      _$FolderWithNotesResponseFromJson(json);

  final FolderDto folder;
  final List<NoteDto?> notes;
  final NoteMetaData noteMetadata;

  Map<String, dynamic> toJson() => _$FolderWithNotesResponseToJson(this);

  @override
  List<Object?> get props => [folder, notes, noteMetadata];
}
