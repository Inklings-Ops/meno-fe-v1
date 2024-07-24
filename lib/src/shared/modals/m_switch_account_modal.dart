import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

class MSwitchAccountModal extends StatelessWidget {
  const MSwitchAccountModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        state.whenOrNull(
          loadFailure: (e) {
            context.showErrorSnackBar('Your token is expired. Login again.');
            context.go(Routes.login);
          },
        );
      },
      builder: (context, state) => state.maybeWhen(
        orElse: () => MModal(
          title: 'Switch Account',
          builder: (context) => const Column(
            mainAxisSize: MainAxisSize.min,
            children: [MLoadingIndicator.box()],
          ),
        ),
        loadSuccess: (allCredentials, _) {
          if (allCredentials.length == 1) {
            return const _SwitchAccountModal1();
          } else {
            return const _SwitchAccountModal2();
          }
        },
      ),
    );
  }
}

class _AccountListTile extends StatelessWidget {
  const _AccountListTile({required this.credential});
  final UserCredential credential;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        authenticated: (user, token) => buildRadioTile(
          context,
          UserCredential.fromUI(user, token),
        ),
        partiallyAuthenticated: (user) => buildRadioTile(
          context,
          UserCredential.fromUI(user),
        ),
      ),
    );
  }

  Widget buildRadioTile(BuildContext context, UserCredential auth) {
    final user = credential.user;
    return RadioListTile<UserCredential>(
      key: ObjectKey(auth),
      value: credential,
      groupValue: auth,
      onChanged: (value) {
        context.read<AccountBloc>().add(AccountSwitchRequested(credential));
        context.pop();
      },
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 14, 12).radius,
      dense: true,
      title: Row(
        children: [
          MAvatar(radius: 20.toScale, url: user.imageUrl),
          $styles.spaces.horizontalLarge,
          MText(
            user.fullName.getOr(),
            style: $styles.text.bodyRegular,
          ),
        ],
      ),
    );
  }
}

class _AddAccountTile extends StatelessWidget {
  const _AddAccountTile();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return InkWell(
      onTap: () {
        context.pop();
        context.read<SessionCubit>().logout();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16).radius,
        child: Row(
          children: [
            const Icon(MIcons.plus_circle),
            $styles.spaces.horizontalMedium,
            Expanded(
              child: MText(
                'Add Account',
                style: $styles.text.bodyMedium,
                color: colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchAccountModal1 extends StatelessWidget {
  const _SwitchAccountModal1();

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: 'Switch Account',
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MPrimaryButton(
            label: 'Log in to Existing Account',
            onPressed: () {
              context.pop();
              context.read<SessionCubit>().logout();
            },
          ),
          MTextButton(
            label: 'Create New Account',
            onPressed: () {
              context.pop();
              context.go(Routes.registerWithoutLeading);
            },
          ),
        ],
      ),
    );
  }
}

class _SwitchAccountModal2 extends StatelessWidget {
  const _SwitchAccountModal2();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) => MModal(
        title: 'Switch Account',
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: state.maybeWhen(
            orElse: () => [],
            loadSuccess: (allCredentials, currentCredential) => [
              ...allCredentials.map((c) => _AccountListTile(credential: c)),
              24.vSpace,
              const _AddAccountTile(),
            ],
          ),
        ),
      ),
    );
  }
}
