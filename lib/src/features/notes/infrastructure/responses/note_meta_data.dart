import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_meta_data.freezed.dart';
part 'note_meta_data.g.dart';

@freezed
@JsonSerializable(explicitToJson: true, createFactory: false)
class NoteMetaData with _$NoteMetaData {
  factory NoteMetaData({
    required int totalPages,
    required int currentPage,
    required int totalItems,
  }) = _NoteMetaData;

  factory NoteMetaData.fromJson(Map<String, dynamic> json) =>
      _$NoteMetaDataFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$NoteMetaDataToJson(this);
}
