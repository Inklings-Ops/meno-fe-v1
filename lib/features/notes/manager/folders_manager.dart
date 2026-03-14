import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/notes/model/_model.dart';
import 'package:meno/features/notes/services/_services.dart';

final class FoldersManager with MLogger implements Disposable {
  FoldersManager({
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

  final folders = ListNotifier<NoteFolder>(data: []);

  final totalFoldersCount = ValueNotifier<int>(0);

  final searchQuery = ValueNotifier<String>('');

  ListenableSubscription? _debouncedSearch;

  StreamSubscription<List<NoteFolderDto>>? _subscription;
  StreamSubscription<List<NoteFolderDto>>? _countSubscription;

  String _activeKeywords = '';

  late final initialize = Command.createAsyncNoParamNoResult(
    _resubscribe,
    errorFilterFn: menoExceptionFilter,
  )..pipeToCommand(syncRemoteFolders);

  late final syncRemoteFolders = Command.createAsyncNoParamNoResult(() async {
    var page = 1;
    while (true) {
      final pagination = PaginationParams(page: page);
      final response = await _http.getFolders(pagination: pagination);
      _local.upsertFolders(response.items.whereType<NoteFolderDto>().toList());
      if (!response.hasMore) break;
      page++;
    }
  }, errorFilterFn: menoExceptionFilter);

  /// Updates [searchQuery] and re-subscribes the notes stream with the new
  /// keyword filter.
  late final performSearch = Command.createSyncNoResult<String>((query) {
    searchQuery.value = query;
  }, errorFilterFn: menoExceptionFilter);

  late final deleteFolder = Command.createAsyncNoResult<Id>((folderId) async {
    final remoteId = folderId.getOrCrash();
    _local.deleteFolderByRemoteId(remoteId);
    await _http.deleteFolder(remoteId);
  }, errorFilterFn: (e, _) => ErrorReaction.globalHandler);

  Future<void> _resubscribe() async {
    await _cancelStreamSubscriptions();

    _countSubscription = _local.watchFolders().listen(
      (all) => totalFoldersCount.value = all.length,
    );

    _subscription = _local
        .watchFolders(
          keywords: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        )
        .listen(
          (incoming) {
            folders.startTransAction();
            folders.clear();
            folders.addAll(incoming.map((note) => note.toDomain).toList());
            folders.endTransAction();
          },
          onError: (dynamic error) {
            if (error is MenoException) throw error;
            throw MenoException(error.toString());
          },
        );
  }

  Future<void> _cancelStreamSubscriptions() async {
    await _subscription?.cancel();
    await _countSubscription?.cancel();

    _subscription = null;
    _countSubscription = null;
  }

  void clearSearch() {
    _activeKeywords = '';
    searchQuery.value = '';
    _resubscribe();
  }

  @override
  FutureOr<dynamic> onDispose() async {
    log.d('FoldersManager: Disposing...');

    _debouncedSearch?.cancel();
    _debouncedSearch = null;

    await _cancelStreamSubscriptions();

    folders.dispose();
    searchQuery.dispose();
    totalFoldersCount.dispose();

    initialize.dispose();
    syncRemoteFolders.dispose();
    performSearch.dispose();
    deleteFolder.dispose();
  }
}
