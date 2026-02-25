import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

class FoldersManager with MLogger implements Disposable {
  FoldersManager(this._repository);

  final INotesRepository _repository;

  final folders = ListNotifier<NoteFolder>(data: []);

  final totalFoldersCount = ValueNotifier<int>(0);

  final searchQuery = ValueNotifier<String>('');

  final error = ValueNotifier<MenoException?>(null);

  StreamSubscription<List<NoteFolder>>? _subscription;
  StreamSubscription<List<NoteFolder>>? _countSubscription;

  String _activeKeywords = '';

  late final initialize = Command.createAsyncNoParamNoResult(
    _resubscribe,
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

  late final deleteFolder = Command.createAsync<Id, bool?>(
    (folderId) async {
      final result = await _repository.deleteFolder(folderId);
      return result.fold((failure) => throw failure, (_) => true);
    },
    initialValue: null,
    errorFilterFn: (e, _) => ErrorReaction.globalHandler,
  );

  Future<void> _resubscribe() async {
    await _subscription?.cancel();
    await _countSubscription?.cancel();

    _subscription = null;
    _countSubscription = null;

    _countSubscription = _repository.watchFolders().listen(
      (all) => totalFoldersCount.value = all.length,
      onError: (_) {},
    );

    final keywords = searchQuery.value.isNotEmpty ? searchQuery.value : null;

    _subscription = _repository
        .watchFolders(keywords: keywords)
        .listen(
          (event) {
            folders.startTransAction();
            folders.clear();
            folders.addAll(event);
            folders.endTransAction();
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
    log.d('FoldersManager: Disposing...');

    folders.dispose();
    searchQuery.dispose();
    error.dispose();
    totalFoldersCount.dispose();

    _subscription?.cancel();
    _subscription = null;

    _countSubscription?.cancel();
    _countSubscription = null;

    initialize.dispose();
    performSearch.dispose();
    deleteFolder.dispose();
  }
}
