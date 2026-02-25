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
  final searchQuery = ValueNotifier<String>('');
  final totalNotesCount = ValueNotifier<int>(0);
  final error = ValueNotifier<MenoException?>(null);

  String _activeKeywords = '';

  StreamSubscription<NoteFolder>? _subscription;
  StreamSubscription<NoteFolder>? _notesCountSubscription;

  late final initialize = Command.createAsyncNoParamNoResult(
    _resubscribe,
    errorFilterFn: menoExceptionFilter,
  );

  late final performSearch = Command.createSync<String, void>(
    _onSearchChanged,
    initialValue: null,
  );

  Future<void> _resubscribe() async {
    await _subscription?.cancel();
    await _notesCountSubscription?.cancel();

    _subscription = null;
    _notesCountSubscription = null;

    final keywords = searchQuery.value.isEmpty ? null : searchQuery.value;
    _subscription = _repository
        .watchFolder(_folderId, keywords: keywords)
        .listen(
          (event) => folder.value = event,
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

  void _onSearchChanged(String query) {
    searchQuery.value = query;
    if (_activeKeywords == query) return;
    _activeKeywords = query;
    _resubscribe();
  }

  @override
  FutureOr<dynamic> onDispose() {
    log.d('FolderManager: Disposing...');

    folder.dispose();
    notes.dispose();
    totalNotesCount.dispose();
    error.dispose();
    searchQuery.dispose();

    initialize.dispose();
    performSearch.dispose();

    _subscription?.cancel();
    _subscription = null;

    _notesCountSubscription?.cancel();
    _notesCountSubscription = null;
  }
}
