import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/notes/model/_model.dart';
import 'package:meno/features/notes/services/_services.dart';

final class FolderManager with MLogger implements Disposable {
  FolderManager({
    required NotesLocalService local,
    required Id folderId,
    required Id currentUserId,
  }) : _local = local,
       _folderId = folderId.getOrCrash(),
       _ownerId = currentUserId.getOrCrash() {
    _debouncedSearch = searchQuery
        .where((q) => q != _activeKeywords)
        .debounce(const Duration(milliseconds: 400))
        .listen((query, _) {
          _activeKeywords = query;
          _resubscribe();
        });
  }

  final NotesLocalService _local;
  final String _folderId;
  final String _ownerId;

  final folder = ValueNotifier<NoteFolder>(.empty);
  final notes = ListNotifier<Note>(data: []);
  final searchQuery = ValueNotifier<String>('');
  final totalNotesCount = ValueNotifier<int>(0);

  ListenableSubscription? _debouncedSearch;

  StreamSubscription<NoteFolderDto?>? _folderSubscription;
  StreamSubscription<List<NoteDto>>? _notesInFolderSubscription;
  StreamSubscription<List<NoteDto>>? _notesCountSubscription;

  String _activeKeywords = '';

  late final initialize = Command.createAsyncNoParamNoResult(() async {
    log.d('FoldersManager: Initializing...');
    return _resubscribe();
  }, errorFilterFn: menoExceptionFilter);

  late final performSearch = Command.createSync<String, void>(
    _onSearchChanged,
    initialValue: null,
  );

  Future<void> _resubscribe() async {
    await _cancelStreamSubscriptions();

    _folderSubscription = _local
        .watchFolder(ownerId: _ownerId, folderId: _folderId)
        .listen(
          (incoming) {
            if (incoming == null) return;
            folder.value = incoming.toDomain;
          },
          onError: (dynamic error) {
            if (error is MenoException) throw error;
            throw MenoException(error.toString());
          },
        );

    _notesInFolderSubscription = _local
        .watchNotesInFolder(
          folderId: _folderId,
          ownerId: _ownerId,
          keywords: searchQuery.value.isEmpty ? null : searchQuery.value,
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

    _notesCountSubscription = _local
        .watchNotesInFolder(folderId: _folderId, ownerId: _ownerId)
        .listen((all) => totalNotesCount.value = all.length);
  }

  void _onSearchChanged(String query) {
    searchQuery.value = query;
    if (_activeKeywords == query) return;
    _activeKeywords = query;
    _resubscribe();
  }

  Future<void> _cancelStreamSubscriptions() async {
    await _folderSubscription?.cancel();
    await _notesInFolderSubscription?.cancel();
    await _notesCountSubscription?.cancel();

    _folderSubscription = null;
    _notesInFolderSubscription = null;
    _notesCountSubscription = null;
  }

  @override
  FutureOr<dynamic> onDispose() async {
    log.d('FolderManager: Disposing...');

    await _cancelStreamSubscriptions();

    _debouncedSearch?.cancel();
    _debouncedSearch = null;

    folder.dispose();
    notes.dispose();
    totalNotesCount.dispose();
    searchQuery.dispose();

    initialize.dispose();
    performSearch.dispose();
  }
}
