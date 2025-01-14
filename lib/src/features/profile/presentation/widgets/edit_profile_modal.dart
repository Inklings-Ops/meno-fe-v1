import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

class EditProfileModal extends StatelessWidget {
  const EditProfileModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileFormCubit, ProfileFormState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: MModal(
        title: 'Edit profile details',
        builder: (context) => const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                child: MAvatar(radius: 49),
              ),
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

class ProfileFormNameField extends StatelessWidget {
  const ProfileFormNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<ProfileFormCubit, bool>(
      (b) => b.state.loading,
    );
    return BlocBuilder<ProfileFormCubit, ProfileFormState>(
      buildWhen: (p, c) => p.fullName != c.fullName || isLoading,
      builder: (context, state) => MTextFormField(
        label: 'Name',
        hint: 'John Doe',
        required: true,
        enabled: !isLoading,
        initialValue: state.fullName?.getOrE(''),
        onChanged: context.read<ProfileFormCubit>().fullNameChanged,
        validator: (_) => context.validator(state.fullName!.value),
      ),
    );
  }
}

class ProfileFormDescriptionField extends StatelessWidget {
  const ProfileFormDescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<ProfileFormCubit, bool>(
      (b) => b.state.loading,
    );

    return BlocBuilder<ProfileFormCubit, ProfileFormState>(
      buildWhen: (p, c) => p.bio != c.bio || isLoading,
      builder: (context, state) => MTextArea(
        label: 'Description',
        hint: 'Enter a brief description',
        maxLines: 5,
        maxLength: 244,
        enabled: !isLoading,
        initialValue: state.bio?.getOrE(''),
        onChanged: context.read<ProfileFormCubit>().bioChanged,
        validator: (_) => context.validator(state.bio!.value),
      ),
    );
  }
}

class ProfileFormSubmitButton extends StatelessWidget {
  const ProfileFormSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileFormCubit, ProfileFormState>(
      buildWhen: (p, c) =>
          p.loading != c.loading || p.hasChanges != c.hasChanges,
      builder: (context, state) => MPrimaryButton(
        label: 'Save changes',
        loading: state.loading,
        disabled: state.loading || !state.hasChanges,
        onPressed: context.read<ProfileFormCubit>().editProfile,
      ),
    );
  }
}
