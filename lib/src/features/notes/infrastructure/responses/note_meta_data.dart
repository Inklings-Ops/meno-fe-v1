import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note_meta_data.g.dart';

@JsonSerializable()
class NoteMetaData with EquatableMixin {
  const NoteMetaData({
    required this.totalPages,
    required this.currentPage,
    required this.totalItems,
  });

  factory NoteMetaData.fromJson(Map<String, dynamic> json) =>
      _$NoteMetaDataFromJson(json);

  final int totalPages;
  final int currentPage;
  final int totalItems;

  Map<String, dynamic> toJson() => _$NoteMetaDataToJson(this);

  @override
  List<Object?> get props => [totalPages, currentPage, totalItems];
}
