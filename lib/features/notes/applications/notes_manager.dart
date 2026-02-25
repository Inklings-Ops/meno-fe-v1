import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/domain/domain.dart';

class NotesManager with MLogger implements Disposable {
  NotesManager(this._repository) {
    pinnedFilter.listen((value, _) => _onPinnedFilterChanged(value));
  }

  final INotesRepository _repository;

  /// The live list of notes, filtered by [searchQuery] and [pinnedFilter].
  late final notes = ListNotifier<Note>(data: []);

  final totalNotesCount = ValueNotifier<int>(0);

  /// Current search query. Updating this re-subscribes the notes stream.
  final searchQuery = ValueNotifier<String>('');

  /// When non-null, only notes matching this pinned state are shown.
  final pinnedFilter = ValueNotifier<bool?>(null);

  /// Set when any command encounters an error the UI should surface locally.
  final error = ValueNotifier<MenoException?>(null);

  StreamSubscription<List<Note>>? _subscription;
  StreamSubscription<List<Note>>? _countSubscription;

  String _activeKeywords = '';

  /// Subscribes to the local notes stream and triggers a remote sync.
  ///
  /// Called once after the user scope is created (post-login). Piped to
  /// [syncFromRemote] so the remote fetch happens right after the local stream
  /// is live — the UI shows cached data immediately and updates silently when
  /// the sync completes.
  late final initialize = Command.createAsyncNoParamNoResult(
    _resubscribe,
    errorFilterFn: menoExceptionFilter,
  )..pipeToCommand(syncFromRemote);

  /// Downloads all pages of notes from the remote and stores them locally.
  ///
  /// Safe to call multiple times — each call is independent. Errors are
  /// surfaced via [menoExceptionFilter] (global toast) and stored in [error]
  /// for in-page error widgets.
  late final syncFromRemote = Command.createAsyncNoParamNoResult(() async {
    error.value = null;
    final result = await _repository.syncFromRemote();
    result.fold((e) {
      error.value = e;
      log.e('NotesManager: syncFromRemote failed — $e');
      throw e;
    }, (_) => log.d('NotesManager: syncFromRemote completed'));
  }, errorFilterFn: menoExceptionFilter);

  /// Retries all locally pending (offline) notes against the remote.
  ///
  /// Typically wired to a connectivity-restored event from outside.
  late final retryPendingSync = Command.createAsyncNoParamNoResult(
    _repository.retryPendingSync,
    errorFilterFn: menoExceptionFilter,
  );

  /// Updates [searchQuery] and re-subscribes the notes stream with the new
  /// keyword filter.
  late final performSearch = Command.createSync<String, void>(
    _performSearch,
    initialValue: null,
  );

  void _performSearch(String query) {
    searchQuery.value = query;
    if (_activeKeywords == query) return;
    _activeKeywords = query;
    _resubscribe();
  }

  /// Toggles or clears the pinned filter.
  ///
  /// Passing the current value again clears the filter (sets to null).
  void _onPinnedFilterChanged(bool? pinned) {
    if (pinnedFilter.value == pinned) {
      pinnedFilter.value = null;
    } else {
      pinnedFilter.value = pinned;
    }
    _resubscribe();
  }

  Future<void> _resubscribe() async {
    await _subscription?.cancel();
    await _countSubscription?.cancel();

    _subscription = null;
    _countSubscription = null;

    _countSubscription = _repository.watchNotes().listen(
      (all) => totalNotesCount.value = all.length,
      onError: (_) {},
    );

    final keywords = searchQuery.value.isEmpty ? null : searchQuery.value;
    final pinned = pinnedFilter.value;

    _subscription = _repository
        .watchNotes(keywords: keywords, pinned: pinned)
        .listen(
          (event) {
            notes.startTransAction();
            notes.clear();
            notes.addAll(event);
            notes.endTransAction();
          },
          onError: (dynamic err) {
            if (err is MenoException) error.value = err;
            error.value = MenoException(err.toString());
            log.e(err.toString());
          },
        );
  }

  @override
  FutureOr<dynamic> onDispose() {
    log.d('NotesManager: Disposing...');

    _subscription?.cancel();
    _subscription = null;

    _countSubscription?.cancel();
    _countSubscription = null;

    notes.dispose();
    searchQuery.dispose();
    pinnedFilter.dispose();
    error.dispose();
    totalNotesCount.dispose();

    initialize.dispose();
    syncFromRemote.dispose();
    retryPendingSync.dispose();
    performSearch.dispose();
  }
}
