import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/infrastructure/dtos/note_folder_dto.dart';
import 'package:meno/shared/domain/value_objects/id.dart';
import 'package:meno/shared/domain/value_objects/single_line_string.dart';

class FolderEditorManager with MLogger implements Disposable {
  FolderEditorManager({
    required INotesRepository repository,
    required this.folderId,
  }) : _repository = repository;

  final INotesRepository _repository;
  final String? folderId;

  final folder = ValueNotifier<NoteFolder>(.empty);
  final error = ValueNotifier<MenoException?>(null);
  final isEdit = ValueNotifier<bool>(false);

  bool _hasBeenCreated = false;
  bool isInitialized = false;

  late final initialize = Command.createAsyncNoParamNoResult(() async {
    log.d('FolderEditorManager: $folderId');
    if (folderId == null) {
      folder.value = NoteFolder.fromNewId(Id.unique());
    } else {
      isEdit.value = true;
      final id = Id.fromString(folderId!);
      final result = await _repository.getFolder(id);
      result.fold((err) => throw err, (success) => folder.value = success);
      log.d('FolderEditorManager: ${folder.value.toDto.toJson()}');
      _hasBeenCreated = true;
    }
    isInitialized = true;
  }, errorFilterFn: menoExceptionFilter);

  late final submit = Command.createAsyncNoParamNoResult(() async {
    if (!folder.value.isValid) return;

    error.value = null;

    final result = _hasBeenCreated
        ? await _repository.updateFolder(folder.value)
        : await _repository.createFolder(folder.value);

    result.fold(
      (failure) {
        log.e('FolderEditorManager: submit failed — $failure');
        error.value = failure;
      },
      (success) {
        folder.value = success;
        _hasBeenCreated = true;
        log.d('FolderEditorManager: note saved: ${success.id.getOrCrash()}');
      },
    );
  }, errorFilterFn: menoExceptionFilter);

  void onTitleChanged(String value) {
    final newTitle = SingleLineString(value);
    folder.value = folder.value.copyWith(title: newTitle);
  }

  @override
  FutureOr<dynamic> onDispose() {
    log.i('FolderEditorManager: Disposing...');

    folder.dispose();
    error.dispose();
    isEdit.dispose();

    initialize.dispose();
    submit.dispose();
  }
}
