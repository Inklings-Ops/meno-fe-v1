import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

class FolderManager with MLogger implements Disposable {
  FolderManager({required INotesRepository repository, required Id folderId})
    : _repository = repository,
      _folderId = folderId;

  final INotesRepository _repository;
  final Id _folderId;

  final folder = ValueNotifier<NoteFolder>(.empty);
  final notes = ListNotifier<Note>(data: []);
  final totalNotesCount = ValueNotifier<int>(0);
  final error = ValueNotifier<MenoException?>(null);

  StreamSubscription<NoteFolder>? _subscription;
  StreamSubscription<NoteFolder>? _notesCountSubscription;

  late final initialize = Command.createAsyncNoParamNoResult(
    _resubscribe,
    errorFilterFn: menoExceptionFilter,
  );

  Future<void> _resubscribe() async {
    await _subscription?.cancel();
    await _notesCountSubscription?.cancel();

    _subscription = null;
    _notesCountSubscription = null;

    _subscription = _repository
        .watchFolder(_folderId)
        .listen(
          (event) {
            folder.value = event;
          },
          onError: (dynamic err) {
            if (err is MenoException) error.value = err;
            error.value = MenoException(err.toString());
            log.e(err.toString());
          },
        );

    _notesCountSubscription = _repository
        .watchFolder(_folderId)
        .listen((event) => totalNotesCount.value = event.notes.length);
  }

  @override
  FutureOr<dynamic> onDispose() {
    log.d('FolderManager: Disposing...');

    folder.dispose();
    notes.dispose();
    totalNotesCount.dispose();
    error.dispose();

    initialize.dispose();

    _subscription?.cancel();
    _subscription = null;

    _notesCountSubscription?.cancel();
    _notesCountSubscription = null;
  }
}
