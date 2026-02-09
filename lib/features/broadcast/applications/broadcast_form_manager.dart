import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

class BroadcastFormManager implements Disposable {
  BroadcastFormManager({
    required Id currentUserId,
    required IBroadcastRepository repository,
  }) : _currentUserId = currentUserId,
       _repository = repository {
    _repository.getDrafts(currentUserId);

    _form
        .debounce(const Duration(milliseconds: 500))
        .listen((state, _) => _performAutoSave(state));
  }

  final Id _currentUserId;
  final IBroadcastRepository _repository;

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

  void onImagePicked(File input) => image.value = ImageInput.fromFile(input);

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

  late final createBroadcast = Command.createAsyncNoParam(
    () async {
      final result = await _repository.createBroadcast(
        title: title.value,
        description: desc.value,
        cohosts: cohosts.value,
        image: image.value,
      );
      return result.fold((error) => throw error, (broadcast) => broadcast);
    },
    initialValue: Broadcast.empty,
    restriction: isValid.map((value) => !value),
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
    await _repository.saveDraft(userId: _currentUserId, draft: draft);
  }

  @override
  FutureOr<dynamic> onDispose() {
    title.dispose();
    desc.dispose();
    image.dispose();
    cohosts.dispose();
    record.dispose();
    createBroadcast.dispose();
  }
}
