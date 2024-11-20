import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:objectbox/objectbox.dart';

class FolderToOneConverter
    implements JsonConverter<ToOne<FolderDto?>, Map<String, dynamic>?> {
  const FolderToOneConverter();

  @override
  ToOne<FolderDto?> fromJson(Map<String, dynamic>? json) {
    return ToOne<FolderDto>(
      target: json == null ? null : FolderDto.fromJson(json),
    );
  }

  @override
  Map<String, dynamic>? toJson(ToOne<FolderDto?> rel) => rel.target?.toJson();
}

class NoteCreatorToOneConverter
    implements JsonConverter<ToOne<NoteCreatorDto?>, Map<String, dynamic>?> {
  const NoteCreatorToOneConverter();

  @override
  ToOne<NoteCreatorDto?> fromJson(Map<String, dynamic>? json) {
    return ToOne<NoteCreatorDto>(
      target: json == null ? null : NoteCreatorDto.fromJson(json),
    );
  }

  @override
  Map<String, dynamic>? toJson(ToOne<NoteCreatorDto?> rel) =>
      rel.target?.toJson();
}

class FolderNotesToManyConverter
    implements JsonConverter<ToMany<NoteDto?>, List<Map<String, dynamic>>?> {
  const FolderNotesToManyConverter();

  @override
  ToMany<NoteDto?> fromJson(List<Map<String, dynamic>>? json) =>
      ToMany<NoteDto?>(items: json?.map(NoteDto.fromJson).toList());

  @override
  List<Map<String, dynamic>>? toJson(ToMany<NoteDto?> rel) => rel
      .map((NoteDto? obj) => obj?.toJson())
      .whereType<Map<String, dynamic>>()
      .toList();
}
