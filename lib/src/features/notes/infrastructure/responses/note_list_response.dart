import 'package:freezed_annotation/freezed_annotation.dart';

import '../dtos/dtos.dart';

part 'note_list_response.freezed.dart';
part 'note_list_response.g.dart';

@freezed
@JsonSerializable(explicitToJson: true, createFactory: false)
class NoteListResponse with _$NoteListResponse {
  factory NoteListResponse({
    required List<NoteDto?> notes,
    required int totalPages,
    required int currentPage,
    required int totalItems,
  }) = _NoteListResponse;

  factory NoteListResponse.fromJson(Map<String, dynamic> json) =>
      _$NoteListResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NoteListResponseToJson(this);
}
