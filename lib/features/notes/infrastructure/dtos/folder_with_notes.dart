import 'package:meno/features/notes/infrastructure/infrastructure.dart';

final class FolderWithNotes {
  const FolderWithNotes({
    required this.folder,
    required this.notes,
    required this.meta,
  });

  factory FolderWithNotes.fromJson(Map<String, dynamic> json) {
    final rawFolder = json['folder'];
    if (rawFolder is! Map<String, dynamic>) {
      throw const FormatException(
        'Expected "folder" object in folder-with-notes response',
      );
    }

    final rawNotes = json['notes'];
    if (rawNotes is! List) {
      throw const FormatException(
        'Expected "notes" array in folder-with-notes response',
      );
    }

    final rawMeta = json['noteMetadata'];
    if (rawMeta is! Map<String, dynamic>) {
      throw const FormatException(
        'Expected "noteMetadata" object in folder-with-notes response',
      );
    }

    return FolderWithNotes(
      folder: NoteFolderDto.fromJson(rawFolder),
      notes: rawNotes.map(NoteDto.fromJson).toList(),
      meta: NotesMetadata.fromJson(rawMeta),
    );
  }

  final NoteFolderDto folder;
  final List<NoteDto> notes;
  final NotesMetadata meta;
}
