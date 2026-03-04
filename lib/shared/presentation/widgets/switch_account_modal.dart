import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/auth/applications/auth_manager.dart';
import 'package:meno/features/profile/profile.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

class SwitchAccountModal extends WatchingWidget {
  const SwitchAccountModal._() : super(key: null);

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: 'Switch Account',
      builder: (context) => const Column(
        mainAxisSize: MainAxisSize.min,
        children: [_AllSavedCredentialsContent()],
      ),
    );
  }

  static Future<dynamic> show(BuildContext context) {
    return showModalBottomSheet<dynamic>(
      context: context,
      builder: (context) => const SwitchAccountModal._(),
      isScrollControlled: true,
      useRootNavigator: true,
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
          onPressed: () => di<AuthManager>().logout.run(),
        ),
        Spaces.verticalMicro,
        MTextButton(
          label: 'Create New Account',
          style: TextButton.styleFrom(fixedSize: const Size.fromHeight(48)),
          onPressed: () => context.go(R.registerWithoutLeading),
        ),
      ],
    );
  }
}

class _AllSavedCredentialsContent extends WatchingWidget {
  const _AllSavedCredentialsContent();

  @override
  Widget build(BuildContext context) {
    final manager = di<AuthManager>();

    final accounts = watchValue((AuthManager m) => m.accounts);
    final lastKnownUser = watchValue((AuthManager m) => m.lastKnownUser);
    final profile = watchValue((MyProfileManager m) => m.profile).toNullable();

    final lastKnownUserId = lastKnownUser.toNullable()?.id ?? Id.empty;

    final availableAccounts = accounts.values.toList();
    final selectedCredential = accounts[lastKnownUserId];

    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...availableAccounts.map((credential) {
          final user = credential.user;
          return RadioGroup(
            key: ValueKey(user.id),
            groupValue: selectedCredential?.user.id,
            onChanged: (value) {
              if (value == null) return;
              context.go(R.switchAccount(value.getOrCrash()));
            },
            child: RadioListTile(
              value: user.id,
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: const .fromLTRB(16, 0, 14, 0),
              title: Row(
                children: [
                  MAvatar(radius: 20, url: user.image?.getUrl()),
                  Spaces.horizontalLarge,
                  MText(
                    user.fullName.getOrCrash(),
                    style: textTheme.bodyRegular,
                  ),
                ],
              ),
            ),
          );
        }),
        Spaces.verticalSmall,
        MModalListTile(
          leading: const Icon(MIcons.plus_circle),
          title: 'Add account',
          titleColor: colors.primary,
          contentPadding: const .fromLTRB(16, 0, 16, 0),
          onTap: () {
            context.pop();
            manager.addAccount.run();
          },
        ),
        Spaces.verticalSmall,
        MModalListTile(
          leading: const Icon(MIcons.log_out),
          title: 'Logout',
          titleColor: colors.error,
          onTap: () => _onLogout(context, profile),
          contentPadding: const .fromLTRB(16, 0, 16, 0),
        ),
      ],
    );
  }

  Future<void> _onLogout(BuildContext context, Profile? profile) async {
    final fullName = profile?.fullName.getOrElse((_) => 'this account');
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Log out from account?',
      description: 'You are about to log out from $fullName',
    );
    if (confirmed ?? false) di<AuthManager>().logout.run();
  }
}
