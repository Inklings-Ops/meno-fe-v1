import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

/// Autosave fires this long after the last keystroke.
const _kAutoSaveDebounce = Duration(milliseconds: 1500);

class NoteEditorManager with MLogger implements Disposable {
  NoteEditorManager({
    required INotesRepository repository,
    required String? noteId,
  }) : _repository = repository,
       _noteId = noteId;

  final INotesRepository _repository;
  final String? _noteId;

  // Flips to true after the first successful createNote call so that
  // all subsequent persists use updateNote.
  bool _hasBeenCreated = false;

  Timer? _debounce;

  // =========================================================================
  // PUBLIC STATE
  // =========================================================================
  final note = ValueNotifier<Note>(.empty);
  final status = ValueNotifier<NoteEditorStatus>(.idle);
  final error = ValueNotifier<MenoException?>(null);

  // =========================================================================
  // INITIALISATION
  // =========================================================================

  /// Must be called once after the manager is registered in the scope.
  /// For existing notes, reads from the local ObjectBox cache (instant).
  /// For new notes, primes an empty note with a fresh ID.
  late final initialize = Command.createAsyncNoParamNoResult(() async {
    if (_noteId == null) {
      note.value = Note.fromNewId(Id.unique());
    } else {
      final id = Id.fromString(_noteId);
      final result = await _repository.getNote(id);
      result.fold((error) => throw error, (success) => note.value = success);
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
    if (status.value.isSaving) return;

    final currentNote = note.value;
    if (!currentNote.isValid) return;

    status.value = .saving;
    error.value = null;

    final result = _hasBeenCreated
        ? await _repository.updateNote(currentNote)
        : await _repository.createNote(currentNote);

    result.fold(
      (failure) {
        log.e('NoteEditorManager: persist failed — $failure');
        error.value = failure;
        status.value = .failure;
      },
      (success) {
        _hasBeenCreated = true;
        note.value = success;
        status.value = .saved;
        log.d('NoteEditorManager: note saved: ${success.id.getOrCrash()}');
      },
    );
  }

  // =========================================================================
  // DISPOSE
  // =========================================================================
  @override
  FutureOr<dynamic> onDispose() {
    log.i('NoteEditorManager: Disposing...');
    note.dispose();
    status.dispose();
    error.dispose();

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
