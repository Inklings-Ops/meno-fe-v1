import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class EditProfileModal extends StatelessWidget {
  const EditProfileModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileFormCubit, ProfileFormState>(
      listener: (context, state) {
        switch (state.status) {
          case FormStatus.failure:
            context.showErrorSnackBar(state.exception!.message);
          case FormStatus.success:
            final bloc = context.read<MyProfileCubit>();
            bloc.optimisticallyUpdate(state.profile!);
          case FormStatus.canceled:
          case FormStatus.initial:
          case FormStatus.loading:
            return;
        }
      },
      child: MModal(
        title: 'Edit profile details',
        builder: (context) => SingleChildScrollView(
          padding: MediaQuery.viewInsetsOf(context),
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

class ProfileFormAvatar extends StatelessWidget {
  const ProfileFormAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final bloc = context.read<ProfileFormCubit>();
    final url = context.select<MyProfileCubit, String?>(
      (bloc) => switch (bloc.state) {
        MyProfileLoadSuccess(:final profile) => profile.imageUrl,
        _ => null,
      },
    );

    return BlocBuilder<ProfileFormCubit, ProfileFormState>(
      buildWhen: (p, c) => p.avatar != c.avatar || p.status != c.status,
      builder: (context, state) => SizedBox.square(
        dimension: 96,
        child: Stack(
          children: [
            MAvatar(
              radius: 49,
              url: url,
              file: state.avatar?.getOrCrash(),
              hasBorder: false,
              onTap: () => context.showModal<void>(
                MImageSourceModal(
                  onGallerySourceTap: bloc.avatarChanged,
                  onCameraSourceTap: () {
                    bloc.avatarChanged(fromGallery: false);
                  },
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
      ),
    );
  }
}

class ProfileFormNameField extends StatelessWidget {
  const ProfileFormNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileFormCubit, ProfileFormState>(
      buildWhen: (p, c) => p.fullName != c.fullName || p.status != c.status,
      builder: (context, state) => MTextFormField(
        label: 'Name',
        hint: 'John Doe',
        required: true,
        enabled: !state.status.isLoading,
        initialValue: state.fullName?.getOrNull(),
        onChanged: context.read<ProfileFormCubit>().fullNameChanged,
        validator: (_) => state.fullName?.failureOrNull?.message,
      ),
    );
  }
}

class ProfileFormDescriptionField extends StatelessWidget {
  const ProfileFormDescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileFormCubit, ProfileFormState>(
      buildWhen: (p, c) => p.bio != c.bio || p.status != c.status,
      builder: (context, state) => MTextArea(
        label: 'Description',
        hint: 'Enter a brief description',
        maxLines: 5,
        maxLength: 244,
        enabled: !state.status.isLoading,
        initialValue: state.bio?.getOrCrash(),
        onChanged: context.read<ProfileFormCubit>().bioChanged,
        validator: (_) => state.bio?.failureOrNull?.message,
      ),
    );
  }
}

class ProfileFormSubmitButton extends StatelessWidget {
  const ProfileFormSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileFormCubit, ProfileFormState>(
      buildWhen: (p, c) => p.status != c.status || p.hasChanges != c.hasChanges,
      builder: (context, state) => MPrimaryButton(
        label: 'Save changes',
        loading: state.status.isLoading,
        disabled: state.status.isLoading || !state.hasChanges,
        onPressed: context.read<ProfileFormCubit>().editProfile,
      ),
    );
  }
}
