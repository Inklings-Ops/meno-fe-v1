import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/features/auth/domain/entities/user.dart';

class UserAccountDetails extends ConsumerWidget {
  final User user;
  final VoidCallback? action;
  const UserAccountDetails({super.key, required this.user, this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 74,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: action != null
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.center,
              children: [
                const MText(
                  "Welcome back,",
                  style: MTextStyle.subheadingMedium,
                ),
                MText(
                  user.fullName.get()!,
                  style: MTextStyle.heading2Medium,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: action,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MAvatar(radius: 24, url: user.imageUrl),
                if (action != null) ...[
                  MSize.verticalSpaceSmall,
                  MText(
                    "Switch account",
                    style: MTextStyle.captionMedium,
                    color: MColorScheme.of(context)?.primary,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
