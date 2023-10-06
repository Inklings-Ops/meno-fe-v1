import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/core/extensions/m_extensions.dart';
import 'package:meno_fe_v1/features/auth/application/auth/auth_notifier.dart';
import 'package:meno_fe_v1/features/auth/domain/entities/user.dart';
import 'package:meno_fe_v1/features/auth/domain/entities/user_credentials.dart';
import 'package:meno_fe_v1/router/m_router.dart';

class MSwitchAccountModal extends HookConsumerWidget {
  const MSwitchAccountModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<UserCredentials> allCredentials =
        ref.watch(allCredentialsProvider);
    final int length = allCredentials.length;

    Future<void>? dialog;

    ref.listen(authProvider, (previous, next) {
      if (next.loading && dialog == null) {
        dialog = context.showLoadingDialog();
      }

      next.option.fold(
        () => null,
        (either) => either.fold(
          (failure) => failure.mapOrNull(
            userTokenExpired: (_) {
              // TODO: Show snackbar
              context.router.replaceAll([LoginRoute()]);
            },
          ),
          (r) {
            dialog = null;
            context.replaceRoute(const MLayoutRoute());
          },
        ),
      );
    });

    return MModal(
      title: "Switch Account",
      children: [
        for (var i = 0; i < length; i++) ...[
          _AccountListTile(credentials: allCredentials[i]),
        ],
        24.verticalSpace,
        const _AddAccountTile(),
      ],
    );
  }
}

class _AccountListTile extends ConsumerWidget {
  final UserCredentials credentials;

  const _AccountListTile({
    Key? key,
    required this.credentials,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User currentUser = ref.watch(userProvider);
    final User userAccount = credentials.user;
    final ObjectKey key = ObjectKey(userAccount);

    return RadioListTile<User>(
      key: key,
      value: userAccount,
      groupValue: currentUser,
      onChanged: (_) => ref.read(authProvider.notifier).switchAccount(credentials),
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
      dense: true,
      title: Row(
        children: [
          MAvatar(radius: 20, url: userAccount.imageUrl),
          MSize.horizontalSpaceLarge,
          MText(
            userAccount.fullName.get()!,
            style: MTextStyle.bodyRegular,
          ),
        ],
      ),
    );
  }
}

class _AddAccountTile extends StatelessWidget {
  const _AddAccountTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;

    return InkWell(
      onTap: () => context.replaceRoute(LoginRoute()),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: MCore.small,
          horizontal: MCore.large,
        ),
        child: Row(
          children: [
            const Icon(MIcons.plus_circle),
            MSize.horizontalSpaceMedium,
            Expanded(
              child: MText(
                "Add Account",
                style: MTextStyle.bodyMedium,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
