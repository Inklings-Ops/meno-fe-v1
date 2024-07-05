import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dtos/dtos.dart';

@injectable
class NoteLocalDatasource {
  final SharedPreferences _pref;

  NoteLocalDatasource({required SharedPreferences pref}) : _pref = pref;

  static const String notesKey = 'Note_Key';

  Future<void> saveNoteList(List<NoteDto?> notes) async {
    final noteList = notes.map((n) => jsonEncode(n?.toJson())).toList();
    await _pref.setStringList(notesKey, noteList);
  }

  Future<List<NoteDto?>> getAllNotes() async {
    final noteList = _pref.getStringList(notesKey);
    if (noteList != null) {
      return noteList.map((n) => NoteDto.fromJson(jsonDecode(n))).toList();
    } else {
      return [];
    }
  }

  void getAllFolders() async {
    // final folderBox = _objectbox.store.box<FolderDto?>();
    // return folderBox.getAll();
  }

  Future<NoteDto?> getNote(String id) async {
    return null;

    // final noteBox = _objectbox.store.box<NoteDto?>();

    // final builder = noteBox.query(NoteDto_.uid.equals(id));

    // Query<NoteDto?> query = builder.build();
    // final note = query.findFirst();

    // return note;
  }

  Future<FolderDto?> getFolder(String id) async {
    return null;

    // final folderBox = _objectbox.store.box<FolderDto?>();

    // final builder = folderBox.query(FolderDto_.id.equals(id));

    // Query<FolderDto?> query = builder.build();
    // final folder = query.findFirst();

    // return folder;
  }

  Future<NoteDto> storeNote(NoteDto note) async {
    final notes = await getAllNotes();
    notes.add(note);
    await saveNoteList(notes);
    return note;
  }

  Future<void> storeAllNotes(List<NoteDto> notes) async {
    // final noteBox = _objectbox.store.box<NoteDto?>();

    // try {
    //   const batchSize = 10000;
    //   final totalNotes = notes.length;

    //   for (var i = 0; i < totalNotes; i += batchSize) {
    //     final end = (i + batchSize < totalNotes) ? i + batchSize : totalNotes;
    //     final batch = notes.sublist(i, end);
    //     noteBox.putMany(batch);
    //   }
    // } on ObjectBoxException catch (e) {
    //   throw ObjectBoxException(e.message);
    // }
  }

  void deleteFolder(String folderId) {
    // final folderBox = _objectbox.store.box<FolderDto?>();
    // final builder = folderBox.query(FolderDto_.id.equals(folderId));
    // return builder.build().removeAsync();
  }

  void deleteNote(String noteId) {
    // final noteBox = _objectbox.store.box<NoteDto?>();
    // final builder = noteBox.query(NoteDto_.uid.equals(noteId));
    // return builder.build().removeAsync();
    return;
  }
}
