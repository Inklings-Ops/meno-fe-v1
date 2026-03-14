import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/model/broadcast_query.dart';
import 'package:meno/features/notes/model/_model.dart';
import 'package:meno/features/notes/services/_services.dart';

final class NotesManager with MLogger implements Disposable {
  NotesManager({
    required NotesHttpService http,
    required NotesLocalService local,
  }) : _http = http,
       _local = local {
    // Handle search debounce
    _debouncedSearch = searchQuery
        .where((q) => q != _activeKeywords)
        .debounce(const Duration(milliseconds: 400))
        .listen((query, _) {
          _activeKeywords = query;
          _resubscribe();
        });
  }

  final NotesHttpService _http;
  final NotesLocalService _local;

  /// The live list of notes, filtered by [searchQuery] and [pinnedFilter].
  final notes = ListNotifier<Note>(data: []);

  /// Current search query. Updating this re-subscribes the notes stream.
  final searchQuery = ValueNotifier<String>('');

  /// When non-null, only notes matching this pinned state are shown.
  final pinnedFilter = ValueNotifier<bool?>(null);

  /// The number of notes
  final totalNotesCount = ValueNotifier<int>(0);

  ListenableSubscription? _debouncedSearch;

  StreamSubscription<List<NoteDto>>? _subscription;
  StreamSubscription<List<NoteDto>>? _countSubscription;

  String _activeKeywords = '';

  late final initialize = Command.createAsyncNoParamNoResult(
    _resubscribe,
    errorFilterFn: menoExceptionFilter,
  )..pipeToCommand(syncRemoteNotes);

  late final syncRemoteNotes = Command.createAsyncNoParamNoResult(() async {
    var page = 1;
    while (true) {
      final pagination = PaginationParams(page: page);
      final response = await _http.getNotes(pagination: pagination);
      _local.upsertNotes(response.items.whereType<NoteDto>().toList());
      if (!response.hasMore) break;
      page++;
    }
  }, errorFilterFn: menoExceptionFilter);

  late final performSearch = Command.createSyncNoResult<String>((query) {
    searchQuery.value = query;
  }, errorFilterFn: menoExceptionFilter);

  /// Toggling pinned filter re-subscribes the stream with the new constraint.
  void setPinnedFilter(bool? value) {
    if (pinnedFilter.value == value) return;
    pinnedFilter.value = value;
    _resubscribe();
  }

  Future<void> _resubscribe() async {
    await _cancelStreamSubscriptions();

    _countSubscription = _local.watchNotes().listen(
      (all) => totalNotesCount.value = all.length,
    );

    _subscription = _local
        .watchNotes(
          keywords: searchQuery.value.isEmpty ? null : searchQuery.value,
          pinned: pinnedFilter.value,
        )
        .listen(
          (incoming) {
            notes.startTransAction();
            notes.clear();
            notes.addAll(incoming.map((note) => note.toDomain).toList());
            notes.endTransAction();
          },
          onError: (dynamic error) {
            if (error is MenoException) throw error;
            throw MenoException(error.toString());
          },
        );
  }

  void clearSearch() {
    _activeKeywords = '';
    searchQuery.value = '';
    _resubscribe();
  }

  Future<void> _cancelStreamSubscriptions() async {
    await _subscription?.cancel();
    await _countSubscription?.cancel();

    _subscription = null;
    _countSubscription = null;
  }

  @override
  FutureOr<dynamic> onDispose() async {
    log.d('NotesManager: Disposing...');
    _debouncedSearch?.cancel();
    _debouncedSearch = null;

    await _cancelStreamSubscriptions();

    notes.dispose();
    searchQuery.dispose();
    pinnedFilter.dispose();
    totalNotesCount.dispose();

    initialize.dispose();
    performSearch.dispose();
    syncRemoteNotes.dispose();
  }
}
