import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/profile/profile.dart';
import 'package:meno/src/_shared/_shared.dart';
import 'package:meno/src/features/auth/manager/auth_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';

class SwitchAccountModal extends WatchingWidget {
  const SwitchAccountModal._() : super(key: null);

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: 'Switch Account',
      builder: (context) => const _AllSavedCredentialsContent(),
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

class _AllSavedCredentialsContent extends WatchingWidget {
  const _AllSavedCredentialsContent();

  @override
  Widget build(BuildContext context) {
    final auth = di<AuthManager>();

    final accounts = watchValue((AuthManager m) => m.accounts);
    final lastKnownUserId = watchValue((AuthManager m) => m.lastKnownUser).id;

    final availableAccounts = accounts.values.toList();
    final selectedCredential = accounts[lastKnownUserId];

    final profile = watchValue((MyProfileManager m) => m.profile).toNullable();

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
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 14, 0),
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
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          onTap: () {
            context.pop();
            auth.addAccount.run();
          },
        ),
        Spaces.verticalSmall,
        MModalListTile(
          leading: const Icon(MIcons.log_out),
          title: 'Logout',
          titleColor: colors.error,
          onTap: () => _onLogout(context, profile),
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        ),
      ],
    );
  }

  Future<void> _onLogout(BuildContext context, Profile? profile) async {
    final fullName = profile?.fullName.getOrNull() ?? 'this account';
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Log out from account?',
      description: 'You are about to log out from $fullName',
    );
    if (confirmed ?? false) di<AuthManager>().logout.run();
  }
}
