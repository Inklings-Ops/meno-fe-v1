import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/model/entities/common_enums.dart';
import 'package:meno/features/notes/model/_model.dart';
import 'package:meno/features/notes/services/_services.dart';

final class NoteFolderProxy extends ChangeNotifier implements Disposable {
  NoteFolderProxy(this._folder, {required String currentUserId})
    : _currentUserId = currentUserId;

  NoteFolder _folder;
  final String _currentUserId;

  bool? _pinnedOverride;

  set folder(NoteFolder value) {
    _pinnedOverride = null;
    _folder = value;
    notifyListeners();
  }

  NoteFolder get folder => _folder;

  Id get id => _folder.id;

  String get idStr => _folder.id.getOrCrash();

  String get title => _folder.title.value.getOrElse((_) => 'Untitled');

  bool get pinned => _pinnedOverride ?? _folder.pinned;

  int get notesCount => _folder.notes.length;

  SyncStatus get syncStatus => _folder.syncStatus;

  bool get isSyncing => syncStatus.isPending;

  late final togglePin = Command.createAsyncNoParamNoResult(() async {
    _pinnedOverride = !pinned;
    notifyListeners();

    final updated = _folder.copyWith(
      pinned: _pinnedOverride,
      syncStatus: .pending,
    );

    final dto = updated.toDto(ownerId: _currentUserId, pending: true);
    di<NotesLocalService>().upsertFolder(dto);

    _folder = updated;
    _pinnedOverride = null;
    notifyListeners();

    await di<NotesHttpService>().updateFolder(
      ownerId: _currentUserId,
      dto: dto,
    );
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() {
    togglePin.dispose();
    dispose();
  }
}
