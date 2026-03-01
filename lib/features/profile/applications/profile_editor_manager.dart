import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/profile/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

class ProfileEditorManager with MLogger implements Disposable {
  ProfileEditorManager({
    required Profile profile,
    required IProfileRepository repository,
    required MediaService mediaService,
  }) : _profile = profile,
       _repository = repository,
       _mediaService = mediaService;

  final Profile _profile;
  final IProfileRepository _repository;
  final MediaService _mediaService;

  late final fullName = ValueNotifier(_profile.fullName);
  late final bio = ValueNotifier(_profile.bio);
  late final image = ValueNotifier<ImageInput?>(null);

  late final submit = Command.createAsyncNoParam<Profile?>(
    () async {
      if (!isFormValid.value) return null;

      final result = await _repository.editProfile(
        id: _profile.id,
        bio: bio.value,
        fullName: fullName.value,
        image: image.value,
      );
      return result.fold((failure) => throw failure, (profile) => profile);
    },
    errorFilterFn: menoExceptionFilter,
    initialValue: null,
  );

  void onFullNameChanged(String i) => fullName.value = SingleLineString(i);

  void onBioChanged(String i) => bio.value = MultiLineString(i, maxLength: 244);

  Future<void> onImageChanged([bool fromGallery = true]) async {
    final file = await _mediaService.getImage(fromGallery: fromGallery);
    if (file != null) image.value = ImageInput.fromFile(file);
  }

  void onImageRemoved() => image.value = _profile.image;

  late final isFormValid = fullName.combineLatest3(
    bio,
    image,
    (fullNameValue, bioValue, imageValue) =>
        fullNameValue.isValid &&
        (bioValue?.isValid ?? true) &&
        (imageValue?.isValid ?? true),
  );

  late final hasChanges = fullName.combineLatest3(
    bio,
    image,
    (fullNameValue, bioValue, imageValue) =>
        (fullNameValue != _profile.fullName) ||
        (bioValue != _profile.bio) ||
        imageValue != null,
  );

  @override
  FutureOr<dynamic> onDispose() {
    fullName.dispose();
    bio.dispose();
    image.dispose();

    submit.dispose();
  }
}
