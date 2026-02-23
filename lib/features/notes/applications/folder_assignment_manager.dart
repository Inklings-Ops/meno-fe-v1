import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

/// Callback signature for the actual remote write.
///
/// Receives the selected [noteIds] and must return a [AssignResult].
/// The caller (whoever opens the modal) is responsible for constructing the
/// correct repository calls — this manager stays write-agnostic.
typedef AssignmentCallback = FutureOr<AssignResult> Function(List<Id> noteIds);

class FolderAssignmentManager with MLogger implements Disposable {
  FolderAssignmentManager({
    required INotesRepository repository,
    required AssignmentCallback onConfirm,
    Set<Id?> excludedNoteIds = const <Id?>{},
  }) : _repository = repository,
       _onConfirm = onConfirm,
       _excludedNoteIds = excludedNoteIds;

  final INotesRepository _repository;
  final AssignmentCallback _onConfirm;
  final Set<Id?> _excludedNoteIds;

  /// All notes available for selection, filtered by [searchQuery] and with
  /// [_excludedNoteIds] stripped out.
  final notes = ListNotifier<Note>(data: []);

  /// Notes the user has tapped to select in the current modal session.
  final selectedNoteIds = SetNotifier<Id>(data: {});

  /// Current search query for the notes picker.
  final searchQuery = ValueNotifier<String>('');

  /// Surfaces local errors (e.g. partial remote failures) for the modal UI.
  final error = ValueNotifier<MenoException?>(null);

  StreamSubscription<List<Note>>? _subscription;

  // =========================================================================
  // COMMANDS
  // =========================================================================

  late final initialize = Command.createAsyncNoParamNoResult(
    _resubscribe,
    errorFilterFn: menoExceptionFilter,
  );

  late final performSearch = Command.createSync<String, void>(
    _onSearchChanged,
    initialValue: null,
  );

  /// Executes the assignment.
  ///
  /// Optimistic local writes are the caller's responsibility (done inside
  /// [_onConfirm] via the repository). This command is intentionally typed
  /// as [AssignResult?] so the modal can register a handler and
  /// react to partial failures without making this manager UI-aware.
  late final confirm = Command.createAsync<void, AssignResult?>(
    (_) async {
      final selected = selectedNoteIds.toList();
      if (selected.isEmpty) return null;

      error.value = null;

      final result = await _onConfirm(selected);

      if (result.hasFailures) {
        final failedIdsCount = result.failedIds.length;
        error.value = MenoException(
          '$failedIdsCount note${failedIdsCount == 1 ? '' : 's'} '
          'could not be synced and will retry automatically.',
        );
      }

      return result;
    },
    initialValue: null,
    errorFilterFn: (e, _) => ErrorReaction.globalHandler,
  );

  // =========================================================================
  // SELECTION HELPERS
  // =========================================================================

  void toggleSelection(Id noteId) {
    selectedNoteIds.contains(noteId)
        ? selectedNoteIds.remove(noteId)
        : selectedNoteIds.add(noteId);
  }

  void selectAll() {
    selectedNoteIds.startTransAction();
    selectedNoteIds.clear();
    final noteIds = notes.value.map((n) => n.id).toSet();
    for (final noteId in noteIds) {
      selectedNoteIds.add(noteId);
    }
    selectedNoteIds.endTransAction();
  }

  void clearSelection() => selectedNoteIds.clear();

  bool isSelected(Id noteId) => selectedNoteIds.contains(noteId);

  // =========================================================================
  // PRIVATE
  // =========================================================================

  void _onSearchChanged(String query) {
    if (searchQuery.value == query) return;
    searchQuery.value = query;
    _resubscribe();
  }

  Future<void> _resubscribe() async {
    await _subscription?.cancel();
    _subscription = null;

    final keywords = searchQuery.value.isEmpty ? null : searchQuery.value;

    _subscription = _repository
        .watchNotes(keywords: keywords)
        .listen(
          (list) {
            notes.startTransAction();
            notes.clear();

            final filtered = _excludedNoteIds.isNotEmpty
                ? list.where((n) => !_excludedNoteIds.contains(n.id)).toList()
                : list;

            notes.addAll(filtered);
            notes.endTransAction();
          },
          onError: (dynamic err) {
            error.value = err is MenoException
                ? err
                : MenoException(err.toString());
            log.e('NoteFolderAssignmentManager: stream error — $err');
          },
        );
  }

  @override
  FutureOr<dynamic> onDispose() {
    log.d('NoteFolderAssignmentManager: Disposing...');

    _subscription?.cancel();
    _subscription = null;

    notes.dispose();
    selectedNoteIds.dispose();
    searchQuery.dispose();
    error.dispose();

    initialize.dispose();
    performSearch.dispose();
    confirm.dispose();
  }
}
