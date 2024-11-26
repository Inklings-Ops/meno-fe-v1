import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:objectbox/objectbox.dart';

class FolderNotesToManyConverter
    implements JsonConverter<ToMany<NoteDto?>, List<Map<String, dynamic>>?> {
  const FolderNotesToManyConverter();

  @override
  ToMany<NoteDto?> fromJson(List<Map<String, dynamic>>? json) =>
      ToMany<NoteDto?>(
        items: json == null ? [] : json.map(NoteDto.fromJson).toList(),
      );

  @override
  List<Map<String, dynamic>>? toJson(ToMany<NoteDto?> rel) =>
      rel.map((NoteDto? obj) => obj?.toJson() ?? {}).toList();
}
