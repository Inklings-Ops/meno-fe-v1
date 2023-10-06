import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/features/auth/application/auth/auth_notifier.dart';
import 'package:meno_fe_v1/features/auth/domain/entities/user.dart';
import 'package:meno_fe_v1/features/auth/domain/entities/user_credentials.dart';
import 'package:meno_fe_v1/router/m_router.dart';

class MSwitchAccountModal extends HookConsumerWidget {
  const MSwitchAccountModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;

    final User currentUser = ref.watch(userProvider);
    final Map<String, UserCredentials> map = ref.watch(credentialsProvider);
    final int length = map.entries.length;
    final List<String> userIds = map.keys.toList();
    final List<UserCredentials> userCredentials = map.values.toList();

    Future? dialog;

    ref.listen(authProvider, (previous, next) {
      if (next.loading && dialog == null) {
        dialog = showDialog(
          context: context,
          builder: (context) => Center(
            child: Container(
              height: MediaQuery.sizeOf(context).width * 0.2,
              width: MediaQuery.sizeOf(context).width * 0.2,
              decoration: BoxDecoration(
                color: colorScheme.background,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Assets.images.loading.image(),
            ),
          ),
        );
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
          RadioListTile(
            value: currentUser.id == userIds[i],
            groupValue: true,
            onChanged: (v) {
              ref
                  .watch(authProvider.notifier)
                  .switchAccount(userCredentials[i]);
            },
            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
            dense: true,
            title: Row(
              children: [
                MAvatar(radius: 20, url: userCredentials[i].user.imageUrl),
                MSize.horizontalSpaceLarge,
                MText(
                  userCredentials[i].user.fullName.get()!,
                  style: MTextStyle.bodyRegular,
                ),
              ],
            ),
          ),
        ],
        24.verticalSpace,
        InkWell(
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
        ),
      ],
    );
  }
}
