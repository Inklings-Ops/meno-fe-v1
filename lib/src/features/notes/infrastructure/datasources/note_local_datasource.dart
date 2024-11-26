import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/objectbox.g.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/services/services.dart';

@injectable
class NoteLocalDatasource {
  NoteLocalDatasource({
    required ObjectBoxService objectBox,
  }) : _objectBox = objectBox;

  final ObjectBoxService _objectBox;

  Box<NoteDto> get _noteBox => _objectBox.noteBox;

  Box<FolderDto> get _folderBox => _objectBox.folderBox;

  Stream<List<NoteDto?>> allNotesStream() {
    final notes = _noteBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
    return notes;
  }

  List<NoteDto?> getAllNotes() {
    final notes = _noteBox.getAll();
    return notes;
  }

  List<FolderDto?> getAllFolders() {
    final folders = _folderBox.getAll();
    return folders;
  }

  List<NoteDto?> getNotesFromFolder(String folderId) {
    final query = _folderBox.query(FolderDto_.id.equals(folderId)).build();
    final folder = query.findFirst();
    final notes = folder?.notes;
    return notes ?? [];
  }

  NoteDto? getNote(String noteId) {
    final query = _noteBox.query(NoteDto_.uid.equals(noteId)).build();
    final note = query.findFirst();
    query.close();
    return note;
  }

  FolderDto? getFolder(String folderId) {
    final query = _folderBox.query(FolderDto_.id.equals(folderId)).build();
    final folder = query.findFirst();
    query.close();
    return folder;
  }

  void storeNote(NoteDto note) {
    _noteBox.put(note);
  }

  void storeFolder(FolderDto folder) {
    _objectBox.folderBox.put(folder);
  }

  void deleteNote(String noteId) {
    final query = _noteBox.query(NoteDto_.uid.equals(noteId)).build();
    final note = query.findFirst();
    query.close();
    if (note != null && note.id != null) {
      _noteBox.remove(note.id!);
    }
  }

  void deleteFolder(String folderId) {
    final query = _folderBox.query(FolderDto_.id.equals(folderId)).build();
    final folder = query.findFirst();
    query.close();
    if (folder != null && folder.dbId != null) {
      _folderBox.remove(folder.dbId!);
    }
  }

  void addNoteToFolder(String folderId, NoteDto note) {
    final query = _folderBox.query(FolderDto_.id.equals(folderId)).build();
    final folder = query.findFirst();
    if (folder != null) {
      folder.notes.add(note);
      _folderBox.put(folder);
    }
  }

  void removeNoteFromFolder(String folderId, String noteId) {
    final folder = getFolder(folderId);
    if (folder != null) {
      folder.notes.removeWhere((note) => note.uid == noteId);
      _folderBox.put(folder);
    }
  }
}
