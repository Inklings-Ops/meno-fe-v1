import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/objectbox.g.dart';

import '../../../../services/objectbox_service.dart';
import '../dtos/dtos.dart';

@injectable
class NoteLocalDatasource {
  final ObjectBoxService _objectbox;

  NoteLocalDatasource({required ObjectBoxService objectbox})
      : _objectbox = objectbox;

  Future<List<NoteDto?>> getAllNotes() async {
    final noteBox = _objectbox.store.box<NoteDto?>();
    return noteBox.getAll();
  }

  Future<List<FolderDto?>> getAllFolders() async {
    final folderBox = _objectbox.store.box<FolderDto?>();
    return folderBox.getAll();
  }

  Future<NoteDto?> getNote(String id) async {
    final noteBox = _objectbox.store.box<NoteDto?>();

    final builder = noteBox.query(NoteDto_.id.equals(id));

    Query<NoteDto?> query = builder.build();
    final note = query.findFirst();

    return note;
  }

  Future<FolderDto?> getFolder(String id) async {
    final folderBox = _objectbox.store.box<FolderDto?>();

    final builder = folderBox.query(FolderDto_.id.equals(id));

    Query<FolderDto?> query = builder.build();
    final folder = query.findFirst();

    return folder;
  }

  Future<void> storeNote(NoteDto note) async {
    final noteBox = _objectbox.store.box<NoteDto?>();
    noteBox.put(note);
  }

  Future<void> storeAllNotes(List<NoteDto> notes) async {
    final noteBox = _objectbox.store.box<NoteDto?>();

    try {
      const batchSize = 10000;
      final totalNotes = notes.length;

      for (var i = 0; i < totalNotes; i += batchSize) {
        final end = (i + batchSize < totalNotes) ? i + batchSize : totalNotes;
        final batch = notes.sublist(i, end);
        noteBox.putMany(batch);
      }
    } on ObjectBoxException catch (e) {
      throw ObjectBoxException(e.message);
    }
  }

  Future<int> deleteFolder(String folderId) {
    final folderBox = _objectbox.store.box<FolderDto?>();
    final builder = folderBox.query(FolderDto_.id.equals(folderId));
    return builder.build().removeAsync();
  }

  Future<int> deleteNote(String noteId) {
    final noteBox = _objectbox.store.box<NoteDto?>();
    final builder = noteBox.query(NoteDto_.id.equals(noteId));
    return builder.build().removeAsync();
  }
}
