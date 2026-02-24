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

  /// Whether the folder page is in bulk-selection mode.
  final isSelecting = ValueNotifier<bool>(false);

  /// Notes the user has selected during a bulk-move session.
  final selectedNoteIds = SetNotifier<Id>(data: {});

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

  late final assignNotesToFolder = Command.createAsync<List<Id>, AssignResult>(
    (List<Id> noteIds) async {
      if (noteIds.isEmpty) throw const MenoException('No notes selected');
      return _repository.assignNotesToFolder(
        noteIds: noteIds,
        folderId: _folderId,
      );
    },
    initialValue: AssignResult.empty,
    errorFilterFn: menoExceptionFilter,
  );

  late final unassignNotesToFolder = Command.createAsync(
    (List<Id> noteIds) async {
      if (noteIds.isEmpty) return null;
      return _repository.unassignNotesFromFolder(
        noteIds: noteIds,
        folderId: _folderId,
      );
    },
    initialValue: null,
    errorFilterFn: menoExceptionFilter,
  );

  /// This command is placed here as trade-off
  /// Since I (gettoknowdavid) do not want create another manager just to
  /// handle moving of notes to a folder; I also do no want to put business
  /// logic in the UI layer, so I decided to place this here.
  ///
  /// It is similar to the [assignNotesToFolder] command with the major
  /// difference of needing the `targetFolderId`
  late final moveNotes = Command.createAsyncNoResult<(List<Id>, Id)>((
    (List<Id>, Id) params,
  ) async {
    final noteIds = params.$1;
    final targetFolderId = params.$2;
    if (noteIds.isEmpty) throw const MenoException('No notes selected');
    error.value = null;
    final result = await _repository.assignNotesToFolder(
      noteIds: noteIds,
      folderId: targetFolderId,
    );
    if (result.hasFailures) {
      final failedIdsCount = result.failedIds.length;
      error.value = MenoException(
        '$failedIdsCount note${failedIdsCount == 1 ? '' : 's'} '
        'could not be synced and will retry automatically.',
      );
    }
  }, errorFilterFn: menoExceptionFilter);

  void enterSelectionMode() => isSelecting.value = true;

  void exitSelectionMode() {
    selectedNoteIds.clear();
    isSelecting.value = false;
  }

  void toggleNoteSelection(Id noteId) {
    selectedNoteIds.contains(noteId)
        ? selectedNoteIds.remove(noteId)
        : selectedNoteIds.add(noteId);
  }

  void selectAll() {
    selectedNoteIds.startTransAction();
    selectedNoteIds.clear();
    for (final note in folder.value.notes) {
      if (note != null) selectedNoteIds.add(note.id);
    }
    selectedNoteIds.endTransAction();
  }

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

  void _onSearchChanged(String query) {
    if (searchQuery.value == query) return;
    searchQuery.value = query;
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
    isSelecting.dispose();
    selectedNoteIds.dispose();

    initialize.dispose();
    assignNotesToFolder.dispose();
    unassignNotesToFolder.dispose();
    performSearch.dispose();

    _subscription?.cancel();
    _subscription = null;

    _notesCountSubscription?.cancel();
    _notesCountSubscription = null;
  }
}
