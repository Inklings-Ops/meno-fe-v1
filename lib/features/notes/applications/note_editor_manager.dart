import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

/// Autosave fires this long after the last keystroke.
const _kAutoSaveDebounce = Duration(milliseconds: 1500);

class NoteEditorManager with MLogger implements Disposable {
  NoteEditorManager({required INotesRepository repository, required Id? noteId})
    : _repository = repository,
      _noteId = noteId;

  final INotesRepository _repository;
  final Id? _noteId;

  Timer? _debounce;

  /// The canonical note held in memory during the editing session.
  final note = ValueNotifier<Note>(Note.empty);

  /// Title mirror — kept in sync so the title TextField can observe it
  /// without coupling to [note] directly (avoids cursor jumps).
  final title = ValueNotifier<SingleLineString>(SingleLineString.empty);

  final status = ValueNotifier<NoteEditorStatus>(NoteEditorStatus.idle);

  final error = ValueNotifier<MenoException?>(null);

  late final initialize = Command.createAsyncNoParamNoResult(() async {
    if (_noteId == null) {
      final tempId = Id.unique();
      note.value = Note.fromNewId(tempId);
      title.value = SingleLineString.empty;
    } else {
      final result = await _repository.getNote(_noteId);
      result.fold((failure) => throw failure, (success) {
        note.value = success;
        title.value = success.title;
      });
    }
  }, errorFilterFn: menoExceptionFilter);

  void onTitleChanged(String value) {
    final newTitle = SingleLineString(value);
    title.value = newTitle;
    note.value = note.value.copyWith(title: newTitle);
    _markDirtyAndScheduleAutoSave();
  }

  void onContentChanged(String deltaJson) {
    final newContent = MultiLineString(deltaJson);
    note.value = note.value.copyWith(content: newContent);
    _markDirtyAndScheduleAutoSave();
  }

  Future<void> saveNow() async {
    _debounce?.cancel();
    await _persist();
  }

  void _markDirtyAndScheduleAutoSave() {
    status.value = NoteEditorStatus.dirty;
    _debounce?.cancel();
    _debounce = Timer.periodic(_kAutoSaveDebounce, (_) async => _persist());
  }

  Future<void> _persist() async {
    final current = note.value;

    if (status.value.isSaving) return;
    if (!current.title.isValid) return;

    status.value = NoteEditorStatus.saving;
    error.value = null;

    final exists = _noteId != null && current.isValid;
    final result = exists
        ? await _repository.updateNote(current)
        : await _repository.createNote(current);

    result.fold(
      (failure) {
        log.e('NoteEditorManager: persist failed — $failure');
        error.value = failure;
        status.value = NoteEditorStatus.failure;
      },
      (saved) {
        // Update in-memory note with the server-confirmed version
        // (e.g. real ID after first create, updated timestamps).
        note.value = saved;
        status.value = NoteEditorStatus.saved;
        log.d('NoteEditorManager: note saved — ${saved.id}');
      },
    );
  }

  @override
  FutureOr<dynamic> onDispose() {
    log.i('NoteEditorManager: Disposing...');
    note.dispose();
    title.dispose();
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
