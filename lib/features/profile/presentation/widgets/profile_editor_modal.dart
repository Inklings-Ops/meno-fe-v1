import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/profile/applications/applications.dart';
import 'package:meno/features/profile/domain/domain.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

typedef _Manager = ProfileEditorManager;

class ProfileEditorModal extends WatchingWidget {
  const ProfileEditorModal._(this.profile) : super(key: null);
  final Profile profile;

  static Future<dynamic> show(BuildContext context, Profile profile) {
    return showModalBottomSheet<dynamic>(
      context: context,
      builder: (context) => ProfileEditorModal._(profile),
      isScrollControlled: true,
      useRootNavigator: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = createOnce(GlobalKey<FormState>.new);

    pushScope(
      init: (getIt) => getIt.registerLazySingleton(() {
        return ProfileEditorManager(
          mediaService: getIt<MediaService>(),
          profile: profile,
          repository: getIt<IProfileRepository>(),
        );
      }),
    );

    registerHandler(
      select: (ProfileEditorManager m) => m.submit,
      handler: (context, newValue, cancel) {
        if (newValue != null) context.pop();
      },
    );

    return MModal(
      title: 'Edit profile details',
      builder: (context) => SingleChildScrollView(
        padding: MediaQuery.viewInsetsOf(context),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spaces.verticalLarge,
              Align(child: ProfileFormAvatar()),
              Spaces.verticalXLarge,
              ProfileFormNameField(),
              Spaces.verticalXLarge,
              ProfileFormDescriptionField(),
              Spaces.verticalXLarge,
              ProfileFormSubmitButton(),
              SizedBox(height: 56),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileFormAvatar extends WatchingWidget {
  const ProfileFormAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    final manager = di<_Manager>();
    final profile = watchValue((MyProfileManager m) => m.profile);
    final image = watchValue((_Manager m) => m.image);

    return SizedBox.square(
      dimension: 96,
      child: Stack(
        children: [
          MAvatar(
            radius: 49,
            url: profile?.image?.getUrl(),
            file: image?.getFile(),
            hasBorder: false,
            onTap: () => context.showModal<void>(
              MImageSourceModal(
                onGallerySourceTap: manager.onImageChanged,
                onCameraSourceTap: () => manager.onImageChanged(false),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: Insets.xxl,
              width: Insets.xxl,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary,
                border: Border.all(width: 2, color: colors.onPrimary),
              ),
              child: Icon(MIcons.edit_02, size: 16, color: colors.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileFormNameField extends WatchingWidget {
  const ProfileFormNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<_Manager>();
    final profile = watchValue((MyProfileManager m) => m.profile);
    final fullName = watchValue((_Manager m) => m.fullName);
    final isLoading = watchValue((_Manager m) => m.submit.isRunning);

    return MTextFormField(
      label: 'Name',
      hint: 'John Doe',
      required: true,
      enabled: !isLoading,
      initialValue: profile?.fullName.getOrNull(),
      onChanged: manager.onFullNameChanged,
      validator: (_) => fullName.failureOrNull?.msg,
    );
  }
}

class ProfileFormDescriptionField extends WatchingWidget {
  const ProfileFormDescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<_Manager>();
    final profile = watchValue((MyProfileManager m) => m.profile);
    final bio = watchValue((_Manager m) => m.bio);
    final isLoading = watchValue((_Manager m) => m.submit.isRunning);

    return MTextArea(
      label: 'Description',
      hint: 'Enter a brief description',
      maxLines: 5,
      maxLength: 244,
      enabled: !isLoading,
      initialValue: profile?.bio?.getOrNull(),
      onChanged: manager.onBioChanged,
      validator: (_) => bio?.failureOrNull?.msg,
    );
  }
}

class ProfileFormSubmitButton extends WatchingWidget {
  const ProfileFormSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<_Manager>();
    final hasChanges = watchValue((_Manager m) => m.hasChanges);
    final isFormValid = watchValue((_Manager m) => m.isFormValid);
    final isLoading = watchValue((_Manager m) => m.submit.isRunning);

    return MPrimaryButton(
      label: 'Save changes',
      loading: isLoading,
      disabled: !isFormValid || !hasChanges,
      onPressed: () {
        if (Form.of(context).validate()) manager.submit.run();
      },
    );
  }
}
