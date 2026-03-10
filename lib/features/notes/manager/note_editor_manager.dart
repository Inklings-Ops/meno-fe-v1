import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/notes/model/_model.dart';
import 'package:meno/features/notes/services/_services.dart';

/// Autosave fires this long after the last keystroke.
const _kAutoSaveDebounce = Duration(milliseconds: 1500);

class NoteEditorManager with MLogger implements Disposable {
  NoteEditorManager({
    required NotesHttpService http,
    required NotesLocalService local,
    required Id? noteId,
  }) : _http = http,
       _local = local,
       _noteId = noteId;

  final NotesHttpService _http;
  final NotesLocalService _local;
  final Id? _noteId;

  // Flips to true after the first successful createNote call so that
  // all subsequent persists use updateNote.
  bool _hasBeenCreated = false;

  Timer? _debounce;

  // =========================================================================
  // PUBLIC STATE
  // =========================================================================
  final note = ValueNotifier<Note>(.empty);
  final status = ValueNotifier<NoteEditorStatus>(.idle);

  // =========================================================================
  // INITIALISATION
  // =========================================================================

  /// Must be called once after the manager is registered in the scope.
  /// For existing notes, reads from the local ObjectBox cache (instant).
  /// For new notes, primes an empty note with a fresh ID.
  late final initialize = Command.createSyncNoParamNoResult(() {
    if (_noteId == null) {
      note.value = Note.fromNewId(Id.unique());
    } else {
      final result = _local.findNoteByRemoteId(_noteId.getOrCrash());
      if (result == null) throw const MenoException('Note not found');
      note.value = result.toDomain;
      _hasBeenCreated = true;
    }
  }, errorFilterFn: menoExceptionFilter);

  // =========================================================================
  // EDITOR CHANGE HANDLERS
  // =========================================================================
  void onTitleChanged(String value) {
    final newTitle = SingleLineString(value);
    note.value = note.value.copyWith(title: newTitle);
    _markDirtyAndScheduleAutoSave();
  }

  void onContentChanged(String deltaJson) {
    final newContent = MultiLineString(deltaJson);
    note.value = note.value.copyWith(content: newContent);
    _markDirtyAndScheduleAutoSave();
  }

  // =========================================================================
  // SAVE
  // =========================================================================
  Future<void> saveNow() async {
    _debounce?.cancel();
    await _persist();
  }

  void _markDirtyAndScheduleAutoSave() {
    status.value = .dirty;
    _debounce?.cancel();
    _debounce = Timer(_kAutoSaveDebounce, _persist);
  }

  Future<void> _persist() async {
    // Avoid stacking multiple saves at the same time
    if (status.value.isSaving) return;

    final current = note.value;
    if (!current.isValid) return;

    status.value = .saving;

    try {
      if (_hasBeenCreated) {
        await _update(current);
      } else {
        await _create(current);
      }
    } catch (e) {
      // Remote failures do not block the editor — the note is already
      // committed locally as syncPending and will be retried by
      // retryPendingSync on next startup / foreground resume.
      log.w('NoteEditorManager._persist: remote call failed — $e');

      // Surface to the global error handler (toast) without rethrowing.
      status.value = NoteEditorStatus.failure;
      return;
    }
  }

  Future<void> _create(Note current) async {
    final dto = current.toDto(pending: true);

    _local.upsertNote(dto);
    final confirmed = await _http.createNote(dto);

    _local.deleteNoteByRemoteId(current.id.getOrCrash());
    _local.upsertNote(confirmed);

    _hasBeenCreated = true;
    note.value = confirmed.toDomain;
    status.value = NoteEditorStatus.saved;
  }

  Future<void> _update(Note current) async {
    final dto = current.toDto(pending: true);

    _local.upsertNote(dto);
    final confirmed = await _http.updateNote(dto.id, dto);

    _local.upsertNote(confirmed);

    note.value = confirmed.toDomain;
    status.value = NoteEditorStatus.saved;
  }

  // =========================================================================
  // DISPOSE
  // =========================================================================
  @override
  FutureOr<dynamic> onDispose() {
    log.i('NoteEditorManager: Disposing...');
    note.dispose();
    status.dispose();

    initialize.dispose();
    _debounce?.cancel();
    _debounce = null;
  }
}

/// The save state of the note editor.
/// [idle]    is the initial state.
///
/// [dirty]   is when the note is modified.
///
/// [saving]  is when the note is being saved.
///
/// [saved]   is when the note is saved successfully.
///
/// [failure] is when the note fails to save.
enum NoteEditorStatus { idle, dirty, saving, saved, failure }

extension NoteEditorStatusX on NoteEditorStatus {
  bool get isIdle => this == NoteEditorStatus.idle;

  bool get isDirty => this == NoteEditorStatus.dirty;

  bool get isSaving => this == NoteEditorStatus.saving;

  bool get isSaved => this == NoteEditorStatus.saved;

  bool get isFailure => this == NoteEditorStatus.failure;
}
