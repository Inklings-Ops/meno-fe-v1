import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/notes/model/_model.dart';
import 'package:meno/features/notes/services/_services.dart';

final class FolderEditorManager with MLogger implements Disposable {
  FolderEditorManager({
    required NotesHttpService http,
    required NotesLocalService local,
    required Id? folderId,
  }) : _http = http,
       _local = local,
       _folderId = folderId;

  final NotesHttpService _http;
  final NotesLocalService _local;
  final Id? _folderId;

  final folder = ValueNotifier<NoteFolder>(.empty);
  final isEdit = ValueNotifier<bool>(false);

  bool _hasBeenCreated = false;

  void onTitleChanged(String value) {
    final newTitle = SingleLineString(value);
    folder.value = folder.value.copyWith(title: newTitle);
  }

  late final initialize = Command.createSyncNoParamNoResult(() {
    if (_folderId == null) {
      folder.value = NoteFolder.fromNewId(Id.unique());
    } else {
      isEdit.value = true;
      final result = _local.findFolderByRemoteId(_folderId.getOrCrash());
      if (result == null) throw const MenoException('No folder found');
      folder.value = result.toDomain;
      _hasBeenCreated = true;
    }
  }, errorFilterFn: menoExceptionFilter);

  late final submit = Command.createAsyncNoParamNoResult(() async {
    if (!folder.value.isValid) return;

    if (_hasBeenCreated) {
      await _update(folder.value);
    } else {
      await _create(folder.value);
    }
  }, errorFilterFn: menoExceptionFilter);

  Future<void> _create(NoteFolder current) async {
    final dto = current.toDto(pending: true);

    _local.upsertFolder(dto);
    final confirmed = await _http.createFolder(dto);

    _local.deleteFolderByRemoteId(current.id.getOrCrash());
    _local.upsertFolder(confirmed.toDto());

    _hasBeenCreated = true;
    folder.value = confirmed;
  }

  Future<void> _update(NoteFolder current) async {
    final dto = current.toDto(pending: true);

    _local.upsertFolder(dto);
    final confirmed = await _http.updateFolder(dto.id, dto);

    _local.upsertFolder(confirmed.toDto());

    folder.value = confirmed;
  }

  @override
  FutureOr<dynamic> onDispose() {
    log.i('FolderEditorManager: Disposing...');

    folder.dispose();
    isEdit.dispose();

    initialize.dispose();
    submit.dispose();
  }
}
