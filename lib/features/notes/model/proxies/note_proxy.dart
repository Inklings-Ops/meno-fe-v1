import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/model/entities/common_enums.dart';
import 'package:meno/features/notes/model/_model.dart';
import 'package:meno/features/notes/services/_services.dart';

final class NoteProxy extends ChangeNotifier implements Disposable {
  NoteProxy(this._note, {required String currentUserId})
    : _currentUserId = currentUserId;

  Note _note;
  final String _currentUserId;
  bool? _pinnedOverride;

  NoteFolder? _folderOverride;
  bool _folderOverrideSet = false;
  int referenceCount = 0;

  Note get note => _note;

  set note(Note value) {
    _pinnedOverride = null;
    _folderOverrideSet = false;
    _folderOverride = null;
    _note = value;
    notifyListeners();
  }

  Id get id => _note.id;

  String get idStr => _note.id.getOrCrash();

  String get title => _note.title.getOrElse((_) => 'Untitled');

  String get content => _note.content.getOrElse((_) => '');

  bool get pinned => _pinnedOverride ?? _note.pinned;

  NoteFolder? get folder => _folderOverrideSet ? _folderOverride : _note.folder;

  SyncStatus get syncStatus => _note.syncStatus;

  bool get isSyncing => _note.syncStatus.isPending;

  DateTime? get updatedAt => _note.updatedAt;

  DateTime? get createdAt => _note.createdAt;

  late final togglePin = Command.createAsyncNoParamNoResult(() async {
    _pinnedOverride = !pinned;
    notifyListeners();

    final updated = _note.copyWith(pinned: _pinnedOverride);
    final dto = updated.toDto(ownerId: _currentUserId, pending: true);
    di<NotesLocalService>().upsertNote(dto);

    await di<NotesHttpService>().updateNote(ownerId: _currentUserId, dto: dto);

    _pinnedOverride = null;
    notifyListeners();
  }, errorFilterFn: menoExceptionFilter);

  late final assignToFolder = Command.createAsyncNoResult<NoteFolder>((
    folder,
  ) async {
    _folderOverride = folder;
    _folderOverrideSet = true;
    notifyListeners();

    di<NotesLocalService>().batchAssignNotesToFolder(
      remoteNoteIds: [id.getOrCrash()],
      remoteFolderId: folder.id.getOrCrash(),
    );

    await di<NotesHttpService>().addNoteToFolder(
      ownerId: _currentUserId,
      noteId: idStr,
      folderId: folder.id.getOrCrash(),
    );

    _folderOverrideSet = false;
    _folderOverride = null;
    notifyListeners();
  }, errorFilterFn: menoExceptionFilter);

  late final removeFromFolder = Command.createAsyncNoParamNoResult(() async {
    final currentFolder = _note.folder;
    if (currentFolder == null) return;

    _folderOverride = null;
    _folderOverrideSet = true;
    notifyListeners();

    di<NotesLocalService>().batchRemoveNotesFromFolder([idStr]);

    await di<NotesHttpService>().removeNoteFromFolder(
      noteId: idStr,
      folderId: currentFolder.id.getOrCrash(),
    );

    _folderOverrideSet = false;
    notifyListeners();
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() {
    togglePin.dispose();
    assignToFolder.dispose();
    removeFromFolder.dispose();
    dispose();
  }
}
