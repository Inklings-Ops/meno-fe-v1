import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/domain/domain.dart';

class FoldersManager with MLogger implements Disposable {
  FoldersManager(this._repository);

  final INotesRepository _repository;

  final folders = ListNotifier<NoteFolder>(data: []);

  final searchQuery = ValueNotifier<String>('');

  final error = ValueNotifier<MenoException?>(null);

  StreamSubscription<List<NoteFolder>>? _subscription;

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
    if (searchQuery.value == query) return;
    searchQuery.value = query;
    _resubscribe();
  }

  Future<void> _resubscribe() async {
    await _subscription?.cancel();
    _subscription = null;

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

    _subscription?.cancel();
    _subscription = null;

    initialize.dispose();
  }
}
