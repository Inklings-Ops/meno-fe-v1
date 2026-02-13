import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

class BroadcastFormManager with MenoLogger implements Disposable {
  BroadcastFormManager({
    required Id userId,
    required IBroadcastRepository repository,
    required MediaService mediaService,
  }) : _userId = userId,
       _repository = repository,
       _mediaService = mediaService {
    _repository.getDrafts(userId);

    _form
        .debounce(const Duration(milliseconds: 500))
        .listen((state, _) => _performAutoSave(state));
  }

  final Id _userId;
  final IBroadcastRepository _repository;
  final MediaService _mediaService;

  // Track the ID of the draft we are editing (to update instead of create new)
  Id? _currentDraftId;

  ValueListenable<List<BroadcastDraft?>> get drafts => _repository.drafts;

  final title = ValueNotifier(SingleLineString.empty);
  final desc = ValueNotifier(MultiLineString.empty);
  final image = ValueNotifier(ImageInput.empty);
  final cohosts = ValueNotifier(<Id>[]);
  final record = ValueNotifier(false);

  void onTitleChanged(String input) => title.value = SingleLineString(input);

  void onDescChanged(String input) => desc.value = MultiLineString(input);

  Future<void> onImagePicked([bool fromGallery = true]) async {
    final file = await _mediaService.getImage(fromGallery: fromGallery);
    if (file != null) image.value = ImageInput.fromFile(file);
  }

  void onImageRemoved() => image.value = ImageInput.empty;

  void onToggleRecord(bool input) => record.value = input;

  void onAddCohost() {}

  void onRemoveCohost() {}

  late final _form = title.combineLatest5(desc, image, cohosts, record, (
    titleValue,
    descriptionValue,
    imageValue,
    cohostsValue,
    recordValue,
  ) {
    return BroadcastDraft(
      // Keep existing ID if we have one, else create new
      id: _currentDraftId ?? Id.unique(),
      title: titleValue,
      description: descriptionValue,
      image: imageValue,
      cohosts: cohostsValue,
      record: recordValue,
      lastModified: DateTime.now(),
    );
  });

  late final isValid = _form.map((state) {
    return state.title.isValid &&
        state.description.isValid &&
        (state.image != null && state.image!.isValid) &&
        state.cohosts.length <= 2;
  });

  late final saveBroadcastSession = Command.createAsync<Broadcast, Broadcast>(
    (broadcast) async {
      log.i('BroadcastFormManager: Step 3 - Saving active broadcast session');
      await _repository.saveActiveBroadcastSession(_userId, broadcast);
      return broadcast;
    },
    initialValue: Broadcast.empty,
    errorFilterFn: menoExceptionFilter,
  );

  late final startBroadcast = Command.createAsync<Id, Broadcast>(
    (broadcastId) async {
      log.i('BroadcastFormManager: Step 2 - Starting broadcast');
      final result = await _repository.startBroadcast(broadcastId);
      return result.fold(
        (failure) {
          log.e('BroadcastFormManager: Failed to start broadcast - $failure');
          throw failure;
        },
        (broadcast) {
          log.i('BroadcastFormManager: Broadcast started successfully');
          return broadcast;
        },
      );
    },
    initialValue: Broadcast.empty,
    errorFilterFn: menoExceptionFilter,
  )..pipeToCommand(saveBroadcastSession, transform: (value) => value);

  late final createBroadcast = Command.createAsyncNoParam(
    () async {
      log.i('BroadcastFormManager: Step 1 - Creating broadcast');
      final result = await _repository.createBroadcast(
        title: title.value,
        description: desc.value,
        cohosts: cohosts.value,
        image: image.value,
      );
      return result.fold(
        (failure) {
          log.e('BroadcastFormManager: Failed to create broadcast - $failure');
          throw failure;
        },
        (broadcast) {
          log.i('BroadcastFormManager: Broadcast created -$broadcast');
          return broadcast;
        },
      );
    },
    initialValue: Broadcast.empty,
    restriction: isValid.map((value) => !value),
    errorFilterFn: menoExceptionFilter,
  )..pipeToCommand(startBroadcast, transform: (value) => value.id);

  late final resetForm = Command.createSyncNoParamNoResult(() {
    log.i('BroadcastFormManager: Resetting form');
    title.value = SingleLineString.empty;
    desc.value = MultiLineString.empty;
    image.value = ImageInput.empty;
    cohosts.value = [];
    record.value = false;
    _currentDraftId = null;
  });

  late final isRunning = createBroadcast.isRunning.combineLatest3(
    startBroadcast.isRunning,
    saveBroadcastSession.isRunning,
    (isCreating, isStarting, isSaving) => isCreating || isStarting || isSaving,
  );

  void loadDraft(BroadcastDraft draft) {
    _currentDraftId = draft.id;

    title.value = draft.title;
    desc.value = draft.description;
    image.value = draft.image ?? ImageInput.empty;
    cohosts.value = draft.cohosts;
    record.value = draft.record;
  }

  /// Private helper that actually calls the repo
  Future<void> _performAutoSave(BroadcastDraft draft) async {
    // Don't save empty/useless drafts
    if (!draft.title.isValid && !draft.description.isValid) return;
    await _repository.saveDraft(userId: _userId, draft: draft);
  }

  @override
  FutureOr<dynamic> onDispose() {
    title.dispose();
    desc.dispose();
    image.dispose();
    cohosts.dispose();
    record.dispose();

    createBroadcast.dispose();
    startBroadcast.dispose();
    saveBroadcastSession.dispose();
    resetForm.dispose();
  }
}
