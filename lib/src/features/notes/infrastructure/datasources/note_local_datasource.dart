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
    final store = _objectbox.store;
    final noteBox = store.box<NoteDto?>();
    return noteBox.getAll();
  }

  Future<NoteDto?> getNote(String id) async {
    final store = _objectbox.store;
    final noteBox = store.box<NoteDto?>();

    final builder = noteBox.query(NoteDto_.id.equals(id));

    Query<NoteDto?> query = builder.build();
    final note = query.findFirst();

    return note;
  }

  Future<void> storeNote(NoteDto note) async {
    final store = _objectbox.store;
    final noteBox = store.box<NoteDto?>();
    noteBox.put(note);
  }

  Future<void> storeAllNotes(List<NoteDto> notes) async {
    final store = _objectbox.store;
    final noteBox = store.box<NoteDto?>();

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
}
