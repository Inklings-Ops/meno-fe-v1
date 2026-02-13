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

  // Track the created broadcast ID for recovery scenarios
  Id? _createdBroadcastId;

  // Track which step we've completed
  final step = ValueNotifier(BroadcastCreationStep.none);

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
    // IMPORTANT: Only create new ID if we don't have one
    // This prevents creating multiple drafts as user types
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

  late final saveBroadcastSession = Command.createAsync<Broadcast, Broadcast>(
    (broadcast) async {
      // Skip if already completed
      if (step.value.index >= BroadcastCreationStep.saved.index) {
        log.i('BroadcastFormManager: Session already saved, skipping');
        return broadcast;
      }

      log.i('BroadcastFormManager: Step 3 - Saving active broadcast session');
      await _repository.saveActiveBroadcastSession(_userId, broadcast);
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
        // Fetch the already-started broadcast
        final result = await _repository.getBroadcast(broadcastId);
        return result.fold((error) => throw error, (broadcast) => broadcast);
      }

      log.i('BroadcastFormManager: Step 2 - Starting broadcast');
      final result = await _repository.startBroadcast(broadcastId);
      return result.fold(
        (failure) {
          log.e('BroadcastFormManager: Failed to start broadcast - $failure');
          throw failure;
        },
        (broadcast) {
          log.i('BroadcastFormManager: Broadcast started successfully');
          step.value = BroadcastCreationStep.started;

          // Persist the updated step
          _updateDraftWithCreationState(broadcastId, step.value);

          return broadcast;
        },
      );
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

        // Fetch the existing broadcast to continue the flow
        final result = await _repository.getBroadcast(_createdBroadcastId!);
        return result.fold(
          (failure) {
            log.e('BroadcastFormManager: Failed to fetch existing - $failure');
            // If we can't fetch it, it might be deleted - reset and retry
            _resetCreationState();
            throw failure;
          },
          (broadcast) {
            log.i('BroadcastFormManager: Recovered existing broadcast');
            return broadcast;
          },
        );
      }

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
          log.i('BroadcastFormManager: Broadcast created - $broadcast');
          _createdBroadcastId = broadcast.id;
          step.value = BroadcastCreationStep.created;

          // Persist the step and broadcast ID to the current draft
          _updateDraftWithCreationState(broadcast.id, step.value);

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
    _currentDraftId = null; // Clear current draft ID
    _resetCreationState();
  });

  /// Reset the creation state tracking
  void _resetCreationState() {
    _createdBroadcastId = null;
    step.value = BroadcastCreationStep.none;
  }

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

  void loadDraft(BroadcastDraft draft) {
    _currentDraftId = draft.id;

    title.value = draft.title;
    desc.value = draft.description;
    image.value = draft.image ?? ImageInput.empty;
    cohosts.value = draft.cohosts;
    record.value = draft.record;

    // Restore creation state from draft
    if (draft.createdBroadcastId != null) {
      _createdBroadcastId = draft.createdBroadcastId;
      step.value = draft.creationStep;
      log.i(
        'BroadcastFormManager: Restored creation state - ${draft.creationStep}',
      );
    }
  }

  /// Deletes a draft by ID
  Future<void> deleteDraft(Id draftId) async {
    try {
      log.i('BroadcastFormManager: Deleting draft - $draftId');
      await _repository.deleteDraft(userId: _userId, draftId: draftId);

      // If we're deleting the current draft, reset the form
      if (_currentDraftId == draftId) resetForm.run();
    } catch (e) {
      log.e('BroadcastFormManager: Failed to delete draft - $e');
      rethrow;
    }
  }

  /// Persists creation state to the current draft for crash recovery
  Future<void> _updateDraftWithCreationState(
    Id broadcastId,
    BroadcastCreationStep currentStep,
  ) async {
    if (_currentDraftId == null) return;

    try {
      // Get current draft data
      final currentDraft = _form.value;

      // Update with creation state
      final updatedDraft = currentDraft.copyWith(
        createdBroadcastId: broadcastId,
        creationStep: currentStep,
      );

      // Save back to storage
      await _repository.saveDraft(userId: _userId, draft: updatedDraft);
      log.d('BroadcastFormManager: Persisted creation state to draft');
    } catch (e) {
      log.e('BroadcastFormManager: Failed to persist creation state - $e');
    }
  }

  /// Private helper that actually calls the repo
  Future<void> _performAutoSave(BroadcastDraft draft) async {
    // Don't save empty/useless drafts
    if (!draft.title.isValid && !draft.description.isValid) return;
    await _repository.saveDraft(userId: _userId, draft: draft);
  }

  @override
  FutureOr<dynamic> onDispose() {
    step.dispose();

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
