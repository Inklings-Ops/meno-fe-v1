import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class MSwitchAccountModal extends StatelessWidget {
  const MSwitchAccountModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) => MModal(
        title: 'Switch Account',
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            switch (state) {
              AccountLoadInProgress() => const MLoadingIndicator.box(),
              AccountLoadSuccess(:final credential, :final allCredentials) =>
                _AllSavedCredentialsContent(
                  selectedCredential: credential,
                  credentials: allCredentials,
                ),
              _ => const _LogInToExistingAccountContent(),
            },
          ],
        ),
      ),
    );
  }
}

class _LogInToExistingAccountContent extends StatelessWidget {
  const _LogInToExistingAccountContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MPrimaryButton(
          label: 'Log in to Existing Account',
          onPressed: () => context
            ..read<SessionBloc>().add(const SessionLogoutRequested())
            ..pop(),
        ),
        Spaces.verticalMicro,
        MTextButton(
          label: 'Create New Account',
          style: TextButton.styleFrom(fixedSize: const Size.fromHeight(48)),
          onPressed: () => context..go(Routes.registerWithoutLeading),
        ),
      ],
    );
  }
}

class _AllSavedCredentialsContent extends StatelessWidget {
  const _AllSavedCredentialsContent({
    required this.credentials,
    required this.selectedCredential,
  });

  final List<UserCredential?> credentials;
  final UserCredential selectedCredential;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...credentials.map((credential) {
          if (credential == null) return const SizedBox.shrink();
          final user = credential.user;
          return RadioListTile<UserCredential?>(
            key: ObjectKey(credential),
            value: credential,
            groupValue: selectedCredential,
            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
            title: Row(
              children: [
                MAvatar(radius: 20, url: user.imageUrl),
                Spaces.horizontalLarge,
                MText(user.fullName.getOrCrash(), style: textTheme.bodyRegular),
              ],
            ),
            onChanged: (value) {
              router.pop(context);
              context.read<AccountBloc>().add(AccountSwitchRequested(value!));
            },
          );
        }),
        MModalListTile(
          leading: const Icon(MIcons.plus_circle),
          title: 'Add account',
          titleColor: colors.primary,
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          onTap: () => logout(context),
        ),
        MModalListTile(
          leading: const Icon(MIcons.log_out),
          title: 'Logout',
          titleColor: colors.error,
          onTap: () => logout(context),
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        ),
      ],
    );
  }

  void logout(BuildContext context) {
    context
      ..read<SessionBloc>().add(const SessionLogoutRequested())
      ..pop();
  }
}
