import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/value_objects/image_value_objects.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/manager/auth_manager.dart';
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
    final user = watchValue((UserManager m) => m.currentUser);
    final accounts = watchValue((UserManager m) => m.accounts);
    final lastKnownUserId = watchValue((UserManager m) => m.lastKnownUser).id;

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
            di<AuthManager>().addAccount.run();
          },
        ),
        Spaces.verticalSmall,
        MModalListTile(
          leading: const Icon(MIcons.log_out),
          title: 'Logout',
          titleColor: colors.error,
          onTap: () => _onLogout(
            context,
            user.fullName.getOrElse((_) => 'this account'),
          ),
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        ),
      ],
    );
  }

  Future<void> _onLogout(BuildContext context, String fullName) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Log out from account?',
      description: 'You are about to log out from $fullName',
    );
    if (confirmed ?? false) di<AuthManager>().logout.run();
  }
}
