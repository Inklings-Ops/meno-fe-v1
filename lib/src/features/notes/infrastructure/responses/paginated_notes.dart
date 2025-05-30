import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginated_notes.g.dart';

@JsonSerializable(genericArgumentFactories: true)
final class PaginatedNotes<NoteDto> with EquatableMixin {
  const PaginatedNotes({
    required this.notes,
    required this.totalPages,
    required this.totalItems,
    required this.currentPage,
  });

  factory PaginatedNotes.fromJson(
    Map<String, dynamic> json,
    NoteDto Function(Object?) fromJsonT,
  ) =>
      _$PaginatedNotesFromJson(json, fromJsonT);

  final List<NoteDto?> notes;
  final int totalPages;
  final int totalItems;
  final int currentPage;

  @override
  List<Object?> get props => [notes, totalItems, totalPages, currentPage];

  Map<String, dynamic> toJson(Object? Function(NoteDto value) toJsonT) =>
      _$PaginatedNotesToJson(this, toJsonT);

  @override
  bool? get stringify => true;
}
