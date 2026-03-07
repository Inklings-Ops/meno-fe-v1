import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/_shared/services/media_service.dart';
import 'package:meno/features/broadcast/model/model.dart';
import 'package:meno/features/broadcast/services/_services.dart';

final class BroadcastEditorManager with MLogger implements Disposable {
  BroadcastEditorManager({
    required BroadcastHttpService http,
    required BroadcastLocalService local,
    required MediaService media,
    required Id currentUserId,
  }) : _http = http,
       _local = local,
       _media = media,
       _currentUserId = currentUserId;

  final BroadcastHttpService _http;
  final BroadcastLocalService _local;
  final MediaService _media;
  final Id _currentUserId;

  Id? _currentDraftId;
  Id? _createdBroadcastId;

  final drafts = ListNotifier<BroadcastDraft?>(data: []);
  final step = ValueNotifier(BroadcastCreationStep.none);

  final title = ValueNotifier(SingleLineString.empty);
  final desc = ValueNotifier(MultiLineString.empty);
  final image = ValueNotifier(ImageInput.empty);
  final cohosts = ValueNotifier(<Id>[]);
  final record = ValueNotifier(false);

  void onTitleChanged(String input) => title.value = SingleLineString(input);

  void onDescChanged(String input) => desc.value = MultiLineString(input);

  Future<void> onImagePicked([bool fromGallery = true]) async {
    final file = await _media.getImage(fromGallery: fromGallery);
    if (file != null) image.value = ImageInput.fromFile(file);
  }

  void onImageRemoved() => image.value = ImageInput.empty;

  void onToggleRecord(bool input) => record.value = input;

  void onAddCohost() {}

  void onRemoveCohost() {}

  late final fetchBroadcast = Command.createAsync<Id, Broadcast>(
    _http.getBroadcast,
    initialValue: Broadcast.empty,
    errorFilterFn: menoExceptionFilter,
  )..errors.listen((error, _) => _resetCreationState());

  late final saveBroadcastSession = Command.createAsync<Broadcast, Broadcast>(
    (broadcast) async {
      // Skip if already completed
      if (step.value.index >= BroadcastCreationStep.saved.index) {
        log.i('BroadcastFormManager: Session already saved, skipping');
        return broadcast;
      }

      log.i('BroadcastFormManager: Step 3 - Saving active broadcast session');
      await _local.saveActiveBroadcastSession(
        userId: _currentUserId,
        session: BroadcastSession.create(broadcast),
      );
      step.value = BroadcastCreationStep.saved;
      return broadcast;
    },
    initialValue: Broadcast.empty,
    errorFilterFn: menoExceptionFilter,
  );

  late final startBroadcast = Command.createAsync<Id, Broadcast>(
    (broadcastId) async {
      // Skip if already completed
      if (step.value.index >= BroadcastCreationStep.started.index) {
        log.i('BroadcastFormManager: Broadcast already started, skipping');
        return fetchBroadcast.runAsync();
      }

      final result = await _http.startBroadcast(broadcastId);
      step.value = BroadcastCreationStep.started;

      await _updateDraftWithCreationState(broadcastId, step.value);
      return result;
    },
    initialValue: Broadcast.empty,
    errorFilterFn: menoExceptionFilter,
  )..pipeToCommand(saveBroadcastSession, transform: (value) => value);

  late final createBroadcast = Command.createAsyncNoParam(
    () async {
      // If we already created a broadcast, skip creation and use existing ID
      final createdIndex = BroadcastCreationStep.created.index;
      if (step.value.index >= createdIndex && _createdBroadcastId != null) {
        log.i('BroadcastFormManager: Broadcast already created, recovering');
        return fetchBroadcast.runAsync();
      }

      log.i('BroadcastFormManager: Step 1 - Creating broadcast');
      final broadcast = await _http.createBroadcast(
        title: title.value,
        description: desc.value,
        cohosts: cohosts.value,
        image: image.value,
      );

      log.i('BroadcastFormManager: Broadcast created - $broadcast');
      _createdBroadcastId = broadcast.id;
      step.value = BroadcastCreationStep.created;

      // Persist the step and broadcast ID to the current draft
      await _updateDraftWithCreationState(broadcast.id, step.value);
      return broadcast;
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
    _resetCreationState();
  });

  late final deleteDraft = Command.createAsyncNoResult((Id draftId) async {
    log.i('BroadcastFormManager: Deleting draft - $draftId');
    await _local.deleteDraft(userId: _currentUserId, draftId: draftId);
    // If we're deleting the current draft, reset the form
    if (_currentDraftId == draftId) resetForm.run();
    _loadAllDraftsFromStorage();
  }, errorFilterFn: menoExceptionFilter);

  late final _form = title.combineLatest5(desc, image, cohosts, record, (
    titleValue,
    descriptionValue,
    imageValue,
    cohostsValue,
    recordValue,
  ) {
    _currentDraftId ??= Id.unique();

    return BroadcastDraft(
      id: _currentDraftId!,
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

  late final isRunning = createBroadcast.isRunning.combineLatest3(
    startBroadcast.isRunning,
    saveBroadcastSession.isRunning,
    (isCreating, isStarting, isSaving) => isCreating || isStarting || isSaving,
  );

  late final errors = createBroadcast.errors.combineLatest3(
    startBroadcast.errors,
    saveBroadcastSession.errors,
    (createErr, startErr, saveErr) => createErr ?? startErr ?? saveErr,
  );

  void _loadAllDraftsFromStorage() {
    final allDrafts = _local.getAllDrafts(_currentUserId);
    drafts.startTransAction();
    drafts.clear();
    drafts.addAll(allDrafts);
    drafts.endTransAction();
  }

  Future<void> _performAutoSave(BroadcastDraft draft) async {
    if (!draft.title.isValid && !draft.description.isValid) return;
    await _local.saveDraft(userId: _currentUserId, draft: draft);
    _loadAllDraftsFromStorage();
  }

  void _resetCreationState() {
    final createdIndex = BroadcastCreationStep.created.index;
    if (step.value.index >= createdIndex) {
      _createdBroadcastId = null;
      step.value = BroadcastCreationStep.none;
    }
  }

  Future<void> _updateDraftWithCreationState(
    Id broadcastId,
    BroadcastCreationStep currentStep,
  ) async {
    if (_currentDraftId == null) return;

    final updatedDraft = _form.value.copyWith(
      createdBroadcastId: broadcastId,
      creationStep: currentStep,
    );

    // Save back to storage
    await _local.saveDraft(userId: _currentUserId, draft: updatedDraft);

    _loadAllDraftsFromStorage();
    log.d('BroadcastFormManager: Persisted creation state to draft');
  }

  @override
  FutureOr<dynamic> onDispose() {
    step.dispose();
    drafts.dispose();

    title.dispose();
    desc.dispose();
    image.dispose();
    cohosts.dispose();
    record.dispose();

    createBroadcast.dispose();
    startBroadcast.dispose();
    saveBroadcastSession.dispose();
    resetForm.dispose();
    fetchBroadcast.dispose();
    deleteDraft.dispose();
  }
}
