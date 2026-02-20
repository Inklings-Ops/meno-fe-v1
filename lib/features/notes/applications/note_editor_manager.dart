import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

class NoteEditorManager with MLogger implements Disposable {
  NoteEditorManager({required INotesRepository repository, required Id? noteId})
    : _repository = repository,
      _noteId = noteId;

  final INotesRepository _repository;
  final Id? _noteId;

  late final note = ValueNotifier<Note>(Note.empty);

  late final initialize = Command.createAsyncNoParamNoResult(() async {
    if (_noteId == null) {
      final tempId = Id.unique();
      note.value = Note.fromNewId(tempId);
      return;
    } else {
      final result = await _repository.getNote(_noteId);
      result.fold(
        (failure) => throw failure,
        (success) => note.value = success,
      );
    }
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() {
    log.i('NoteEditorManager: Disposing...');
    note.dispose();
    initialize.dispose();
  }
}
