import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../features/auth/application/application.dart';
import '../../features/auth/domain/domain.dart';
import '../../router/router.dart';

class MSwitchAccountModal extends HookConsumerWidget {
  const MSwitchAccountModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool hasOneAccount = ref.watch(hasOneAccountProvider);

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
              context.go(Routes.login);
            },
          ),
          (r) => dialog = null,
        ),
      );
    });

    if (hasOneAccount) {
      return const _SwitchAccountModal1();
    } else {
      return const _SwitchAccountModal2();
    }
  }
}

class _AccountListTile extends ConsumerWidget {
  final UserCredentials credentials;

  const _AccountListTile({
    super.key,
    required this.credentials,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = MTextTheme.of(this);

    final currentUser = ref.watch(userProvider);
    final userAccount = credentials.user;
    final key = ObjectKey(userAccount);

    return RadioListTile<User>(
      key: key,
      value: userAccount,
      groupValue: currentUser,
      onChanged: (_) =>
          ref.read(authProvider.notifier).switchAccount(credentials),
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
      dense: true,
      title: Row(
        children: [
          MAvatar(radius: 20, url: userAccount.imageUrl),
          MCore.large.horizontalSpace,
          MText(
            userAccount.fullName.get()!,
            style: textTheme?.bodyRegular,
          ),
        ],
      ),
    );
  }
}

class _AddAccountTile extends ConsumerWidget {
  const _AddAccountTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = MColorScheme.of(context)!;

    return InkWell(
      onTap: () {
        context.pop();
        ref.read(authProvider.notifier).logout();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: MCore.small,
          horizontal: MCore.large,
        ),
        child: Row(
          children: [
            const Icon(MIcons.plus_circle),
            MCore.medium.horizontalSpace,
            Expanded(
              child: MText(
                "Add Account",
                style: MTextTheme.of(context)?.bodyMedium,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchAccountModal1 extends ConsumerWidget {
  const _SwitchAccountModal1();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MModal(
      title: "Switch Account",
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MPrimaryButton(
            label: "Log in to Existing Account",
            onPressed: () {
              context.pop();
              ref.read(authProvider.notifier).logout();
              context.goNamed(Routes.login);
            },
          ),
          MTextButton(
            label: "Create New Account",
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

class _SwitchAccountModal2 extends ConsumerWidget {
  const _SwitchAccountModal2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<UserCredentials> allCredentials =
        ref.watch(allCredentialsProvider);

    return MModal(
      title: "Switch Account",
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (UserCredentials credentials in allCredentials) ...[
            _AccountListTile(credentials: credentials)
          ],
          const SizedBox(height: 24),
          const _AddAccountTile(),
        ],
      ),
    );
  }
}
